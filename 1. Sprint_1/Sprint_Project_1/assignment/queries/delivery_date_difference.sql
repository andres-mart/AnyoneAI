-- TODO: This query will return a table with two columns; State, and
-- Delivery_Difference. The first one will have the letters that identify the
-- states, and the second one the average difference between the estimate
-- delivery date and the date when the items were actually delivered to the
-- customer.
SELECT customer_state AS State,
    CAST(
        AVG(
            JULIANDAY(order_estimated_delivery_date) - JULIANDAY(DATE(order_delivered_customer_date))
        ) AS INTEGER
    ) AS Delivery_Difference
FROM olist_customers
    JOIN olist_orders ON olist_customers.customer_id = olist_orders.customer_id
WHERE order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
GROUP BY customer_state
ORDER BY Delivery_Difference;