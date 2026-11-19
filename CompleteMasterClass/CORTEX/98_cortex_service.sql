-- 04_cortex_search.sql
-- Goal Build a Cortex Search Service and test it in Snowflake SQL

USE ROLE SYSADMIN;
USE DATABASE TB_VOC;
USE SCHEMA TB_VOC.ANALYTICS;

------------------------------------------------------------
-- 1) Create dedicated small warehouse for search refresh
------------------------------------------------------------
CREATE OR REPLACE WAREHOUSE TB_VOC_SEARCH_WH
  WAREHOUSE_SIZE = 'XSMALL'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE TB_VOC_SEARCH_WH;

------------------------------------------------------------
-- 2) Create Cortex Search Service
------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE TB_VOC.ANALYTICS.TRUCK_REVIEWS_SVC
  ON REVIEW
  ATTRIBUTES TRUCK_BRAND_NAME, PRIMARY_CITY, LANGUAGE, SOURCE, DATE
  WAREHOUSE = TB_VOC_SEARCH_WH
  TARGET_LAG = '1 hour' -- search index should be 1 hour or less
AS (
  SELECT
    REVIEW,
    REVIEW_ID,
    TRUCK_BRAND_NAME,
    PRIMARY_CITY,
    LANGUAGE,
    SOURCE,
    DATE
  FROM TB_VOC.ANALYTICS.TRUCK_REVIEWS_V
);

------------------------------------------------------------
-- 3) Inspect service
------------------------------------------------------------
SHOW CORTEX SEARCH SERVICES IN SCHEMA TB_VOC.ANALYTICS;
DESC CORTEX SEARCH SERVICE TB_VOC.ANALYTICS.TRUCK_REVIEWS_SVC;

------------------------------------------------------------
-- 4) Simple semantic search (no filters)
------------------------------------------------------------
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
  'TB_VOC.ANALYTICS.TRUCK_REVIEWS_SVC',
  '{
    query best tacos in town,
    limit 5
  }'
) AS RAW_RESULTS;

------------------------------------------------------------
-- 5) Filter example one brand
------------------------------------------------------------
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
  'TB_VOC.ANALYTICS.TRUCK_REVIEWS_SVC',
  '{ 
    query friendly service, 
    limit 5,
    filter { @eq { TRUCK_BRAND_NAME Fiesta Taco } }
  }'
) AS FILTERED_RESULTS;

------------------------------------------------------------
-- 6) Parsing JSON into rows
------------------------------------------------------------
SELECT
  valuedocumentREVIEW AS REVIEW_TEXT,
  valueattributesTRUCK_BRAND_NAME AS BRAND,
  valueattributesPRIMARY_CITY AS CITY
FROM TABLE(
  FLATTEN(
    INPUT = PARSE_JSON(
      SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'TB_VOC.ANALYTICS.TRUCK_REVIEWS_SVC',
        '{ 
          query spicy, 
          limit 5
        }'
      )
    )['results']
  )
);

SELECT '04_cortex_search.sql complete' AS NOTE;