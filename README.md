# Interactive Brokers Client Portal Gateway

You need to [intall Docker](https://docs.docker.com/engine/install/) at first to use this repository, as this is a dockerized IBKR Client-Portal Gateway.

When you run docker, the **Client-Portal Gateway** is automatically downloaded from [original IBKR website](https://download2.interactivebrokers.com/portal/clientportal.gw.zip) and automatically used thereafter, so you are guaranteed to be using original IBKR files.

## Usage

- [Download this repo](https://github.com/ccxt/interactive-brokers-cpg-wrapper/archive/refs/heads/master.zip)
- Unpack & enter the folder and run: `docker compose up -d --build`
- Then open `https://localhost:5000` in your browser and log in with your IBKR credentials (the certificate is self-signed, so accept the browser warning).
- *Note: If the port `5000` is already occupied (e.g. you have a macOS & AirPlay), at first change the port mapping in `docker-compose.yml` from `"5000:5000"` to e.g. `"5001:5000"` before starting it and then use `5001` port in the browser and also in CCXT explicitly pass the non-default port as [instructed here](https://github.com/ccxt/ccxt/blob/master/wiki/FAQ.md#how-to-use-the-interactivebrokers-in-ccxt)*

To see the logs, use `docker compose logs -f`.  

## Options

If you want to customize the gateway options, edit `config/conf.yaml` before running docker.


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
