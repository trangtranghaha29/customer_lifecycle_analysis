-- 02_exploration.sql


-- tính số lượng khách, đơn hàng, doanh thu mỗi tháng
SELECT
  DATE_TRUNC(DATE(invoice_date), MONTH) AS month,
  COUNT(DISTINCT customer_id)           AS customers,
  COUNT(DISTINCT invoice_no)            AS orders,
  ROUND(SUM(revenue), 2)                AS revenue,
  ROUND(SUM(revenue) / COUNT(DISTINCT invoice_no), 2) AS aov
FROM `project-3-509010.retail_analysis.retail_clean`
GROUP BY month
ORDER BY month;

--nước nào chi nhiều tiền nhất
SELECT
  country,
  COUNT(DISTINCT customer_id) AS customers,
  ROUND(SUM(revenue), 2)      AS revenue
FROM `project-3-509010.retail_analysis.retail_clean`
GROUP BY country
ORDER BY revenue DESC;

-- số đơn khách đã mua và tổng tiền đã chi
WITH per_customer AS (
  SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS orders,
    SUM(revenue)               AS revenue
  FROM `project-3-509010.retail_analysis.retail_clean`
  GROUP BY customer_id
)
SELECT
  CASE
    WHEN orders = 1   THEN '1 order'
    WHEN orders = 2   THEN '2 orders'
    WHEN orders <= 5  THEN '3-5 orders'
    WHEN orders <= 10 THEN '6-10 orders'
    ELSE                   '>10 orders'
  END AS group,
  COUNT(*)               AS customers,
  ROUND(SUM(revenue), 2) AS revenue
FROM per_customer
GROUP BY group
ORDER BY group;


--thời gian tính từ lần mua đầu tiên đến lần mua cuối cùng
WITH recently_order AS (
  SELECT
    customer_id,
    DATE_DIFF(MAX(DATE(invoice_date)), MIN(DATE(invoice_date)), DAY) AS days_active
  FROM `project-3-509010.retail_analysis.retail_clean`
  GROUP BY customer_id
)
SELECT
  CASE
    WHEN days_active = 0    THEN 'mua 1 lần'
    WHEN days_active <= 30  THEN 'dưới 1 tháng'
    WHEN days_active <= 90  THEN '1-3 tháng'
    WHEN days_active <= 180 THEN '3-6 tháng'
    WHEN days_active <= 365 THEN '6-12 tháng'
    ELSE                         'trên 1 năm'
  END AS recent_order,
  COUNT(*) AS customers
FROM recently_order
GROUP BY recent_order
ORDER BY recent_order;