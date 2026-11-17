
USE DATABASE OUR_FIRST_DB;

-- create integration object that contains the access information
CREATE STORAGE INTEGRATION azure_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = '2f81442d-c401-4406-83ca-67f586cc99f7' -- search for "Tenant Properties" in Azure Portal
  STORAGE_ALLOWED_LOCATIONS = ('azure://kbsnowflake.blob.core.windows.net/csv', 'azure://kbsnowflake.blob.core.windows.net/json');

  
-- Describe integration object to provide access
DESC STORAGE integration azure_integration;

select "property", "property_value" from table(result_scan(last_query_id()))
where "property" = 'AZURE_CONSENT_URL' or "property" = 'AZURE_MULTI_TENANT_APP_NAME';

-- Click on link
-- Take note of the object name : z8ox2qsnowflakepacint
-- Check Consent
-- Click Accept

// Grant permissions on Azure
--Go to Storage account
--Click "Access Control (IAM)"
--Add "+Add" and select "add role assignment"
--Search and select "Storage Blob Data Contributor" and click Next
--Click "+ Select members"
--Search and select z8ox2qsnowflakepacint
--Click "Select"
--Click "review + assign" twice

