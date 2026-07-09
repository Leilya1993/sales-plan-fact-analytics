# Sales Performance Analytics Pipeline (Plan-Fact Analysis)

## Project Overview
This project delivers a business intelligence and data warehousing solution designed to track, monitor, and analyze commercial sales performance against preset monthly targets (Plan-Fact analysis). 

By integrating ClickHouse as the analytical database and Apache Superset for real-time dashboarding, the pipeline transforms raw sales transactions into optimized datasets, empowering stakeholders with immediate operational insights.

## Tech Stack & Architecture
* Data Warehouse: ClickHouse (Utilizing ReplacingMergeTree and MergeTree columnar storage engines for fast aggregations).
* Business Intelligence & Visualization: Apache Superset.
* Query Language: Advanced SQL (Common Table Expressions (CTEs), Analytical Window Functions, Conditional Aggregations).

## Key Database Features Implemented
1. Idempotency & Deduplication: Applied ClickHouse ReplacingMergeTree engine versioned by update timestamps to cleanly handle downstream transaction updates without data duplication.
2. Performance Optimization: Partitioned tables by monthly intervals to minimize memory usage during heavy query scans.
3. Data Modeling: Modeled a clean star schema linking transactional daily facts to static monthly target layouts using optimized join methodologies.

## Business Metrics & Dashboards Delivered
The resulting interactive Apache Superset Dashboard provides business units with tracking for:
* KPI Achievement Percentage: Real-time variance tracking showing which regions and categories are hitting or missing their financial targets.
* Sales Volatility Analysis: Breakdown of sales velocity across regional hubs to optimize inventory allocation.
* Absolute Variance: Clear value gaps between planned projections and active real-world sales performance.

## Repository Structure
* analytics_pipeline.sql: Production-grade DDL scripts and analytical queries deployed within the ClickHouse database environment.

---
Developed as a core Data Analytics showcase portfolio item.
