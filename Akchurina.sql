--1
select c.job_industry_category, count(*) as customers_count
from customer c 
group by c.job_industry_category 
order by customers_count desc 

--2
select 
	substring(t.transaction_date , 4) as month, 
	c.job_industry_category,
	sum(t.list_price) as total
from transaction t JOIN customer c 
	on c.customer_id = t.customer_id 
--where t.order_status ='Approved'
group by month, c.job_industry_category

--3
select t.brand, count(*) as total
from transaction t  join customer c 
on t.customer_id  = c.customer_id
where 
	t.order_status ='Approved' and 
	t.online_order ='True' and 
	c.job_industry_category = 'IT'
group by t.brand 

--6
select t.customer_id, min(t.transaction_date) OVER (PARTITION BY t.customer_id)
from "transaction" t 

--5
with cte as (select customer_id as id, sum(t.list_price) as total from transaction t
group by customer_id)
select c.last_name, c.first_name 
from cte ct join customer c 
on ct.id = c.customer_id 
where ct.total = (select max(total) from cte) or ct.total =(select min(total) from cte)

--4
select t.customer_id, sum(list_price) as total, min(t.list_price), max(list_price), count(*) as total_count 
from transaction t
group by t.customer_id 
order by total desc, total_count desc

select 
	t.customer_id, 
	sum(t.list_price) over (partition by t.customer_id) as total, 
	min(t.list_price) over (partition by t.customer_id), 
	max(t.list_price) over  (partition by t.customer_id),
	count(*) over (partition by t.customer_id) as total_count 
from transaction t
order by total desc, total_count desc

--7
with cte as(
select t.customer_id, max(TO_DATE(t.transaction_date, 'DD.mm.YYYY')) - max(TO_DATE(t.transaction_date, 'DD.mm.YYYY')) as disp 
from "transaction" t
group by t.customer_id)
select c.last_name, c.first_name
from customer c join cte ct on
c.customer_id  = ct.customer_id
where ct.disp = (select max(disp) from cte)
