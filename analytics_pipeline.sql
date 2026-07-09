-- 1. Creating the Fact Sales Table (ClickHouse ReplacingMergeTree engine for handling updates)
CREATE TABLE IF NOT EXISTS data_analytics.fact_sales
(
    sale_id String,
    order_date Date,
    product_id LowCardinality(String),
    category LowCardinality(String),
    region LowCardinality(String),
    sales_amount Float64,
    quantity UInt32,
    updated_at DateTime
)
ENGINE = ReplacingMergeTree(updated_at)
PARTITION BY toYYYYMM(order_date)
ORDER BY (region, category, order_date, sale_id);

-- 2. Creating the Monthly Sales Plan Table
CREATE TABLE IF NOT EXISTS data_analytics.plan_sales
(
    plan_month Date,
    region LowCardinality(String),
    category LowCardinality(String),
    target_amount Float64
)
ENGINE = MergeTree()
ORDER BY (region, category, plan_month);

-- 3. Complex Analytical Query for Plan-Fact Sales Performance (Calculates Targets, Actuals, KPI % and Run-Rate)
WITH 
    monthly_fact AS (
        SELECT 
            toStartOfMonth(order_date) AS report_month,
            region,
            category,
            SUM(sales_amount) AS total_actual_sales,
            SUM(quantity) AS total_units_sold
        FROM data_analytics.fact_sales
        FINAL -- Ensuring we get the latest version from ReplacingMergeTree
        GROUP BY report_month, region, category
    )
SELECT 
    p.plan_month AS date_period,
    p.region AS business_region,
    p.category AS product_category,
    p.target_amount AS monthly_plan,
    coalesce(f.total_actual_sales, 0) AS monthly_fact,
    -- KPI Attainment Percentage
    CASE 
        WHEN p.target_amount > 0 THEN round((monthly_fact / monthly_plan) * 100, 2)
        ELSE 0 
    END AS kpi_achievement_pct,
    -- Variance Analysis
    (monthly_fact - monthly_plan) AS variance_amount
FROM data_analytics.plan_sales AS p
LEFT JOIN monthly_fact AS f 
    ON p.plan_month = f.report_month 
   AND p.region = f.region 
   AND p.category = f.category
ORDER BY date_period DESC, business_region, kpi_achievement_pct DESC;
