CREATE OR REPLACE DATABASE SNOWPIPE;

-- create integration object that contains the access information
CREATE OR REPLACE STORAGE INTEGRATION azure_snowpipe_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID =  '<your-tenant-id>'  -- Active Directory Properties
  STORAGE_ALLOWED_LOCATIONS = ( 'azure://<your-container-url>'); -- container properties
  
-- Describe integration object to provide access
DESC STORAGE integration azure_snowpipe_integration;

---- Create file format & stage objects ----

-- create file format

create or replace file format snowpipe.public.fileformat_azure
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

-- create stage object
create or replace stage snowpipe.public.stage_azure
    STORAGE_INTEGRATION = azure_snowpipe_integration
    URL = 'azure://<your-container-url>'
    FILE_FORMAT = fileformat_azure;
    
-- list files
LIST @snowpipe.public.stage_azure;

