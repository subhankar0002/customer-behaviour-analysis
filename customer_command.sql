-- Q1. How much total revenue was earned from male and female customers respectively?
select gender ,SUM(purchase_amount) as revenue 
from my_table	
group by gender;

-- Q2. Identify customers who applied a discount yet spent above the overall average purchase amount.
SELECT customer_id ,purchase_amount from my_table
where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from my_table);

-- Q3. List the top five products that have the highest average customer review ratings.
select item_purchased, ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2) as "Average Product Rating"
from my_table
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4. How do average purchase amounts differ between Standard and Express shipping types?
select shipping_type,
ROUND(AVG(purchase_amount),2)
from my_table
where shipping_type in ('Standard','Express')
group by shipping_type;

-- Q5. How do average purchase amounts differ between Standard and Express shipping types?
SELECT subscription_status,
 COUNT(customer_id) AS total_customers,
 ROUND(AVG(purchase_amount),2) AS avg_spend,
 ROUND(SUM(purchase_amount),2) AS total_revenue
FROM my_table
GROUP BY subscription_status
ORDER BY total_revenue,avg_spend DESC;

-- Q6. Find the top five products with the greatest proportion of discounted purchases.
SELECT item_purchased,
 ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS
discount_rate
FROM my_table
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Q7. Categorize customers as New, Returning, or Loyal depending on their past purchase count, and display how many belong to each group.
with customer_type as (
SELECT customer_id, previous_purchases,
CASE
 WHEN previous_purchases = 1 THEN 'New'
 WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
 ELSE 'Loyal'
 END AS customer_segment
FROM my_table)
select customer_segment,count(*) AS "Number of Customers"
from customer_type
group by customer_segment;

-- Q8. Determine the three most frequently purchased items under each product category.
WITH item_counts AS (
 SELECT category,
 item_purchased,
 COUNT(customer_id) AS total_orders,
 ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS
item_rank
 FROM my_table
 GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

-- Q9. Examine whether frequent buyers with over five past purchases are more inclined to have active subscriptions.
SELECT subscription_status,
 COUNT(customer_id) AS repeat_buyers
FROM my_table
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. How much total revenue does each age group contribute?
SELECT
 age_group,
 SUM(purchase_amount) AS total_revenue
FROM my_table
GROUP BY age_group
ORDER BY total_revenue desc;

