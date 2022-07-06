
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

-- {{ config(materialized='table') }}

with reviews as (
select
	r.order_id,
	round(AVG(review_score),2) avg_review_score
from
	brazilian_data.order_reviews r
group by 1
	),
items as (
select order_id,
		max(order_item_id) num_items	
from brazilian_data.order_items 
group by 1
),
payments as (
select
	order_id,
	max(payment_sequential) num_payment,
	string_agg(distinct payment_type, ', ') pmt_type,
	round(avg(payment_installments),2) avg_pmt_installment,
	sum(payment_value) order_value
from
	brazilian_data.order_payments
group by 1
	),
bad_data as (
select order_id  from brazilian_data.orders o
where  (o.order_delivered_customer_date::date < o.order_approved_at::date) or
 (order_status = 'delivered' and order_delivered_customer_date is null)
),
result as (
select
	o.order_id ,
	o.order_status,
	o.order_approved_at,
	o.order_delivered_carrier_date,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	p.num_payment,
	p.pmt_type,
	p.avg_pmt_installment,
	r.avg_review_score,
	(
		CASE
		WHEN i.num_items IS NULL THEN
			0
		ELSE
			i.num_items
		END
	) as num_items, 
	ui.customer_unique_id,
	ui.customer_city,
	ui.customer_state 
from 
	brazilian_data.orders o 
	left join bad_data on bad_data.order_id = o.order_id 
	left join reviews r on r.order_id = o.order_id
	left join payments p on p.order_id  = o.order_id
	left join items i on i.order_id = o.order_id
	inner join brazilian_data.user_info ui on ui.customer_id = o.customer_id 
where bad_data.order_id is null
)
select* from result




/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
