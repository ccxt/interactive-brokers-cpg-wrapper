# Stage 1: download and extract the official gateway from Interactive Brokers.
FROM alpine:3.20 AS fetch

ARG GATEWAY_URL=https://download2.interactivebrokers.com/portal/clientportal.gw.zip

# BuildKit checks the remote file on each build and re-downloads it when it changes.
ADD ${GATEWAY_URL} /tmp/clientportal.gw.zip

RUN echo "Downloaded from: ${GATEWAY_URL}" \
    && sha256sum /tmp/clientportal.gw.zip \
    && mkdir -p /gateway \
    && unzip -q /tmp/clientportal.gw.zip -d /gateway \
    && test -f /gateway/dist/ibgroup.web.core.iblink.router.clientportal.gw.jar

# Stage 2: runtime image.
FROM eclipse-temurin:11-jre

WORKDIR /app

COPY --from=fetch /gateway/dist ./dist
COPY --from=fetch /gateway/build/lib/runtime ./build/lib/runtime
COPY --from=fetch /gateway/root ./root

# Container-specific overrides (see README for the differences from the official files).
COPY config/ ./root/

RUN mkdir -p /app/logs

ENV JAVA_OPTS=""

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD bash -c '</dev/tcp/127.0.0.1/5000' || exit 1

CMD exec java -server \
    -Dvertx.disableDnsResolver=true \
    -Djava.net.preferIPv4Stack=true \
    -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.SLF4JLogDelegateFactory \
    $JAVA_OPTS \
    -cp "root:dist/ibgroup.web.core.iblink.router.clientportal.gw.jar:build/lib/runtime/*" \
    ibgroup.web.core.clientportal.gw.GatewayStart \
    --conf ../root/conf.yaml
