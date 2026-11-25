//it builds the empty environment for the demo. It creates an X-Small warehouse that suspends itself after 60 idle seconds, 
//a database called demo_db, and a schema called poc where the contract data table lives.

USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE demo_wh
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

CREATE DATABASE demo_db;
CREATE SCHEMA demo_db.poc;
