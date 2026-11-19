USE DATABASE OUR_FIRST_DB;

// Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  );
    

// Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;
    
    
 // Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://kbsnowflakes301/csv/snowpipe'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat;
   

 // Create stage object with integration object & file format object
LIST @MANAGE_DB.external_stages.csv_folder;


// Create schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.pipes;

// Define pipe
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.external_stages.csv_folder ;


-- test copy command
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.external_stages.csv_folder ;
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.employees ;

// Describe pipe
DESC pipe employee_pipe;

select "notification_channel" from table(result_scan(last_query_id()));

// configure pipe in AWS
-- Go to AWS S3 bucket: kbsnowflake301
-- Click Properties tab
-- Under "Event notifications" click "create event notification"
    -- Event Name: SnowpipeCreateEvents
    -- Prefix: csv/snowpipe/
    -- Suffix: .csv
    -- Tick "All objects create events"
    -- Under Destination section
       -- choose "SQS queue"
       -- Choose "Enter SQS queue ARN" under Specify SQS queue
       -- Paste notification_channel value
       -- click save changes

-- drop a file (employee_data_2.csv) into s3 bucket (s3://kbsnowflakes301/csv/snowpipe) and wait for the magic to happen
SELECT count(*) FROM OUR_FIRST_DB.PUBLIC.employees ;