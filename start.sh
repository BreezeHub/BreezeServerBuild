#!/bin/bash
# This script orchestrates the running of breezeserver's docker compose

# create volumes if they don't exist
docker volume create bitcoin-testnet-data
docker volume create stratis-testnet-data
docker volume create breezeserver-shared-testnet-data

# populate shared volume
docker run --rm -v breezeserver-shared-testnet-data:/shared --name=helper busybox true
docker cp breeze.conf helper:/hared/.breezeserver/breeze.conf
docker rm helper

# compose the breezeserver services
docker-compose up --build
