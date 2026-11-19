-- Ingestion >> Add files to Stage
-- Browse to audio folder and drop both files
-- SCHEMA: TB_VOC.MEDIA
-- STAGE: AUDIO
-- path: /audio
-- click Upload
-- Repeat for TB_VOC.MEDIA IMAGES /images

-- 05_media_ai.sql
-- Goal: Upload images + audio to Snowflake stages, map them to brands,
-- then use Cortex to (1) describe images and (2) transcribe audio.

USE ROLE SYSADMIN;
USE DATABASE TB_VOC;
USE WAREHOUSE TB_VOC_WH;



------------------------------------------------------------
-- 1) Verify stages exist + files are uploaded
------------------------------------------------------------
-- If these LIST commands return nothing, the upload step in Snowsight failed
-- or the files were uploaded into a subfolder.
LIST @TB_VOC.MEDIA.IMAGES;
LIST @TB_VOC.MEDIA.AUDIO;

------------------------------------------------------------
-- 2) Pick valid brand names from our dataset (copy one or two)
------------------------------------------------------------
SELECT DISTINCT TRUCK_BRAND_NAME
FROM TB_VOC.ANALYTICS.TRUCK_REVIEWS_V
ORDER BY 1;

------------------------------------------------------------
-- 3) Map media files to brands (edit brands if needed)
------------------------------------------------------------
USE SCHEMA TB_VOC.MEDIA;

-- Clean old mappings for this demo (optional)
DELETE FROM IMAGE_TABLE WHERE IMAGE_PATH IN ('image-1.png','image-2.jpg');
DELETE FROM AUDIO_TABLE WHERE AUDIO_PATH IN ('audios/audio-1.mp3');

-- ✅ Replace brand names below with real ones from the SELECT above
INSERT INTO IMAGE_TABLE (TRUCK_BRAND_NAME, IMAGE_PATH, CAPTION)
VALUES
  ('Fiesta Taco Co', 'images/image-1.png', 'Demo image 1'),
  ('Sweet Street', 'images/image-2.jpg', 'Demo image 2');

INSERT INTO AUDIO_TABLE (TRUCK_BRAND_NAME, AUDIO_PATH, NOTES)
VALUES
  ('Fiesta Taco Co', 'audios/audio-1.mp3', 'Demo audio 1'),
  ('Sweet Street', 'audios/audio-2.mp3', 'Demo audio 2');

-- Check mappings
SELECT * FROM IMAGE_TABLE;
SELECT * FROM AUDIO_TABLE;

------------------------------------------------------------
-- 4) Image → text (describe images)
------------------------------------------------------------

SELECT
  TRUCK_BRAND_NAME,
  IMAGE_PATH,
  AI_COMPLETE(
    'claude-3-5-sonnet',
    'Describe what you see in this image in 1-2 sentences. Be concrete.',
    TO_FILE('@TB_VOC.MEDIA.IMAGES', IMAGE_PATH)
  ) AS IMAGE_DESCRIPTION
FROM IMAGE_TABLE;

------------------------------------------------------------
-- 5) Audio → text (transcribe audio)
------------------------------------------------------------


SELECT
  TRUCK_BRAND_NAME,
  AUDIO_PATH,
  AI_TRANSCRIBE(
    TO_FILE('@TB_VOC.MEDIA.AUDIO', AUDIO_PATH)
  ) AS TRANSCRIPTION_RESULT
FROM AUDIO_TABLE;

------------------------------------------------------------
-- 6) Materialize outputs (recommended for repeatable demos)
------------------------------------------------------------


CREATE OR REPLACE TABLE IMAGE_INSIGHTS AS
SELECT
  TRUCK_BRAND_NAME,
  IMAGE_PATH,
  AI_COMPLETE(
    'claude-3-5-sonnet',
    'Describe what you see in this image in 1-2 sentences. Be concrete.',
    TO_FILE('@TB_VOC.MEDIA.IMAGES', IMAGE_PATH)
  ) AS IMAGE_DESCRIPTION
FROM IMAGE_TABLE;

CREATE OR REPLACE TABLE AUDIO_TRANSCRIPTS AS
SELECT
  TRUCK_BRAND_NAME,
  AUDIO_PATH,
  AI_TRANSCRIBE(
    TO_FILE('@TB_VOC.MEDIA.AUDIO', AUDIO_PATH)
  ) AS TRANSCRIPTION_RESULT
FROM AUDIO_TABLE;

-- Validate tables
SELECT * FROM IMAGE_INSIGHTS;
SELECT * FROM AUDIO_TRANSCRIPTS;

------------------------------------------------------------
-- 7) Bridge back to text analytics (optional mini-demo)
------------------------------------------------------------


SELECT
  TRUCK_BRAND_NAME,
  TRANSCRIPTION_RESULT::STRING AS TRANSCRIPT_TEXT,
  AI_SENTIMENT(TRANSCRIPTION_RESULT::STRING) AS SENTIMENT_SCORE
FROM AUDIO_TRANSCRIPTS;



REMOVE @TB_VOC.MEDIA.IMAGES;
REMOVE @TB_VOC.MEDIA.AUDIO;

DROP DATABASE TB_VOC;
DROP WAREHOUSE TB_VOC_WH;


SELECT '05_media_ai.sql complete' AS NOTE;