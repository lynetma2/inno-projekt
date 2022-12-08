FROM postgres:15
ENV POSTGRES_PASSWORD=bitconnect
COPY init_db_tables.sh /docker-entrypoint-initdb.d/
EXPOSE 5432
