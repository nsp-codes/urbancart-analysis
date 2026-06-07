-- UrbanCart Capstone 1 - Focused SQL Analysis
-- Database: database/urbancart.sqlite
-- Goal: Answer the 8 core business questions only.

-- 1. What is the total revenue, total orders, and average order value?
SELECT
    ROUND(SUM(oi.line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.line_revenue) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

-- 2. How has revenue changed month by month?
SELECT
    strftime('%Y-%m', o.order_date) AS order_month,
    ROUND(SUM(oi.line_revenue), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY order_month;

-- 3. Which product categories generate the highest revenue?
SELECT
    p.category,
    ROUND(SUM(oi.line_revenue), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;

-- 4. Which cities generate the highest revenue?
SELECT
    o.city,
    o.region,
    ROUND(SUM(oi.line_revenue), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.city, o.region
ORDER BY revenue DESC;

-- 5. Which sales channels perform best?
SELECT
    o.sales_channel,
    ROUND(SUM(oi.line_revenue), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.line_revenue) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.sales_channel
ORDER BY revenue DESC;

-- 6. Which products are sold the most?
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.line_revenue), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name, p.category
ORDER BY units_sold DESC
LIMIT 10;

-- 7. What is the return rate overall?
SELECT
    COUNT(DISTINCT r.line_id) AS returned_items,
    COUNT(DISTINCT oi.line_id) AS total_items,
    ROUND(COUNT(DISTINCT r.line_id) * 100.0 / COUNT(DISTINCT oi.line_id), 2) AS return_rate_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN returns r ON oi.line_id = r.line_id
WHERE o.order_status = 'Delivered';

-- 8. Which categories/products have the highest return rate?
SELECT
    p.category,
    p.product_name,
    COUNT(DISTINCT r.line_id) AS returned_items,
    COUNT(DISTINCT oi.line_id) AS total_items,
    ROUND(COUNT(DISTINCT r.line_id) * 100.0 / COUNT(DISTINCT oi.line_id), 2) AS return_rate_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN returns r ON oi.line_id = r.line_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category, p.product_name
HAVING COUNT(DISTINCT oi.line_id) >= 10
ORDER BY return_rate_pct DESC, returned_items DESC
LIMIT 10;
