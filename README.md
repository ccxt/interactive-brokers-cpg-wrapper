# Interactive Brokers Client Portal Gateway

This is a dockerized IBKR CP Gateway - when you build the image, the original gateway is automatically downloaded from https://download2.interactivebrokers.com/portal/clientportal.gw.zip.


## Usage

```bash
docker compose up -d --build
```
Then open https://localhost:5000 in your browser and log in with your IBKR credentials
(the certificate is self-signed, so accept the browser warning). To see logs, use `docker compose logs -f`

You can also ensure it is authorized by running `curl -k https://localhost:5000/v1/api/iserver/auth/status`


## Options

If you want to customize the gateway options, edit `config/conf.yaml` before running docker. Note that `ips.allow` field also allows the private address ranges (`10.*`, `172.*`, `192.*`). Without this, the gateway rejects requests coming in through Docker's bridge network.


## Notes

The session lives in the container's memory. If the container restarts, you need to log in again.
To keep the session alive, your app should call `POST /v1/api/tickle` periodically.

## Updating the gateway

To force a fresh download of the latest official release:

```bash
docker compose build --no-cache
docker compose up -d
```


## License

MIT