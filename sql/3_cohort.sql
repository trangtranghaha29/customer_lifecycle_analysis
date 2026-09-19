-- =====================================================================
-- 03_cohort.sql

--xác định cohort
CREATE TEMP TABLE customer_cohort AS
SELECT
  customer_id,
  DATE_TRUNC(MIN(DATE(invoice_date)), MONTH) AS cohort_month
FROM `project-3-509010.retail_analysis.retail_clean`
GROUP BY customer_id;

SELECT * FROM customer_cohort;
SELECT COUNT(*) AS row FROM customer_cohort;

-- phân bổ new, returning
SELECT
  DATE_TRUNC(DATE(c.invoice_date), MONTH) AS month,
  IF(DATE_TRUNC(DATE(c.invoice_date), MONTH) = k.cohort_month, 'new', 'returning') AS customer_type,
  COUNT(DISTINCT c.customer_id) AS customers,
  ROUND(SUM(c.revenue), 2)      AS revenue
FROM `project-3-509010.retail_analysis.retail_clean` c
JOIN customer_cohort k USING (customer_id)
GROUP BY month, customer_type
ORDER BY month, customer_type;


--tính cohort
SELECT
  k.cohort_month,
  DATE_DIFF(
    DATE_TRUNC(DATE(c.invoice_date), MONTH),
    k.cohort_month,
    MONTH
  ) AS month_index,
  COUNT(DISTINCT c.customer_id) AS active_customers
FROM `project-3-509010.retail_analysis.retail_clean` c
JOIN customer_cohort k USING (customer_id)
GROUP BY cohort_month, month_index
ORDER BY cohort_month, month_index;


--kiểm tra
SELECT
  cohort_month,
  COUNT(*) AS cohort_size
FROM customer_cohort
GROUP BY cohort_month
ORDER BY cohort_month;