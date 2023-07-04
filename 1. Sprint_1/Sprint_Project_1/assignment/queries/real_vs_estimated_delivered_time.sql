-- TODO: This query will return a table with the differences between the real
-- and estimated delivery times by month and year. It will have different
-- columns: month_no, with the month numbers going from 01 to 12; month, with
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with
-- the average delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if
-- it doesn't exist); Year2018_real_time, with the average delivery time per
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_estimated_time, with the average estimated delivery time per month
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist)
SELECT month_no,
  (
    CASE
      month_no
      WHEN '01' THEN 'Jan'
      WHEN '02' THEN 'Feb'
      WHEN '03' THEN 'Mar'
      WHEN '04' THEN 'Apr'
      WHEN '05' THEN 'May'
      WHEN '06' THEN 'Jun'
      WHEN '07' THEN 'Jul'
      WHEN '08' THEN 'Aug'
      WHEN '09' THEN 'Sep'
      WHEN '10' THEN 'Oct'
      WHEN '11' THEN 'Nov'
      WHEN '12' THEN 'Dec'
    END
  ) AS month,
  AVG(
    CASE
      year
      WHEN '2016' THEN avg_real_time
      ELSE NULL
    END
  ) AS Year2016_real_time,
  AVG(
    CASE
      year
      WHEN '2017' THEN avg_real_time
      ELSE NULL
    END
  ) AS Year2017_real_time,
  AVG(
    CASE
      year
      WHEN '2018' THEN avg_real_time
      ELSE NULL
    END
  ) AS Year2018_real_time,
  AVG(
    CASE
      year
      WHEN '2016' THEN avg_estimated_time
      ELSE NULL
    END
  ) AS Year2016_estimated_time,
  AVG(
    CASE
      year
      WHEN '2017' THEN avg_estimated_time
      ELSE NULL
    END
  ) AS Year2017_estimated_time,
  AVG(
    CASE
      year
      WHEN '2018' THEN avg_estimated_time
      ELSE NULL
    END
  ) AS Year2018_estimated_time
FROM (
    SELECT strftime('%m', order_purchase_timestamp) AS month_no,
      strftime('%Y', order_purchase_timestamp) AS year,
      AVG(
        JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp)
      ) AS avg_real_time,
      AVG(
        JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp)
      ) AS avg_estimated_time
    FROM olist_orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
    GROUP BY month_no,
      year
  )
GROUP BY month_no;