--SQL SERVER

USE Data8WeekSQLChallenge
--Case Study Questions
SELECT * FROM dbo.members 
--1. What is the total amount each customer spent at the restaurant?
SELECT customer_id
FROM dbo.sales
GROUP BY customer_id
--2. How many days has each customer visited the restaurant?
SELECT customer_id,COUNT(join_date)
FROM dbo.members
GROUP BY customer_id ;
--3. What was the first item from the menu purchased by each customer?
WITH first_item AS (
    SELECT    s.customer_id , m.product_name,DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rk 
    FROM dbo.sales  s
    INNER JOIN  dbo.menu m
    ON  s.product_id = m.product_id 
)
SELECT customer_id , product_name
FROM  first_item
WHERE rk = 1
GROUP BY customer_id, product_name ;

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH countItem AS (
	SELECT sales.product_id , COUNT(product_id) AS purchase_quantity
	FROM sales
	GROUP BY product_id
)
SELECT product_id,purchase_quantity
FROM countItem
where purchase_quantity = (SELECT MAX(purchase_quantity)FROM countItem)
--5. Which item was the most popular for each customer?
WITH sales_by_customer AS (
	SELECT customer_id,product_id ,COUNT(product_id) AS purchase_quantity
	FROM sales
	GROUP BY customer_id, product_id
	ORDER BY customer_id
	)
SELECT s.customer_id, s.product_id ,s.purchase_quantity
FROM sales_by_customer s 
WHERE purchase_quantity = 
	(SELECT MAX(purchase_quantity)FROM sales_by_customer s2 WHERE s2.customer_id = s.customer_id )
--6. Which item was purchased first by the customer after they became a member?
WITH  sales_after_join AS (
	SELECT sales.customer_id ,product_id, order_date ,join_date ,
			DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY order_date) AS rk 
	FROM sales 
	INNER JOIN members 
	ON sales.customer_id = members.customer_id
	WHERE order_date >= members.join_date
)
SELECT *
FROM sales_after_join
WHERE rk = 1
--7. Which item was purchased just before the customer became a member?
SELECT  DISTINCT b.customer_id,b.product_id 
FROM sales b
WHERE b.product_id NOT IN (	
	SELECT sales.product_id		
	FROM sales 
	INNER JOIN members 
	ON sales.customer_id = members.customer_id
	WHERE order_date < members.join_date AND b.customer_id = sales.customer_id
	);
--8. What is the total items and amount spent for each member before they became a member?
WITH sales_before_join AS (
    SELECT b.customer_id, b.product_id, price
    FROM sales b
    LEFT JOIN menu ON menu.product_id = b.product_id
    WHERE b.product_id NOT IN (
        SELECT sales.product_id
        FROM sales
        INNER JOIN members ON sales.customer_id = members.customer_id
        WHERE order_date < members.join_date AND b.customer_id = sales.customer_id
    )
)
SELECT customer_id, COUNT(customer_id) AS total, SUM(price) AS amount_spent
FROM sales_before_join
GROUP BY customer_id;
--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT  customer_id , 
		SUM (menu.price *
		CASE 
           WHEN sales.product_id = 1 THEN 2
           ELSE 1
       END ) AS point
FROM sales
INNER JOIN menu 
ON menu.product_id = sales.product_id 
GROUP BY sales.customer_id ;

--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH sales_join AS 
(
SELECT sales.customer_id ,product_id, order_date, join_date ,DATEADD(week, 1, m.join_date) AS first_week_end
FROM sales 
LEFT JOIN members m 
ON sales.customer_id = m.customer_id
WHERE order_date > join_date AND order_date >= '2021-01-01' AND order_date <= '2021-01-31'
)
SELECT  customer_id , 
		SUM (menu.price *
		CASE 
		   WHEN (order_date >= join_date AND order_date <= first_week_end ) THEN 2
           WHEN sales_join.product_id = 1 THEN 2
           ELSE 1
       END ) AS point
FROM sales_join
INNER JOIN menu 
ON menu.product_id = sales_join.product_id 
WHERE customer_id IN ('A','B')
GROUP BY sales_join.customer_id ;
