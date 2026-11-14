SET CURRENT_MONTH_PATTERN = (select CONCAT('.*date=',TO_VARCHAR(CURRENT_DATE(),'YYYY-MM'),'.*'));
-- SELECT $CURRENT_MONTH_PATTERN;

COPY INTO ETH.ETH_SCHEMA.CONTRACTS
FROM (
select
t.$1:address,
t.$1:block_hash,
t.$1:block_number,
t.$1:block_timestamp,
t.$1:bytecode,
t.$1:date,
t.$1:last_modified
from @ETH.ETH_SCHEMA.CONTRACTS_STAGE t
)
PATTERN = $CURRENT_MONTH_PATTERN;

select distinct date from ETH.ETH_SCHEMA.CONTRACTS order by 1 desc limit 20;

select distinct date from DBT.DBT_KB.STG_CONTRACTS order by 1 desc limit 20;

drop table DBT.DBT_KB.STG_CONTRACTS;
