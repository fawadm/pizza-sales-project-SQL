--Q1; Retrieve the total number of orders placed.
SELECT COUNT(*)
FROM orders;
-- 
--Q2; Calculate the total revenue generated from pizza sales.
SELECT 
ROUND(SUM(price*quantity),2)
FROM pizza p JOIN
order_details od ON 
p.pizza_id=od.pizza_id
--Q3; Identify the highest-priced pizza.
SELECT TOP 1 name,round(price,2) price FROM pizza p JOIN
pizza_types pt ON P.pizza_type_id=pt.pizza_type_id
ORDER BY price DESC;
--Q4; Identify the most common pizza size ordered.
SELECT  P.size,COUNT(od.order_details_id) total_count from
pizza p JOIN  order_details od ON
p.pizza_id=od.pizza_id
GROUP BY P.size
ORDER BY total_count DESC;

--Q5;List the top 5 most ordered pizza
--types along with their quantities.
SELECT TOP 5 name,SUM(od.order_details_id) quantity FROM pizza_types pt
JOIN pizza p ON p.pizza_type_id=pt.pizza_type_id
JOIN order_details od ON p.pizza_id=od.pizza_id
GROUP BY name 
ORDER BY quantity DESC;



