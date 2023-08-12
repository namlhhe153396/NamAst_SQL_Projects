-- D. Pricing and Ratings
------------
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT SUM(IIF( pizza_id = 1,12,10)) AS [Total Monney]
FROM ##customer_orders_temp;
-- 2. What if there was an additional $1 charge for any pizza extras?
SELECT  SUM(IIF( pizza_id = 1,12,10)+  LEN(REPLACE((REPLACE(extras,',','')),' ',''))   )AS [Total Monney] 
FROM ##customer_orders_temp;
--    * Add cheese is $1 extra

--3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,
--   how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS RateTable ;
CREATE TABLE RateTable 
(
	order_id  VARCHAR(200),
	customer_id VARCHAR(200),
	rating INTEGER ,
	runner_id VARCHAR(200),
	pickup_time  VARCHAR(19),
	duration VARCHAR(10),
	distance VARCHAR(7)
)
INSERT INTO RateTable (order_id,customer_id,runner_id,pickup_time,duration,distance,rating )
SELECT c.order_id,c. customer_id , r.runner_id ,r.pickup_time,r.duration,r.distance, FLOOR(RAND()*(10-5)+5) AS rate_number
FROM ##customer_orders_temp c 
INNER JOIN ##runner_orders_temp  r
ON c.order_id = r.order_id;

--4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
WITH table4 AS 
(
SELECT	c.customer_id , c.order_id,r.runner_id,r.rating , c.order_time , r.pickup_time ,
		r.duration AS [Delivery duration], DATEDIFF(minute,c.order_time,r.pickup_time) AS [Time between order and pickup],
		r.distance/( CAST( DATEDIFF(minute,c.order_time,r.pickup_time) AS float)/60) AS [Average speed (km/h)]
FROM ##customer_orders_temp c 
INNER JOIN RateTable r 
ON r.order_id = c.order_id 
)

SELECT customer_id,runner_id,  order_id,rating ,order_time,pickup_time, [Time between order and pickup], [Delivery duration],
		[Average speed (km/h)], COUNT(*) AS [Total number of pizzas]
FROM table4
GROUP BY customer_id,runner_id, order_id,rating,order_time, pickup_time, [Time between order and pickup]  , [Delivery duration], [Average speed (km/h)] ;
--    * `customer_id`

--    * `order_id`

--    * `runner_id`

--    * `rating`

--   * `order_time`

--    * `pickup_time`

--    * `Time between order and pickup`

--    * `Delivery duration`

--    * `Average speed`

--   * `Total number of pizzas`
--
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

-- E. Bonus Questions
------------

--If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an `INSERT` statement to demonstrate what would happen if a new `Supreme` pizza with all the toppings was added to the Pizza Runner menu?