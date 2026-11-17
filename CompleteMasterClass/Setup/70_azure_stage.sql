USE DATABASE OUR_FIRST_DB;  
---- Create file format & stage objects ----

-- create file format
create or replace file format OUR_FIRST_DB.public.fileformat_azure
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage OUR_FIRST_DB.public.stage_azure
    STORAGE_INTEGRATION = azure_integration
    URL = 'azure://kbsnowflake.blob.core.windows.net/csv'
    FILE_FORMAT = fileformat_azure;
    

-- list files
LIST @OUR_FIRST_DB.public.stage_azure;
