SELECT SUM((order_details.unit_price) * order_details.quantity * (1.0 - order_details.discount)) AS total_revenues_1997
FROM order_details
INNER JOIN (
    SELECT order_id 
    FROM orders 
    WHERE EXTRACT(YEAR FROM order_date) = '1997'
) AS ord 
ON ord.order_id = order_details.order_id;

-- Qual foi o total de receitas no ano de 1997?


SELECT (SUM((od.quantity * od.unit_price) * (1 - od.discount))) AS total_revenue_1997
FROM order_details od
JOIN (
	SELECT * FROM orders
	WHERE EXTRACT(
	YEAR FROM order_date) = '1997'
) AS o 
ON od.order_id = o.order_id 