USE STREAMS_DB;

-- check if stream has any data
SELECT SYSTEM$STREAM_HAS_DATA('SALES_STREAM');

------- Automatate the updates using tasks ---
CREATE OR REPLACE TASK all_data_changes
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM') -- condition to check if stream has any data
    AS 
MERGE INTO SALES_FINAL_TABLE F      -- Target table to merge changes from source table
USING ( SELECT STRE.*,ST.location,ST.employees
        FROM SALES_STREAM STRE
        JOIN STORE_TABLE ST
        ON STRE.store_id = ST.store_id
       ) S 
       ON F.id=S.id
WHEN MATCHED                        -- DELETE condition
    AND S.METADATA$ACTION ='DELETE' 
    AND S.METADATA$ISUPDATE = 'FALSE'
    THEN DELETE                   
WHEN MATCHED                        -- UPDATE condition
    AND S.METADATA$ACTION ='INSERT' 
    AND S.METADATA$ISUPDATE  = 'TRUE'       
    THEN UPDATE 
    SET f.product = s.product,
        f.price = s.price,
        f.amount= s.amount,
        f.store_id=s.store_id
WHEN NOT MATCHED 
    AND S.METADATA$ACTION ='INSERT'
    THEN INSERT 
    (id, product, price, store_id, amount, employees, location)
    VALUES
    (s.id, s.product, s.price, s.store_id, s.amount, s.employees, s.location);

ALTER TASK all_data_changes RESUME;
SHOW TASKS;

// Change Data
INSERT INTO SALES_RAW_STAGING VALUES (11,'Milk',1.99,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (12,'Chocolate',4.49,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (13,'Cheese',3.89,1,1);

UPDATE SALES_RAW_STAGING
SET PRODUCT = 'Chocolate bar'
WHERE PRODUCT ='Chocolate';
       
DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Mango';    

// Verify results
SELECT * FROM SALES_RAW_STAGING;     
        
SELECT * FROM SALES_STREAM;

SELECT * FROM SALES_FINAL_TABLE;

// Verify the history
SELECT *
FROM TABLE(information_schema.task_history())
ORDER BY NAME ASC, scheduled_time DESC;


-- cleanup
DROP TASK all_data_changes;