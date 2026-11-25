-- Enable AUTO_SUSPEND for Warehouses
 -- Cache is cleared when suspended
 -- Time based on workload

-- Enable AUTO_RESUME for Warehouses

-- Set appropriate timeouts

-- Choose size based on workload

-- Transient tables for staging and development envs
 -- Permanent tables for production

-- Appropriate data type

-- Set cluster keys only if necessary for large tables to reduce table scans

-- Retention Period
 -- 0 days for staging databases and large high-churn tables
 -- 4-7 days for production
 