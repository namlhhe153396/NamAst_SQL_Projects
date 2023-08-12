-- C. Ingredient Optimisation 

------------
USE tempdb ;
-- 1. What are the standard ingredients for each pizza?


-- 2. What was the most commonly added extra?
--Create FUNCTION by Nam Ast
DROP FUNCTION IF EXISTS [dbo].[splitstringsql]  
GO
CREATE FUNCTION [dbo].[splitstringsql] (@DelimitedString VARCHAR(200), @Delimiter VARCHAR(8))
RETURNS @tbsplit TABLE
	(
	ElementID   int IDENTITY(1,1),  -- Array index
	extras VARCHAR(200) 
	)
AS
BEGIN
	DECLARE @start SMALLINT,
			@index SMALLINT ,@lenstr SMALLINT ;
	SET @lenstr = LEN(@Delimiter)
	WHILE LEN(@DelimitedString) > 0
	BEGIN
		SET @index = CHARINDEX(@Delimiter,@DelimitedString) ;
		IF  @index = 0 
			BEGIN
				INSERT INTO
                    @tbsplit 
                    (extras)
                VALUES (LTRIM(RTRIM(@DelimitedString)))
				BREAK
			END
		ELSE
			BEGIN			
				
				INSERT INTO   @tbsplit (extras)
				VALUES (LTRIM(RTRIM(Substring(@DelimitedString,1,@index - 1)))) ;

				SET @start = @Index + @lenstr
				SET @DelimitedString = Substring(@DelimitedString,@Start , LEN(@DelimitedString) - @start + 1 )
			END
	END
	RETURN 
END;
GO
--Select
SELECT TOP 1 extras , count(extras) AS time_ADD
FROM (SELECT v.extras 
FROM  dbo.##customer_orders_temp  c
CROSS APPLY dbo.splitstringsql( c.extras , ',') v ) extrass_add
GROUP BY extras
ORDER BY time_ADD DESC


-- 3. What was the most common exclusion?
SELECT TOP 1 extras , count(extras) AS time_ADD
FROM (SELECT v.extras 
FROM  dbo.##customer_orders_temp  c
CROSS APPLY dbo.splitstringsql( c.exclusions , ',') v ) extrass_add
GROUP BY extras
ORDER BY time_ADD DESC
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:

--    * `Meat Lovers`
SELECT *
FROM dbo.##customer_orders_temp
WHERE pizza_id = 1 ;
--    * `Meat Lovers - Exclude Beef`
SELECT *
FROM dbo.##customer_orders_temp
WHERE pizza_id = 1 AND extras LIKE '%s3%s' ;
--    * `Meat Lovers - Extra Bacon`
SELECT *
FROM dbo.##customer_orders_temp
WHERE pizza_id = 1 AND extras LIKE '%s1%s' ;
--    * `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`
SELECT *
FROM dbo.##customer_orders_temp
WHERE pizza_id = 1 AND extras LIKE '%s6%s' AND extras LIKE '%s9%s' AND exclusions LIKE '%s1%s' AND exclusions LIKE '%s4%s';
--5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
SELECT *
FROM dbo.##customer_orders_temp ;
--   * For example: `"Meat Lovers: 2xBacon, Beef, ... , Salami"`

--6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?