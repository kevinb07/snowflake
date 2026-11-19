
-- arn:aws:s3:::kbsnowflakes301
-- arn:aws:iam::375575272448:role/snowflakes3bucket

/* IAM Policy arn:aws:iam::375575272448:policy/snowflakeaccesspolicy
{
 "Version": "2012-10-17",
 "Statement": [
     {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:GetObjectVersion",
           "s3:DeleteObject",
           "s3:DeleteObjectVersion"
         ],
         "Resource": "arn:aws:s3:::kbsnowflakes301/*"
     },
     {
         "Effect": "Allow",
         "Action": [
             "s3:ListBucket",
             "s3:GetBucketLocation"
         ],
         "Resource": "arn:aws:s3:::kbsnowflakes301",
         "Condition": {
             "StringLike": {
                 "s3:prefix": [
                     "<prefix>/*"
                 ]
             }
         }
     }
 ]
}
*/
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE STORAGE INTEGRATION S3_BUCKET
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::375575272448:role/snowflakes3bucket'
  STORAGE_ALLOWED_LOCATIONS = ( 's3://kbsnowflakes301/' );

  DESC INTEGRATION S3_BUCKET;

  SELECT "property", "property_value" from table(result_scan(last_query_id()))
  WHERE "property" = 'STORAGE_AWS_IAM_USER_ARN' or "property" = 'STORAGE_AWS_EXTERNAL_ID';

/* Trust RELATIONSHIPS
  {
  "Version": "2012-10-17",
  "Statement": [
 {
   "Sid": "",
   "Effect": "Allow",
   "Principal": {
     "AWS": "arn:aws:iam::042467473907:user/avwb2000-s"
   },
   "Action": "sts:AssumeRole",
   "Condition": {
     "StringEquals": {
       "sts:ExternalId": "YL18556_SFCRole=6_rm1/CK8dU/4RAP2diXGb+pMqGII="
     }
   }
 }
  ]
}
*/

SELECT SYSTEM$VALIDATE_STORAGE_INTEGRATION(
    'S3_BUCKET',
    's3://kbsnowflakes301/csv/',
    'netflix_titles.csv',
    'read'
);

create or replace stage s3


// Create storage integration object
CREATE OR REPLACE STORAGE INTEGRATION S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::375575272448:role/snowflakes3bucket'
  STORAGE_ALLOWED_LOCATIONS = ('s3://kbsnowflakes301/csv/', 's3://kbsnowflakes301/json/')
   COMMENT = 'Snowflake AWS S3 integration' ;
   
// See storage integration properties to fetch external_id so we can update it in S3
DESC INTEGRATION S3_INT;

// Update AWS Role (trust relationship) with the following property values:
-- STORAGE_AWS_IAM_USER_ARN: arn:aws:iam::042467473907:user/avwb2000-s
-- STORAGE_AWS_EXTERNAL_ID: YL18556_SFCRole=6_V1uzW6t25ysfvk1NO6xv16jfc+4=


SELECT SYSTEM$VALIDATE_STORAGE_INTEGRATION(
    'S3_INT',
    's3://kbsnowflakes301/csv/',
    'netflix_titles.csv',
    'read'
);

/* Trust RELATIONSHIPS

{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::042467473907:user/avwb2000-s"
			},
			"Action": "sts:AssumeRole",
			"Condition": {
				"StringEquals": {
					"sts:ExternalId": "YL18556_SFCRole=6_jJiF60LzGMPpwhaGZc0pWDvc0AQ="
				}
			}
		}
	]
}

*/

-- Error assuming AWS_ROLE: User: arn:aws:iam::042467473907:user/avwb2000-s is not authorized to perform: 
-- sts:AssumeRole on resource: arn:aws:iam::375575272448:role/snowflakeAccessRole