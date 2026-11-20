USE SCHEMA OUR_FIRST_DB.PUBLIC;
-- check settings for table like retention_time, changetracking etc..
SHOW TABLES like '%CUSTOMERS%';


-- if set to 0, time travel feature is disabled
ALTER TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS
    SET DATA_RETENTION_TIME_IN_DAYS = 1;

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.ret_example (
    id int,
    first_name string,
    last_name string,
    email string,
    gender string,
    Job string,
    Phone string )
DATA_RETENTION_TIME_IN_DAYS = 3;

SHOW TABLES like '%EX%';

DROP TABLE OUR_FIRST_DB.public.ret_example;
UNDROP TABLE OUR_FIRST_DB.public.ret_example;


ALTER TABLE OUR_FIRST_DB.public.ret_example
SET DATA_RETENTION_TIME_IN_DAYS = 0;