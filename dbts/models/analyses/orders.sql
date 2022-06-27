
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
	AVG(review_score) avg_review_score
from
	brazilian_data.order_reviews r
group by 1
	)
select
	o.*,
	r.avg_review_score
from 
	brazilian_data.orders o 
	left join reviews r on r.order_id = o.order_id
limit 100
/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
