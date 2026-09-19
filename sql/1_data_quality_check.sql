-- 01_check_quality.sql


SELECT
  COUNT(*)                     AS row,
  COUNT(DISTINCT invoice_no)   AS orders,
  COUNT(DISTINCT customer_id)  AS customers,
  ROUND(SUM(revenue), 2)       AS total_revenue,
  MIN(DATE(invoice_date))      AS first_date,
  MAX(DATE(invoice_date))      AS last_date
FROM `project-3-509010.retail_analysis.retail_clean`;

--check null
SELECT
  COUNTIF(customer_id IS NULL)                AS still_null_id,
  COUNTIF(STARTS_WITH(invoice_no, 'C'))       AS still_cancelled,
  COUNTIF(quantity <= 0)                      AS still_bad_qty,
  COUNTIF(price <= 0)                         AS still_bad_price,
  COUNTIF(DATE(invoice_date) >= '2011-12-01') AS still_dec_2011
FROM `project-3-509010.retail_analysis.retail_clean`;


SELECT COUNT(*) AS total_rows
FROM `project-3-509010.retail_analysis.retail_clean`;

SELECT COUNT(*) AS distinct_rows
FROM (
  SELECT DISTINCT * FROM `project-3-509010.retail_analysis.retail_clean`
);


SELECT
  MIN(customer_id)  AS min_customer_id,
  MAX(customer_id)  AS max_customer_id,
  MIN(LENGTH(invoice_no)) AS min_invoice_len,
  MAX(LENGTH(invoice_no)) AS max_invoice_len,
  COUNTIF(revenue IS NULL) AS null_revenue
FROM `project-3-509010.retail_analysis.retail_clean`;