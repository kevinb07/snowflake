USE DATABASE TASK_DB;

CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '60 MINUTE'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
  
  
  
  
CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7,10 * * 5L UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
    

# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
# * * * * *


// Every minute
SCHEDULE = 'USING CRON * * * * * UTC';

// Every day at 8 pm UTC
SCHEDULE = 'USING CRON 0 20 * * * UTC';

// Run at 8 pm UTC on 1st, 2nd, 3rd of the month (RANGE: 1-3)
SCHEDULE = 'USING CRON 0 20 1-3 * * UTC';

// Run at 8 pm UTC on 1st and 15th of the month (1,15)
SCHEDULE = 'USING CRON 0 20 1,15 * * UTC';

// Every day at 6am UTC timezone
SCHEDULE = 'USING CRON 0 6 * * * UTC';

// Every hour starting at 9 AM and ending at 5 PM on Sundays 
SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles';


CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 9,17 * * * UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
  
  
  