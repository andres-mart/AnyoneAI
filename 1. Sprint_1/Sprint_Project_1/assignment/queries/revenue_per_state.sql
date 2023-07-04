-- TODO: This query will return a table with two columns; customer_state, and
-- Revenue. The first one will have the letters that identify the top 10 states
-- with most revenue and the second one the total revenue of each.
SELECT customer_state AS customer_state,
    SUM(payment_value) AS Revenue
FROM olist_customers
    INNER JOIN olist_orders ON olist_customers.customer_id = olist_orders.customer_id
    INNER JOIN olist_order_payments ON olist_orders.order_id = olist_order_payments.order_id
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
ORDER BY Revenue DESC
LIMIT 10;