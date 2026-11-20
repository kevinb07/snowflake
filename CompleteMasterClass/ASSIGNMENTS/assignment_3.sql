

create or replace stage EXERCISE_DB.public.AWS_STAGE
    url=s3://snowflake-assignments-mc/loadingdata/

list @EXERCISE_DB.public.AWS_STAGE;

create or replace table Exercise_DB.public.customer 
(
ID INT,
first_name varchar,
last_name varchar,
email varchar,
age int,
city varchar
);

select count(*) from Exercise_DB.public.customer; 

copy into Exercise_DB.public.customer 
from @EXERCISE_DB.public.AWS_STAGE
    file_format= (type = csv field_delimiter=';' skip_header = 1)
