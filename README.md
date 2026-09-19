# Customer Lifecycle Analytics — Online Retail II

Cohort retention analysis of 1M+ real e-commerce transactions.
Main question: does revenue come from new customers or returning ones, and how long do customers stay after their first purchase?


---

## Dataset

- **Source:** [UCI Machine Learning Repository — Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)
- **Size:** 1,067,371 rows, December 2009 to December 2011
- **Business:** a UK-based online gift retailer with no physical stores; many customers are wholesalers

Each row is one line item in an order, not one order.

Both sheets were used. 24 months is the minimum needed to compare cohorts; a single sheet gives 12.

---

## Tools

Excel · BigQuery SQL · Python (colab) · Power BI

---

## Step 1 — Cleaning in Excel

Rows were dropped: no Customer ID, cancellation, non-positive price, non-product stock codes (postage, bank charges, Amazon fees), and December 2011, where the data stops on the 9th.

The two sheets overlap by nine days — sheet 1 runs to 2010-12-09, sheet 2 starts 2010-12-01, and 1,088 invoices appear in both so those rows were deleted.

**Result: 759,613 rows, 35,818 orders, 5,824 customers, £16,556,339.89 in revenue.**

---

## Step 2 — Exploration in SQL

**Monthly revenue is seasonal, not growing.** November peaks in both years, driven by Christmas stock-ups. With 24 months, the right comparison is November to November.

**The average is misleading.** Customers place 6.15 orders on average, but the median is 3. A small group of wholesale buyers pulls the mean up.

| Orders | Customers | % of customers | % of revenue |
| --- | ---: | ---: | ---: |
| 1 | 1,647 | 28% | 3% |
| 2 | 940 | 16% | 4% |
| 3–5 | 1,490 | 26% | 13% |
| 6–10 | 907 | 16% | 15% |
| 10+ | 840 | **14%** | **65%** |

**Revenue is heavily concentrated.** Customers with more than 10 orders are 14% of the base and 65% of revenue.

**Concentrated geographically.** The UK is 83.5% of revenue. EIRE is second at 3.5% — from three customers. Those are wholesale accounts.

---

## Step 3 — Cohort retention

Every customer is assigned to the month of their first purchase, then tracked by how many months have passed since — not by calendar month. Active means at least one order in that month.

| Months since first purchase | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Still active | 100% | 23.3% | 23.6% | 25.0% | 22.8% | 21.9% | 22.2% |

**Retention drops from 100% to 23% in the first month, then flattens.** The second purchase is the barrier. Customers who get past it stay at a fairly stable rate.

**Returning customers carry the business:** 79% of active customers in a typical month, and 85.5% of revenue. December 2009 is excluded — the first month of data is 100% new by definition.

**Retention is not monotonic.** Several cohorts show a higher rate in month 2 than month 1. This is not an error: most customers are wholesalers who reorder on a cycle of several months rather than monthly.

---

## Key findings

1. **The first repeat purchase is the bottleneck.** 77% of customers do not return after month 0.
2. **Returning customers generate 85.5% of revenue** while making up 79% of monthly actives.
3. **14% of customers generate 65% of revenue.** Losing a small number of accounts would hurt disproportionately.
4. **28% of customers bought exactly once** and account for 3% of revenue.

## Recommendations

**Spend on the second purchase, not the first.** The steepest part of every cohort curve is month 0 to month 1. Anything that moves that number moves everything downstream.

**Track the top customer group separately.** With 65% of revenue coming from 14% of customers, an aggregate churn number hides what matters.

**Treat the UK and export markets differently.** 83.5% of revenue is domestic, and the second-largest market rests on three accounts.

---

## Limitations

- Customers without an ID were excluded, so guest-checkout behaviour is invisible and the sample skews toward registered, higher-spending buyers.
- Most customers are wholesalers with multi-month buying cycles, so low monthly retention is not necessarily a bad signal.
- Descriptive only — no statistical claims are made anywhere in this project.

---

## What I would do next

1. **RFM segmentation**
2. **Time to second purchase** — the exact window in which a first-time buyer is most likely to return
3. **Apply the same cohort framework to mobile game event data** — install cohorts and funnels.

---

## Repository

```
├── README.md
├── excel/
│   ├── cleaning_log_sheet1.png
│   └── cleaning_steps.md
├── sql/
│   ├── 01_verify_clean.sql
│   ├── 02_exploration.sql
│   └── 03_cohort_retention.sql
├── notebooks/
│   └── retention_curve.ipynb
├── dashboard/
    └── online_retail.pbix
```

## How to run

1. Download `online_retail_II.xlsx` from the UCI link above
2. Clean both sheets in Excel following `excel/cleaning_steps.md`, export as CSV
3. Load into BigQuery as `retail_clean`
4. Run `sql/01` through `sql/03`
5. Export the cohort table and open `notebooks/retention_curve.ipynb`
---
