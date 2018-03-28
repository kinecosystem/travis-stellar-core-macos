#!/bin/bash

rm -rf /usr/local/var/postgres
initdb /usr/local/var/postgres -E utf8
pg_ctl -D /usr/local/var/postgres start
createuser -s postgres
psql -c 'create database core;' -U postgres
psql -c 'create database horizon;' -U postgres

pg_ctl -V

./stellar/bin/stellar-core --conf ./stellar-core.cfg --newdb --forcescp
./stellar/bin/stellar-core --conf ./stellar-core.cfg &

sleep 2

./stellar/bin/stellar-core --conf ./stellar-core.cfg -c info

export DATABASE_URL=postgres://postgres@localhost/horizon?sslmode=disable
export STELLAR_CORE_DATABASE_URL=postgres://postgres@localhost/core?sslmode=disable
export STELLAR_CORE_URL=http://localhost:11626
export NETWORK_PASSPHRASE=private testnet
export INGEST=true

./horizon/horizon db init

./horizon/horizon serve &
