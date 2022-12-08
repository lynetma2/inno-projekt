#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE APIKeys (Key char(30) UNIQUE NOT NULL, UseCount integer NOT NULL);
    CREATE TYPE dryTime as (
        Temperature  real,
        humidity     real,
        time         interval
    );
    CREATE TABLE Paints (
        Name varchar(255) UNIQUE NOT NULL,
        productID integer,
        surfaceDry dryTime,
        recoatDry dryTime,
        curingTime dryTime,
        ImgURL varchar(1024)
    );
EOSQL
