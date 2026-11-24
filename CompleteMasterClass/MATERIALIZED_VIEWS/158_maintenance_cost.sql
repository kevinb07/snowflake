
SHOW MATERIALIZED VIEWS;

/*
MATERIALIZED_VIEW_REFRESH_HISTORY(
    [ DATE_RANGE_START => <constant_expr> ]
    [ , DATE_RANGE_END => <constant_expr> ]
    [ , MATERIALIZED_VIEW_NAME => '<string>' ] )
*/
SELECT CURRENT_TIMESTAMP;

SELECT * FROM TABLE(information_schema.materialized_view_refresh_history(MATERIALIZED_VIEW_NAME => 'ORDERS_MV'));

-- cleanup
DROP DATABASE ORDERS;

// USE CASES:
-- View taking a long time to run and used frequently
-- Underlaying data change is not frequent or on irregular basis

// ALTERNATIVES:
-- Tables with stream and tasks if data changes are frequent.

// LIMITATIONS:
-- Enterprise feature
-- Joins and self-joins are not supported
-- limited supported aggregated functions
-- UDFs, HAVING, ORDER BY and LIMIT clauses not supported.