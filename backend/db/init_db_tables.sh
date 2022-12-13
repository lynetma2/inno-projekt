#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE APIKeys (Key char(30) UNIQUE NOT NULL, UseCount integer NOT NULL);
    CREATE TABLE Paints (
        id uuid primary key default gen_random_uuid(),
        Name varchar(255) UNIQUE NOT NULL,
        productID integer,
        surfaceDry integer,
        recoatDry integer,
        curingTime integer,
        url varchar(1024),
        ImgURL varchar(1024)
    );
EOSQL
#varchar size ok?
