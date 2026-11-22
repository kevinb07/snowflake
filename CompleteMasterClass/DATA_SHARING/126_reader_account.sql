USE ROLE ACCOUNTADMIN;

-- Create Reader Account --
CREATE MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_joy_admin,
ADMIN_PASSWORD = 'set-pwd',
TYPE = READER;

// Make sure to have selected the role of accountadmin
// Show accounts
SHOW MANAGED ACCOUNTS;

-- Share the data -- 
ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = <reader-account-id>; 
// (Under Horizon Catalog > Data Sharing > External Sharing > Reader Accounts > LOCATOR [OW45605])

ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = <reader-account-id>
SHARE_RESTRICTIONS = false;

-- Create database from share --
// Show all shares (consumer & producers)
SHOW SHARES;

// See details on share
DESC SHARE QNA46172.ORDERS_SHARE;

// Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE; -- VSWBGGQ.GD29410

// Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS;

// Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE ='X-SMALL'
AUTO_SUSPEND = 180  -- 3 mins
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- Create and set up users --
// Create user
CREATE USER MYRIAM PASSWORD = 'difficult_passw@ord=123';

// Grant usage on warehouse
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;

// Grating privileges on a Shared Database for other users
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO ROLE PUBLIC;
