-- 03_llm_qa.sql
-- Goal: Ask higher-level questions using AI_COMPLETE

USE ROLE SYSADMIN;
USE WAREHOUSE TB_VOC_WH;
USE DATABASE TB_VOC;
USE SCHEMA TB_VOC.ANALYTICS;

-- Confirm concatenated context table exists
SELECT TRUCK_BRAND_NAME, LEFT(ALL_REVIEWS_TEXT, 200) AS CONTEXT_PREVIEW
FROM CONCATENATED_REVIEWS;

SELECT * FROM CONCATENATED_REVIEWS;

---------------------------------------------------------
-- 1️⃣ Top mentioned dish
---------------------------------------------------------

SELECT
  TRUCK_BRAND_NAME,
  AI_COMPLETE(
    'openai-gpt-4.1',
    'Context: ' || ALL_REVIEWS_TEXT ||
    ' Question: What is the most positively mentioned dish? ' ||
    'Answer with only the dish name.'
  ) AS TOP_DISH
FROM CONCATENATED_REVIEWS;

-- if model not available in region
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY REGION'; 

---------------------------------------------------------
-- 2️⃣ Biggest complaint
---------------------------------------------------------

SELECT
  TRUCK_BRAND_NAME,
  AI_COMPLETE(
    'openai-gpt-4.1',
    'Context: ' || ALL_REVIEWS_TEXT ||
    ' Question: What is the biggest recurring complaint from customers? ' ||
    'Answer briefly in one sentence.'
  ) AS TOP_COMPLAINT
FROM CONCATENATED_REVIEWS;