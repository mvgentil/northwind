CREATE MATERIALIZED VIEW sales_accumulated_monthly_mv AS
SELECT
    EXTRACT (YEAR FROM o.order_date) AS ano,
    EXTRACT (MONTH FROM o.order_date) AS mês,
    SUM(od.unit_price * od.quantity * (1.0 - od.discount)) AS total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY
    EXTRACT (YEAR FROM o.order_date),
    EXTRACT (MONTH FROM o.order_date)
ORDER BY
    EXTRACT (YEAR FROM o.order_date),
    EXTRACT (MONTH FROM o.order_date)

CREATE OR REPLACE FUNCTION refresh_sales_accumulated_monthly_mv() RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW sales_accumulated_monthly_mv;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_refresh_sales_accumulated_monthly_mv_order_details
AFTER UPDATE OR DELETE OR INSERT ON orders
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_sales_accumulated_monthly_mv();


CREATE TRIGGER trg_refresh_sales_accumulated_monthly_mv_orders
AFTER UPDATE OR DELETE OR INSERT ON order_details
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_sales_accumulated_monthly_mv();