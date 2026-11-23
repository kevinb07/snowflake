-- ******* How Changes are captured ********
USE STREAMS_DB_OFFSET.PUBLIC;

SELECT * FROM SALES_RAW_STAGING;     
        
SELECT * FROM SALES_STREAM;

-- update 1
UPDATE SALES_RAW_STAGING
SET PRODUCT ='Potato' WHERE PRODUCT = 'Banana';
-- update 2
UPDATE SALES_RAW_STAGING
SET PRODUCT ='Potato-NEW' WHERE PRODUCT = 'Potato';

UPDATE SALES_RAW_STAGING
SET PRODUCT ='Potato-NEW2' WHERE PRODUCT = 'Potato-NEW';

// 3 Consecutive updates on same record without consumption results to one single UPDATE!
SELECT * FROM SALES_STREAM;