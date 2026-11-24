
USE DEMO_DB;
-- Alter existing policies 

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

USE ROLE ACCOUNTADMIN;



alter masking policy phone_policy set body ->
case        
 when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
 else '**-**-**'
 end;

            
  ALTER TABLE CUSTOMERS MODIFY COLUMN email UNSET MASKING POLICY;
  
