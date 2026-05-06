/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    Creates the DataWarehouse database and sets up three schemas:
    bronze, silver, and gold.

WARNING:
    Running this will drop the DataWarehouse database if it exists.
    All data will be permanently deleted.
=============================================================
*/

-- Drop and recreate the DataWarehouse database
DROP DATABASE IF EXISTS DataWarehouse;
CREATE DATABASE DataWarehouse;

-- Connect to DataWarehouse then run:
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
