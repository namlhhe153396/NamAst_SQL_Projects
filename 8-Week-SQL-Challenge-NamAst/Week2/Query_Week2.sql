USE Data8WeekSQLChallenge ;
-- Case Study Questions 
-----------

/* This case study has LOTS of questions - they are broken up by area of focus including:

	1. Pizza Metrics

	2. Runner and Customer Experience

	3. Ingredient Optimisation

	4. Pricing and Ratings

	5. Bonus DML Challenges (DML = Data Manipulation Language)	*/



-- A. Pizza Metrics
--------------

-- 1. How many pizzas were ordered?
SELECT COUNT(order_id) AS pizzas_were_orderd
FROM tempdb.##customer_orders_temp  ;

--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS unique_customer
FROM tempdb.##customer_orders_temp  ;

-- 3. How many successful orders were delivered by each runner?
SELECT COUNT(order_id)
FROM tempdb.##runner_orders_temp  
Where cancellation LIKE '';
 
-- 4. How many of each type of pizza was delivered?
SELECT COUNT(DISTINCT C.pizza_id) AS num_type_pizza
FROM tempdb.##customer_orders_temp C
INNER JOIN pizza_names P
ON P.pizza_id = C.pizza_id;


-- 5. How many Vegetarian and Meatlovers were ordered by each customer?


SELECT DISTINCT C.customer_id  ,
		(   SELECT COUNT(*)
			FROM  tempdb.##customer_orders_temp
			WHERE pizza_id = 1 AND customer_id = C.customer_id  )	AS num_meatlovers  ,
		( SELECT COUNT(*)
			FROM  tempdb.##customer_orders_temp
			WHERE pizza_id = 2 AND customer_id = C.customer_id )	AS num_vegetarian 
FROM tempdb.##customer_orders_temp C ;

-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT MAX(num_pizzas) AS MAX_num_pizzas
FROM 
( SELECT COUNT(pizza_id) AS num_pizzas
FROM tempdb.##customer_orders_temp C 
GROUP BY order_id  )  AS table1  ;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT  
		SUM( iif(exclusions NOT LIKE '' OR extras NOT LIKE '',1,0))  AS at_least_1_changes,
		SUM( iif(exclusions LIKE '' AND extras LIKE '', 1, 0))  AS at_least_1_changes
FROM tempdb.##customer_orders_temp  ;
-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT  
		SUM( iif(exclusions NOT LIKE '' AND extras NOT LIKE '', 1, 0))  AS at_least_1_changes
FROM tempdb.##customer_orders_temp  ;

-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT DATEPART(YEAR, order_time) AS year,
       DATEPART(MONTH, order_time) AS month,
       DATEPART(DAY, order_time) AS day,
       DATEPART(HOUR, order_time) AS hour,
	   COUNT(pizza_id) AS total_volume
FROM tempdb.##customer_orders_temp C
GROUP BY DATEPART(YEAR, order_time),
         DATEPART(MONTH, order_time),
         DATEPART(DAY, order_time),
         DATEPART(HOUR, order_time)
ORDER BY year, month, day, hour;

-- 10. What was the volume of orders for each day of the week?
SELECT DATEPART(YEAR, order_time) AS year,
       DATEPART(MONTH, order_time) AS month,
       DATEPART(DAY, order_time) AS day,
	   DATEPART(WEEKDAY,order_time) AS day_of_week,
	   COUNT(pizza_id) AS total_volume
FROM tempdb.##customer_orders_temp C
GROUP BY DATEPART(YEAR, order_time),
         DATEPART(MONTH, order_time),
         DATEPART(DAY, order_time),
		 DATEPART(dw,order_time)
ORDER BY year, month, day,day_of_week;

