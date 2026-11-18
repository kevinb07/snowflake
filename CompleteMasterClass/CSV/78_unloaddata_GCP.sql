------- Unload data -----
USE ROLE ACCOUNTADMIN;
USE DATABASE DEMO_DB;


-- create integration object that contains the access information
CREATE or replace STORAGE INTEGRATION gcp_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://kbsnowflake', 'gcs://kbsnowflakejson');
  
  
-- create file format
create or replace file format demo_db.public.fileformat_gcp
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage demo_db.public.stage_gcp
    STORAGE_INTEGRATION = gcp_integration
    URL = 'gcs://kbsnowflake/csv_happiness'
    FILE_FORMAT = fileformat_gcp
    compression = GZIP; -- data compression: default value = auto


ALTER STORAGE INTEGRATION gcp_integration
SET  storage_allowed_locations=('gcs://kbsnowflake', 'gcs://kbsnowflakejson');

SELECT * FROM HAPPINESS;

COPY INTO @stage_gcp
FROM HAPPINESS;