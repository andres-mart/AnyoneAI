-- TODO: This query will return a table with the top 10 least revenue categories
-- in English, the number of orders and their total revenue. The first column
-- will be Category, that will contain the top 10 least revenue categories; the
-- second one will be Num_order, with the total amount of orders of each
-- category; and the last one will be Revenue, with the total revenue of each
-- catgory.
SELECT product_category_name_english AS Category,
    COUNT(DISTINCT(olist_orders.order_id)) AS Num_order,
    SUM(olist_order_payments.payment_value) AS Revenue
FROM olist_products
    INNER JOIN olist_order_items ON olist_products.product_id = olist_order_items.product_id
    INNER JOIN olist_orders ON olist_order_items.order_id = olist_orders.order_id
    INNER JOIN olist_order_payments ON olist_orders.order_id = olist_order_payments.order_id
    INNER JOIN product_category_name_translation ON olist_products.product_category_name = product_category_name_translation.product_category_name
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
GROUP BY Category
ORDER BY Revenue ASC
LIMIT 10;