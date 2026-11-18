-- create integration object that contains the access information
CREATE STORAGE INTEGRATION gcp_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://kbsnowflake', 'gcs://kbsnowflakejson');

  
-- Describe integration object to provide access
DESC STORAGE integration gcp_integration;

select "property", "property_value" from table(result_scan(last_query_id()))
where "property" = 'STORAGE_GCP_SERVICE_ACCOUNT';

-- COPY property_value
-- Go to Cloud Storage On GCP
-- select all buckets needed and click permissions
-- click "Add Principal"
-- Paste property_value into principal name
-- filter by cloud storage and select "Storage Admin"
-- click Save