# UrbanCart Capstone 1 - Sales & Customer Performance Analysis

This repo contains a focused analytics capstone project for practicing SQL, basic Python, pandas, and dashboarding.

## Business question

**What is driving UrbanCart's sales performance, and where are the biggest opportunities to improve revenue or reduce leakage?**

## Final deliverables

Keep the project limited to these 3 deliverables:

1. **SQL analysis file** with answers to 8 business questions
2. **One dashboard** with KPI cards and 4-5 charts
3. **Short insight summary** with 3 observations, 2 insights, and 2 recommendations

## Recommended workflow

1. Review the raw data in `data/raw/`
2. Run the SQL queries in `sql/analysis_questions.sql` using `database/urbancart.sqlite`
3. Run `src/build_dashboard_dataset.py` to create `data/processed/dashboard_ready.csv`
4. Use `dashboard_ready.csv` to build your dashboard in Excel, Tableau, or Power BI
5. Fill out `reports/insights_template.md`

## Data tables to use

Use only these tables for Capstone 1:

- `customers`
- `orders`
- `order_items`
- `products`
- `returns`

Ignore campaigns, targets, and machine learning for this capstone.

## Main joins

```sql
orders.customer_id = customers.customer_id
order_items.order_id = orders.order_id
order_items.product_id = products.product_id
returns.line_id = order_items.line_id
```

## Dashboard scope

KPI cards:

- Total Revenue
- Total Orders
- Average Order Value
- Return Rate

Charts:

- Monthly revenue trend
- Revenue by category
- Revenue by city or region
- Return rate by category
- Optional: Top 10 products by revenue

## How to run the Python step

```bash
pip install -r requirements.txt
python src/build_dashboard_dataset.py
```

## Suggested commit flow

```bash
git init
git add .
git commit -m "Initial capstone repo structure"
git commit -m "Add SQL analysis queries"
git commit -m "Add dashboard-ready dataset"
git commit -m "Add insight summary"
```
