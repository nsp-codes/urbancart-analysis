# Data Schema

## customers
Customer-level information.

Key column: `customer_id`

## orders
Order-level information such as order date, city, region, sales channel, payment method, and order status.

Key column: `order_id`

Foreign key: `customer_id`

## order_items
Line-item-level sales information. One order can have multiple products.

Key column: `line_id`

Foreign keys: `order_id`, `product_id`

## products
Product catalog information such as category, sub-category, product name, brand, price, and cost.

Key column: `product_id`

## returns
Return-level information. Returned items are linked to order items.

Key column: `return_id`

Foreign keys: `order_id`, `line_id`, `product_id`

## Main analysis table

The Python script creates:

`data/processed/dashboard_ready.csv`

This table is created by joining:

```text
order_items -> orders -> customers -> products -> returns
```
