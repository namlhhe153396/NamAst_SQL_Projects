
-- B. Runner and Customer Experience
-------------
Use Data8WeekSQLChallenge ;
-- 1. How many runners signed up for each 1 week period? (i.e. week starts `2021-01-01`)



SELECT DATEADD(week, DATEDIFF(week, 0, registration_date), 0) AS week_start, COUNT(*) AS total_runners
FROM runners
WHERE registration_date >= '2021-01-01'
GROUP BY DATEADD(week, DATEDIFF(week, 0, registration_date), 0)
ORDER BY week_start;
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


SELECT DATEPART(MINUTE, DATEDIFF(R.pickup_time, C.order_time))/COUNT(order_id) AS AVE
FROM ##runner_orders_temp  R
INNER JOIN ##customer_orders_temp  C
ON R.order_id = C.order_id ; 

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

-- 4. What was the average distance travelled for each customer?
SELECT SUM(R.distance)/COUNT(DISTINCT C.customer_id)
FROM ##runner_orders_temp  R
INNER JOIN ##customer_orders_temp  C
ON R.order_id = C.order_id ; 
GROUP BY C.customer_id 

-- 5. What was the difference between the longest and shortest delivery times for all orders?

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT 
	(SUM (R.distance ) / SUM(duration)) AS AVG_speed
FROM ##runner_orders_temp R
GROUP BY R.runner_id


-- 7. What is the successful delivery percentage for each runner?
SELECT SUM(IFF(cancellation NOT LIKE '' ,1,0) ) AS sum_successful , 
		 SUM(IFF(cancellation NOT LIKE '' ,0,1) ) AS sum_cancel ,
		 (sum_successful / sum_cancel + sum_cancel) AS per
FROM ##runner_orders_temp R
GROUP BY R.runner_id

