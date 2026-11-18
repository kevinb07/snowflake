USE SCHEMA manage_db.pipes;
-- Manage pipes -- 

DESC pipe MANAGE_DB.pipes.employee_pipe;

-- show all pipes
SHOW PIPES;

-- show pipes with employee in the pipe name
SHOW PIPES like '%employee%';

-- show all pipes in given database manage_db
SHOW PIPES in database MANAGE_DB;

-- show all pipes in given database schema manage_db.pipes
SHOW PIPES in schema MANAGE_DB.pipes;

-- show all pipes with employee in the name and in given database manage_db
SHOW PIPES like '%employee%' in Database MANAGE_DB;



-- Changing pipe (alter stage or file format) --


// Preparation table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees2 (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  );

-- Steps to do for change request
// Pause pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = true;

// Verify pipe is paused and has pendingFileCount 0 
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') ;
 
 // Recreate the pipe to change the COPY statement in the definition
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder ;

ALTER PIPE  MANAGE_DB.pipes.employee_pipe refresh;

// List files in stage
LIST @MANAGE_DB.external_stages.csv_folder ;

SELECT * FROM OUR_FIRST_DB.PUBLIC.employees2;

 // Reload files manually that where aleady in the bucket
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder;  


// Resume pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = false;

// Verify pipe is running again
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') ;
