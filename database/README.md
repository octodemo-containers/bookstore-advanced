# bookstore database

This is a container image of the bookstore database backed by a PostgreSQL database.

The container is built to include some boostrapping scripts that will configure and initialize the database so that it can be used by the bookstore application.


The `populate.sql` script is used to initialize the database and insert tow book records.

## Usage

There are three environment variables that can be used to configure the container and the database that it will present:

* `POSTGRES_USER`: The name of the user for the database
* `POSTGRES_PASSWORD`: The password for the user of the database
* `POSTGRES_DB`: The name of the database to be created, e.g. `bookstore`

If you want to persist the data outside of the container to provide a stateful database then you will need to provide a volume mount for the path `/var/lib/postgresql/data`.
