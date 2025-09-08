CREATE SCHEMA IF NOT EXISTS etl;

CREATE TABLE IF NOT EXISTS etl.customers (
    id SERIAL PRIMARY KEY,
    height_in_inches FLOAT,
    weight_in_pounds FLOAT
);

COPY etl.customers(height_in_inches, weight_in_pounds)
FROM '/docker-entrypoint-initdb.d/customers.csv'
DELIMITER ','
CSV HEADER;