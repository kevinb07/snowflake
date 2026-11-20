use database our_first_db;

// Setting up table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.test;

// Use-case: Update data (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET LAST_NAME = 'Tyson';

UPDATE OUR_FIRST_DB.public.test
SET JOB = 'Data Analyst';

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01c88537-0004-eaa9-0003-fdaa001b3072');


// // // Bad method
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01c8853d-0004-e9b6-0003-fdaa001a3666');

SELECT * FROM OUR_FIRST_DB.public.test;

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01c88537-0004-e96c-0003-fdaa001b1a4e');


// // // Good method
-- create backup table with recovered data
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '01c88540-0004-e9b6-0003-fdaa001a3686');

-- truncate table
TRUNCATE OUR_FIRST_DB.public.test;

-- reInsert the data from backup table
INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test_backup;

-- check data is correct
SELECT * FROM OUR_FIRST_DB.public.test ;