select * 
from DBT.DBT_KB.TEST
limit 10;

select 
    'drop schema CI.'||schema_name||';'
from CI.INFORMATION_SCHEMA.SCHEMATA
where catalog_name = 'CI'
  and schema_name ilike 'PR%'
  and last_altered <= (current_date() - interval '-1 days');

select distinct type
from DBT.DBT_KB_MARTS.STABLECOIN_PER_DAY_V2
limit 10;

SELECT *
FROM DBT.DBT_KB.TOKEN_TRANSFERS_AGG
LIMIT 10;


select * from DBT.DBT_KB_dbt_test__audit.relationships_stg_transactions_183ff0a9502255079710d2c256042c0e;


select
      max(to_timestamp(date)) as max_loaded_at,
      convert_timezone('UTC', current_timestamp()) as snapshotted_at
    from eth.eth_schema.transactions

select * from dbt.dbt_kb_marts.customers;