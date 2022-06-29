
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
	)
select
	o.*,
	p.num_payment,
	p.pmt_type,
	p.avg_pmt_installment,
	r.avg_review_score
from 
	brazilian_data.orders o 
	left join reviews r on r.order_id = o.order_id
	left join payments p on p.order_id  = o.order_id
	left join items i on i.order_id = o.order_id
/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
