# Backend

Should provide a REST API where users can send the name of a paint and their location. The response should be a list of time intervals suitable for painting.

## How to use
The command `docker compose up` starts the backend: The database, the scraper, and the server. When started, the REST API is accessible at port 8080, 
while the database is accessible at port 5432.

The command `psql -h localhost -p 5432 -U postgres` connects to the database, the password is "bitconnect"
(if running remotely, replace localhost with the hostname the database is running on.)

