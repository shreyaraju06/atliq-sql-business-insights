SET SQL_SAFE_UPDATES = 0;

UPDATE dim_customer
SET market = 'Philippines'
WHERE market = 'Philiphines';

UPDATE dim_customer
SET market = 'New Zealand'
WHERE market = 'Newzealand';


/* Provide the list of markets in which customer  "Atliq  Exclusive"  operates its 
business in the  APAC  region.*/

SELECT DISTINCT market
FROM dim_customer
WHERE customer = "Atliq Exclusive" AND region = "APAC";

/*  What is the percentage of unique product increase in 2021 vs. 2020?*/
select * from dim_product;
select * from fact_sales_monthly;

WITH product_data AS (
    SELECT 
        p.product_code,
        f.cost_year
    FROM dim_product p
    JOIN fact_manufacturing_cost f 
        ON p.product_code = f.product_code
),

product_count AS (
    SELECT
        COUNT(DISTINCT 
            CASE WHEN cost_year = 2020 THEN product_code END
        ) AS unique_product_2020,

        COUNT(DISTINCT
            CASE WHEN cost_year = 2021 THEN product_code END
        ) AS unique_product_2021

    FROM product_data
)
SELECT
    unique_product_2020,
    unique_product_2021,

    ROUND(
        (unique_product_2021 - unique_product_2020) * 100.0
        / unique_product_2020,
    2) AS percentage_change

FROM product_count;

/* Provide a report with all the unique product counts for each  segment  and 
sort them in descending order of product counts. */
SELECT * FROM gdb023.dim_product;
select
	segment,
	count(distinct(product_code)) as product_count
from dim_product
group by segment
order by product_count desc;
    
/* Which segment had the most increase in unique products in 
2021 vs 2020? */
SELECT * FROM gdb023.fact_manufacturing_cost;
SELECT * FROM gdb023.dim_product;
WITH product_counts AS (
    SELECT 
        p.segment, 
        COUNT(DISTINCT CASE WHEN f.cost_year = 2020 THEN f.product_code 
        END) AS product_count_2020,
        COUNT(DISTINCT CASE WHEN f.cost_year = 2021 THEN f.product_code 
        END) AS product_count_2021
    FROM dim_product p
    JOIN fact_manufacturing_cost f
        ON p.product_code = f.product_code
    GROUP BY p.segment
)
SELECT *,
    (product_count_2021 - product_count_2020) AS difference
FROM product_counts
ORDER BY difference DESC;
	
/*  Get the products that have the highest and lowest manufacturing costs. */
SELECT * FROM gdb023.dim_product;
SELECT * FROM gdb023.fact_manufacturing_cost;
select
	p.product_code,
    p.product,
    f.manufacturing_cost
from dim_product p
join fact_manufacturing_cost f
	on p.product_code = f.product_code
where f.manufacturing_cost = (
	select max(manufacturing_cost)
    from fact_manufacturing_cost)
or f.manufacturing_cost= (
	select min(manufacturing_cost)
    from fact_manufacturing_cost
);

/*  Generate a report which contains the top 5 customers who received an 
average high  pre_invoice_discount_pct  for the  fiscal  year 2021  and in the 
Indian  market.*/
SELECT * FROM gdb023.fact_pre_invoice_deductions;
SELECT * FROM gdb023.dim_customer;
select
	c.customer_code,
    c.customer,
    concat(round(avg(d.pre_invoice_discount_pct)*100,2),"%") as average_discount_percentage
from dim_customer c
join fact_pre_invoice_deductions d
		on c.customer_code = d.customer_code
where fiscal_year = 2021 and market = "India"
group by c.customer_code, c.customer
order by avg(d.pre_invoice_discount_pct) desc
limit 5;

/*  Get the complete report of the Gross sales amount for the customer  “Atliq 
Exclusive”  for each month  .  This analysis helps to  get an idea of low and 
high-performing months and take strategic decisions. */
SELECT * FROM gdb023.fact_gross_price;
SELECT * FROM gdb023.fact_sales_monthly;
SELECT * FROM gdb023.dim_customer;
SELECT 
    MONTHNAME(s.date) AS month,
    s.fiscal_year,
    ROUND(SUM(s.sold_quantity * g.gross_price) / 1000000, 2) AS gross_sales_amount
FROM fact_sales_monthly s
JOIN fact_gross_price g
    ON s.product_code = g.product_code
    AND s.fiscal_year = g.fiscal_year
JOIN dim_customer c
    ON s.customer_code = c.customer_code
WHERE c.customer = 'Atliq Exclusive'
GROUP BY 
    s.fiscal_year,
    YEAR(s.date),
    MONTH(s.date),
    MONTHNAME(s.date)
ORDER BY 
    s.fiscal_year,
    YEAR(s.date),
    MONTH(s.date);
    
/*  In which quarter of 2020, got the maximum total_sold_quantity? */
select
    case
        when month(date) in (9, 10, 11) then 'Q1'
        when month(date) in (12, 1, 2) then 'Q2'
        when month(date) in (3, 4, 5) then 'Q3'
        else 'Q4'
    end as quarter,
    sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly
where fiscal_year = 2020
group by quarter
order by total_sold_quantity desc;

/*  Which channel helped to bring more gross sales in the fiscal year 2021 
and the percentage of contribution? */
SELECT * FROM gdb023.dim_customer;
SELECT * FROM gdb023.fact_gross_price;
SELECT * FROM gdb023.fact_sales_monthly;
with channel_sales as (

    select 
        c.channel,
        sum(s.sold_quantity * g.gross_price) as gross_sales
    from dim_customer c
    join fact_sales_monthly s
        on c.customer_code = s.customer_code
    join fact_gross_price g
        on s.product_code = g.product_code
        and s.fiscal_year = g.fiscal_year
    where s.fiscal_year = 2021
    group by c.channel
)

select
    channel,
    round(gross_sales / 1000000, 2) as gross_sales_mln,
    round(
        gross_sales * 100 / sum(gross_sales) over(),
        2
    ) as percentage_contribution
from channel_sales
order by percentage_contribution desc;
    
/* Get the Top 3 products in each division that have a high 
total_sold_quantity in the fiscal_year 2021? */
SELECT * FROM gdb023.dim_product;
SELECT * FROM gdb023.fact_sales_monthly;
with product_rank as (

    select
        p.division,
        p.product_code,
        p.product,
        sum(s.sold_quantity) as total_sold_quantity,
        dense_rank() over(
            partition by p.division
            order by sum(s.sold_quantity) desc
        ) as ranking
    from dim_product p
    join fact_sales_monthly s
        on p.product_code = s.product_code
    where s.fiscal_year = 2021
    group by
        p.division,
        p.product_code,
        p.product
)

select
    division,
    product_code,
    product,
    total_sold_quantity,
    ranking
from product_rank
where ranking <= 3;

