CREATE DATABASE CI;
CREATE SCHEMA CI_SCHEMA;

CREATE DATABASE SEEDS;
CREATE SCHEMA DBT_KB_STATIC;
CREATE SCHEMA PROD_SCHEMA_STATIC;

CREATE DATABASE DBT;
CREATE SCHEMA DBT_KB;

CREATE DATABASE PROD;
CREATE SCHEMA PROD_SCHEMA;

CREATE DATABASE ETH;

USE ETH;
CREATE SCHEMA ETH.ETH_SCHEMA;


CREATE STAGE ETH.ETH_SCHEMA.TEST
url='s3://aws-public-blockchain/v1.0/eth/'
FILE_FORMAT = (TYPE = 'PARQUET');

LIST @ETH.ETH_SCHEMA.TEST;

CREATE OR REPLACE STAGE ETH.ETH_SCHEMA.CONTRACTS_STAGE
url='s3://aws-public-blockchain/v1.0/eth/contracts'
FILE_FORMAT = (TYPE = 'PARQUET');

CREATE OR REPLACE STAGE ETH.ETH_SCHEMA.TOKEN_TRANSFERS
url='s3://aws-public-blockchain/v1.0/eth/token_transfers'
FILE_FORMAT = (TYPE = 'PARQUET');

CREATE OR REPLACE STAGE ETH.ETH_SCHEMA.TRANSACTIONS
url='s3://aws-public-blockchain/v1.0/eth/transactions'
FILE_FORMAT = (TYPE = 'PARQUET');

CREATE OR REPLACE TABLE ETH.ETH_SCHEMA.CONTRACTS (
address STRING,
block_hash STRING,
block_number INT,
block_timestamp TIMESTAMP,
bytecode STRING,
date DATE,
last_modified TIMESTAMP
);

CREATE OR REPLACE TABLE ETH.ETH_SCHEMA.TOKEN_TRANSFERS (
block_hash STRING,
block_number INT,
block_timestamp TIMESTAMP,
date DATE,
from_address STRING,
to_address STRING,
last_modified TIMESTAMP,
log_index INT,
token_address STRING,
transaction_hash STRING,
value FLOAT
);

CREATE OR REPLACE TABLE ETH.ETH_SCHEMA.TRANSACTIONS (
block_hash STRING,
block_number INT,
block_timestamp TIMESTAMP,
date DATE,
from_address STRING,
gas INT,
gas_price STRING,
hash STRING,
input STRING,
last_modified TIMESTAMP,
max_fee_per_gas STRING,
max_priority_fee_per_gas STRING,
nonce STRING,
receipt_contract_address STRING,
receipt_cumulative_gas_used INT,
receipt_effective_gas_price STRING,
receipt_gas_used INT,
receipt_status INT,
to_address STRING,
transaction_index INT,
transaction_type INT,
value FLOAT
);

-- SET CURRENT_MONTH_PATTERN = (SELECT CONCAT('.*date=',TO_VARCHAR(CURRENT_DATE(),'YYYY-MM'),'.*'));

SET CURRENT_MONTH_PATTERN = '.*date=2025-11.*';
SELECT $CURRENT_MONTH_PATTERN;

COPY INTO ETH.ETH_SCHEMA.CONTRACTS
FROM (
select
t.$1:address,
t.$1:block_hash,
t.$1:block_number,
t.$1:block_timestamp,
t.$1:bytecode,
t.$1:date,
t.$1:last_modified
from @ETH.ETH_SCHEMA.CONTRACTS_STAGE t
)
PATTERN = $CURRENT_MONTH_PATTERN;

COPY INTO ETH.ETH_SCHEMA.TOKEN_TRANSFERS
FROM (
select
t.$1:block_hash,
t.$1:block_number,
t.$1:block_timestamp,
t.$1:date,
t.$1:from_address,
t.$1:to_address,
t.$1:last_modified,
t.$1:log_index,
t.$1:token_address,
t.$1:transaction_hash,
t.$1:value
from @ETH.ETH_SCHEMA.TOKEN_TRANSFERS t
)
PATTERN = $CURRENT_MONTH_PATTERN;

COPY INTO ETH.ETH_SCHEMA.TRANSACTIONS
FROM (
select
t.$1:block_hash,
t.$1:block_number,
t.$1:block_timestamp,
t.$1:date,
t.$1:from_address,
t.$1:gas,
t.$1:gas_price,
t.$1:hash,
t.$1:input,
t.$1:last_modified,
t.$1:max_fee_per_gas,
t.$1:max_priority_fee_per_gas,
t.$1:nonce,
t.$1:receipt_contract_address,
t.$1:receipt_cumulative_gas_used,
t.$1:receipt_effective_gas_price,
t.$1:receipt_gas_used,
t.$1:receipt_status,
t.$1:to_address,
t.$1:transaction_index,
t.$1:transaction_type,
t.$1:value

from @ETH.ETH_SCHEMA.TRANSACTIONS t
)
PATTERN = $CURRENT_MONTH_PATTERN;

-- select * from ETH.ETH_SCHEMA.TOKEN_TRANSFERS;


ALTER USER "kboodh007" SET RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvt8A2DHr6FtoS79KQOTS
ZlIQQ8sMJ87Ot0Vt/kCRb746Xa17vW98l2tUjqMNR6RzzgmF/ig6FMLsTPTUtF/5
JMSowC5zm3pYj3sEYaTpJhDJecq5xdFTK4jrkAJq7dbIPg1xfLNODL4F9dTqnlAO
71zETuBxq1o10+IRHR1HWwyZpULsx2sOQeqOWClo/ukhaPeaTgdjbitb+ybUWnHB
sPnfUa9e8Ef+CMKgdhm6gP4s1J3d1hv+UaO6zFc2Ldole/cGWTHw28+lfK+s6g27
yKJ/R9BCwKvRLbxLpu+nEouZmSIr1ccHQQjw2/ZOFE3f8MVKAb9qWgmMqjhKd2Ko
MwIDAQAB';

select current_user(), current_role();

show users like 'kboodh007';

desc user "kboodh007";

select current_account();

CREATE ROLE Tester;
CREATE ROLE BA;

dbt seed

create or replace table eth.eth_schema.contracts_clone
  clone eth.eth_schema.contracts;