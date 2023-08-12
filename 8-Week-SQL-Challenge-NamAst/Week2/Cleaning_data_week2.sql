USE Data8WeekSQLChallenge ; 
-- Table 1: runners
SELECT * 
from runners ;
-- Table 2: customer_orders
SELECT * 
from customer_orders ;

DROP TABLE IF EXISTS ##customer_orders_temp;
SELECT  order_id, customer_id,pizza_id ,
		CASE 
		  WHEN exclusions IS NULL OR exclusions LIKE '%NULL%' THEN ''
		  ELSE exclusions
		END AS exclusions,
		CASE
			WHEN extras IS NULL OR extras LIKE '%null%' THEN ''
			ELSE extras
		END AS extras
		, 
		order_time
INTO  ##customer_orders_temp
FROM customer_orders ;

-- Table 3: runner_orders
SELECT  *
from runner_orders ;
DROP TABLE IF EXISTS ##runner_orders_temp;
SELECT  order_id , 
		runner_id , 
		CASE 
			WHEN pickup_time IS NULL OR pickup_time LIKE '%null%' THEN NULL
			ELSE pickup_time
		END AS pickup_time, 
		CASE 
			WHEN distance IS NULL  OR distance LIKE '%null%' THEN NULL
			WHEN distance LIKE '%km%' THEN TRIM('km' FROM distance)
			ELSE distance
		END AS distance
		 , 
		 CASE 
			WHEN duration IS NULL OR duration LIKE '%null%' THEN NULL
	        WHEN duration LIKE '%mins%' THEN TRIM('mins' FROM duration)
	        WHEN duration LIKE '%minutes%' THEN TRIM('minutes' FROM duration)
	        WHEN duration LIKE '%minute%' THEN TRIM( 'minute' FROM duration)
	        ELSE duration 
		END AS duration
		 , 
		 CASE 
		 WHEN cancellation IS NULL OR cancellation LIKE '%null%' THEN  ''
		 ELSE cancellation
		 END AS cancellation
INTO  ##runner_orders_temp
FROM runner_orders;
-- Table 4: pizza_names
SELECT * 
from pizza_names ;
-- Table 5: pizza_recipes
SELECT * 
from pizza_recipes ;
-- Table 6: pizza_toppings
SELECT * 
from pizza_toppings ;

