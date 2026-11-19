

  -- Go To Azure Portal
  -- Go to storage account kbsnowflake
  -- click Queue
  -- Add Queue "snowpipequeue"
  -- Click Events
  -- Click +Event Subscription
  -- Name: snowpipenots
  -- System Topic Name: snowpipenots
  -- In Filter to Event Types: select "Blob Created" only
  -- Endpoint Type: choose "Storage Queue"
  -- Endpoint: click "Configure an endpoint" >> search and select snowpipequeue
  -- Click Create

  -- Make sure to register resource provider Microsoft.EventGrid in subscriptions section

USE DATABASE snowflake;

CREATE OR REPLACE NOTIFICATION INTEGRATION snowpipe_event
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://<your-container>.queue.core.windows.net/<your-queue-name>'
  AZURE_TENANT_ID = '<your-tenant-id>';

  
  -- Register Integration  
DESC notification integration snowpipe_event;

-- Grant consent by clicking and accept 
-- value of AZURE_CONSENT_URL
-- AZURE_MULTI_TENANT_APP_NAME: uoqpicsnowflakepacint
-- Grant Storage Queue Data Contributor to uoqpicsnowflakepacint on storage account
  