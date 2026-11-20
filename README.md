# Interactive Brokers Client Portal Gateway

You need to [intall Docker](https://docs.docker.com/engine/install/) at first to use this repository, as this is a dockerized IBKR Client-Portal Gateway.

When you build the image, the original gateway is automatically downloaded from original IBKR website ([this link](https://download2.interactivebrokers.com/portal/clientportal.gw.zip)), so this repository itsef does not contain any IBKR files to ensure safety.

## Usage

- [Download this repo](https://github.com/ccxt/interactive-brokers-cpg-wrapper/archive/refs/heads/master.zip)
- Unpack & enter the folder and run:
```bash
docker compose up -d --build
```
- If port `5000` is already occupied (e.g. you have a macOS & AirPlay), at first change the port mapping in `docker-compose.yml` from `"5000:5000"` to e.g. `"5001:5000"` before starting it.
- Then open `https://localhost:5000` in your browser and log in with your IBKR credentials (the certificate is self-signed, so accept the browser warning).

Notes: To see logs, use `docker compose logs -f`.  You can also ensure it is authorized by running `curl -k https://localhost:5000/v1/api/iserver/auth/status`


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
