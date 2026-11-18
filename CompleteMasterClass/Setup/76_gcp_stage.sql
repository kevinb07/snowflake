create or replace database demo_db;

-- create file format
create or replace file format demo_db.public.fileformat_gcp
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage demo_db.public.stage_gcp
    STORAGE_INTEGRATION = gcp_integration
    URL = 'gcs://kbsnowflake'
    FILE_FORMAT = fileformat_gcp;

LIST @demo_db.public.stage_gcp;