# atliq-sql-business-insights
Solved 10 real business questions for AtliQ Hardwares using SQL — covering market presence, product growth, segment analysis, manufacturing costs, customer discounts, monthly sales trends, quarterly performance, channel contribution, and top products by division. Built with CTEs, window functions, joins, and aggregations.


# 📊 AtliQ Hardwares – SQL Business Insights (Codebasics SQL Challenge)

## 🎯 Problem Statement
AtliQ Hardwares needed a structured, SQL-driven way to answer ad-hoc business
questions from stakeholders — spanning sales, product, customer, and channel
performance — to support faster, data-backed decision-making.

## 💡 Objective
Solve 10 real business questions posed in the Codebasics SQL Challenge using
SQL joins, CTEs, window functions, and aggregations on a relational sales
dataset, and present the results in a stakeholder-ready format.

## 🗃️ Dataset Overview
**Dimension Tables:** `dim_customer`, `dim_product`
**Fact Tables:** `fact_sales_monthly`, `fact_gross_price`, `fact_manufacturing_cost`, `fact_pre_invoice_deductions`

## 🛠️ SQL Skills Used
CTEs · Window Functions (`DENSE_RANK`, `SUM() OVER`) · CASE statements ·
Joins (INNER) · Aggregations (`SUM`, `COUNT`, `AVG`) · Subqueries ·
Date functions (`MONTH`, `MONTHNAME`, `YEAR`) · Data cleaning (`UPDATE`)

## 📊 Business Questions Solved
All queries are in [`consumer_goods.sql`](./consumer_goods.sql).

1. **Markets** where "Atliq Exclusive" operates in the APAC region
2. **% increase in unique products**, 2021 vs. 2020
3. **Unique product count by segment**, sorted descending
4. **Segment with the highest growth** in unique products, 2021 vs. 2020
5. **Highest and lowest manufacturing cost** products
6. **Top 5 customers** by average pre-invoice discount % (India, FY2021)
7. **Monthly gross sales** for "Atliq Exclusive" — identifying high/low performing months
8. **Quarter with peak sold quantity** in FY2020
9. **Sales channel contribution** to gross sales in FY2021 (with % share)
10. **Top 3 products per division** by total sold quantity, FY2021 (via `DENSE_RANK`)

> 💡 Add a screenshot of each query's output under its question above once you've run them — that's what makes this land well visually.

## 🧹 Data Cleaning
Corrected inconsistent market naming in `dim_customer` (e.g., "Philiphines" → "Philippines", "Newzealand" → "New Zealand") before analysis, to avoid skewed groupings.

## 📌 Key Learnings
- Solving real, stakeholder-style ad-hoc business questions with SQL
- Using CTEs and window functions for ranking and period-over-period comparisons
- Cleaning inconsistent categorical data before aggregation
- Structuring queries for readability and reuse

## 🎥 Project Demo
*(Add your LinkedIn post / video link here once posted)*
