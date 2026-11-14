CREATE DATABASE AIRBNB;
CREATE SCHEMA AIRBNB.AIRBNB;

CREATE OR REPLACE TABLE AIRBNB.AIRBNB.APARTMENT_LISTINGS (
LISTING_ID integer,
CITY string,
MONTHLY_RENT integer,
STATUS string,
UPDATED_AT timestamp_ntz
);

INSERT INTO AIRBNB.AIRBNB.APARTMENT_LISTINGS (LISTING_ID, CITY, MONTHLY_RENT, STATUS, UPDATED_AT) 
VALUES 
    (101, 'Paris', 1200, 'Available', current_timestamp()),
    (102, 'Berlin', 900, 'Available', current_timestamp());

SELECT * FROM AIRBNB.AIRBNB.APARTMENT_LISTINGS;

select * from dbt.dbt_kb.airbnb_snap order by listing_id, updated_at;

update airbnb.airbnb.apartment_listings
set status = 'Available',
updated_at = current_timestamp()
where listing_id = 102;

drop table dbt.dbt_kb.airbnb_snap;

select * from dbt.dbt_kb_snaps.airbnb_snap order by listing_id, updated_at;

delete from airbnb.airbnb.apartment_listings where listing_id = 101;