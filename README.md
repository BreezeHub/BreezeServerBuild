# BreezeServer build configuration

I've attempted to do this all within one container with separate users. This is the wrong way to do it.

The goal is to separate each service the server needs into their own containers

- stratisd
- bitcoind
- tor
- BreezeServer (ntumblebit)

1. stratisd
  An image for this exists at [stratisplatform/stratis-node/](https://hub.docker.com/r/stratisplatform/stratis-node/). We just have to figure out how to configure it. Probably can pass from command line. This container should be exposed on :26174. Needs a volume for the chain.
2. bitcoind
  There are a few different containers to run bitcoind. [kylemanna/docker-bitcoind](https://github.com/kylemanna/docker-bitcoind) Seems to be the most popular and is documented well. This should keep a volume with the (pruned) blockchain so it doesn't have to build on a user's machine. Pass it a config.
3. BreezeServer
  This should be able to run without tor. This image needs to be passed `server.config` and `breeze.conf`. needs to default to testnet
4. Tor
  Tor is a straigtforward process. Enable controlport 9051 to communicate with BreezeServer. Expose 9050 to the outside world
