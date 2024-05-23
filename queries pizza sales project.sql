--Q1; Retrieve the total number of orders placed.
SELECT COUNT(*) Total_orders
FROM orders;
-- 
--Q2; Calculate the total revenue generated from pizza sales.

SELECT
ROUND(SUM(price*quantity),2) Total_Revenue
FROM pizza p JOIN
order_details od ON 
p.pizza_id=od.pizza_id;


--Q3; Identify the highest-priced pizza.

SELECT TOP 1 name,round(price,2) price
FROM pizza p JOIN
pizza_types pt ON
P.pizza_type_id=pt.pizza_type_id
ORDER BY price DESC;
--Q4; Identify the most common pizza size ordered.
SELECT  P.size,COUNT(od.order_details_id) total_count from
pizza p JOIN  order_details od ON
p.pizza_id=od.pizza_id
GROUP BY P.size
ORDER BY total_count DESC;

--Q5;List the top 5 most ordered pizza
--types along with their quantities.
SELECT TOP 5 name,
SUM(quantity)Total_quantity FROM pizza_types pt
JOIN pizza p ON p.pizza_type_id=pt.pizza_type_id
JOIN order_details od ON p.pizza_id=od.pizza_id
GROUP BY name 
ORDER BY Total_quantity DESC;

--Q6;Join the necessary tables to find the total
--quantity of each pizza category ordered.

SELECT category,
SUM(quantity) quantity 
FROM pizza_types
pt JOIN pizza P ON 
P.pizza_type_id=pt.pizza_type_id
JOIN order_details od 
ON p.pizza_id=od.pizza_id
GROUP BY category 
ORDER BY quantity DESC;

--Q7;Determine the distribution 
--of orders by hour of the day.

SELECT DATEPART(HOUR,time)
Hourly_distribution,
COUNT(order_id) Number_of_orders
          FROM orders
    GROUP BY DATEPART(HOUR,time) 
	ORDER BY Number_of_orders  DESC ;
       
--Q8;Join relevant tables to find 
--the category-wise distribution of pizzas.


SELECT category,
COUNT(name) number_of_pizza_types
FROM pizza_types
GROUP BY category;

--Q9;Group the orders by date and calculate the average 
--number of pizzas ordered per day.
SELECT AVG(quantity)
AVG_order_per_day FROM(
SELECT date
,sum(quantity) quantity FROM orders o 
JOIN
order_details od ON o.order_id=od.order_id
GROUP BY date) a;

--Q10;Determine the top 3 most 
--ordered pizza types based on revenue.

SELECT TOP 3 
name,SUM(price*quantity) Revenue
FROM pizza_types pt 
JOIN pizza p ON P.pizza_type_id=pt.pizza_type_id
JOIN order_details od ON p.pizza_id=od.pizza_id
GROUP BY name
ORDER BY Revenue DESC;
--Q11;Calculate the percentage contribution
--of each pizza type to total revenue.

SELECT category,ROUND((SUM(quantity*price)/
(SELECT SUM(quantity*price) FROM pizza P
 join order_details od ON
 P.pizza_id=od.pizza_id)),2)*100 revenue
 FROM
pizza_types pt 
JOIN pizza p ON 
p.pizza_type_id=pt.pizza_type_id
JOIN order_details od ON
p.pizza_id=od.pizza_id
GROUP BY category
ORDER BY revenue DESC;

--Q12;Analyze the cumulative revenue generated over time.

SELECT date ,SUM(revenue) 
OVER (ORDER BY date) Cumulative_revenue
FROM(
SELECT date,ROUND(SUM(quantity*price),2) revenue FROM
orders o JOIN order_details od
ON o.order_id=od.order_id
JOIN pizza p ON
p.pizza_id=od.pizza_id
GROUP BY date
) a;

--Q13;Determine the top 3 most ordered pizza 
--types based on revenue for each pizza category.
SELECT category,name,Ranking FROM (
SELECT category,name,revenue,RANK()
OVER(PARTITION BY category ORDER BY revenue DESC) Ranking
FROM 
(SELECT category,name,ROUND(SUM(quantity*price),2) revenue
FROM pizza_types pt JOIN pizza p 
ON pt.pizza_type_id=p.pizza_type_id 
join order_details od ON p.pizza_id=od.pizza_id
GROUP BY category,name) a) b
WHERE Ranking<=3;
