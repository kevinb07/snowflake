-- 02_text_ai.sql
-- Goal: Demonstrate AI functions on structured review data

USE ROLE SYSADMIN;
USE WAREHOUSE TB_VOC_WH;
USE DATABASE TB_VOC;
USE SCHEMA TB_VOC.ANALYTICS;

-- Sanity check confirm data exists
SELECT COUNT(*) AS total_reviews 
FROM TRUCK_REVIEWS_V;

-- Check language distribution
SELECT LANGUAGE, COUNT(*) 
FROM TRUCK_REVIEWS_V
GROUP BY LANGUAGE;


---------------------------------------------------------
-- 1️⃣ Translate non-English reviews
---------------------------------------------------------

SELECT
  REVIEW,
  LANGUAGE,
  AI_TRANSLATE(REVIEW, LANGUAGE, 'en') AS TRANSLATED_REVIEW
FROM TRUCK_REVIEWS_V
WHERE LANGUAGE <> 'en'
LIMIT 15;


---------------------------------------------------------
-- 2️⃣ Sentiment analysis
---------------------------------------------------------

SELECT
  TRUCK_BRAND_NAME,
  REVIEW,
  AI_SENTIMENT(REVIEW) AS SENTIMENT_SCORE
FROM TRUCK_REVIEWS_V
LIMIT 10;

-- Average sentiment per brand
SELECT
  TRUCK_BRAND_NAME,
  AVG(AI_SENTIMENT(REVIEW)) AS AVG_SENTIMENT
FROM TRUCK_REVIEWS_V
GROUP BY TRUCK_BRAND_NAME;


---------------------------------------------------------
-- 3️⃣ Classification (recommendation intent)
---------------------------------------------------------

SELECT
  REVIEW,
  AI_CLASSIFY(
    REVIEW,
    ['Likely','Unlikely','Unsure'],
    OBJECT_CONSTRUCT(
      'task_description',
      'Based on the review, will the customer recommend this food truck?'
    )
  ):labels[0]::STRING AS RECOMMEND
FROM TRUCK_REVIEWS_V
LIMIT 10;

SELECT
  REVIEW,
  AI_CLASSIFY(
    REVIEW,
    ['Yes','No'],
    OBJECT_CONSTRUCT(
      'task_description',
      'Based on the review, was there something negative in the review?'
    )
  ):labels[0]::STRING AS RECOMMEND
FROM TRUCK_REVIEWS_V
LIMIT 10;


---------------------------------------------------------
-- 4️⃣ Summarization by brand
---------------------------------------------------------
-- AI_SUMMARIZE_AGG(REVIEW): gets all reviews per group, feeds into model and gets back one summarized review
SELECT
  TRUCK_BRAND_NAME,
  AI_SUMMARIZE_AGG(REVIEW) AS SUMMARY
FROM TRUCK_REVIEWS_V
GROUP BY TRUCK_BRAND_NAME;