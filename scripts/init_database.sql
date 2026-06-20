/*
=====================================================
Create Database and Schemas
=====================================================
Script Purpose:
	This script creates a new database named 'RodrigoDataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'RodrigoDataWarehouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution
	and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Create Database 'DataWarehouse'
-- Drop and recreate the 'RodrigoDataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RodrigoDataWarehouse')
BEGIN
	ALTER DATABASE RodrigoDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE RodrigoDataWarehouse;
END;
GO

-- Create the 'RodrigoDataWarehouse' database
CREATE DATABASE RodrigoDataWarehouse;
GO


USE RodrigoDataWarehouse;
GO

-- create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

