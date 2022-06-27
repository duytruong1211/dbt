
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
total_paid as (
select order_id, max(order_item_id) as total_items, sum(price) as base_price, sum(freight_value) as ship_fee, sum(price)+ sum(freight_value) as total from order_items oi 
group by order_id),
name_length as (
select product_name_lenght, product_description_lenght, product_photos_qty 
from products p2), 
products_size as ( 
select p.index, p.product_id, pcnt.product_category_name_english, p.product_weight_g, p.product_length_cm * p.product_height_cm * p.product_width_cm as volume_cm3 from 
products p inner join product_category_name_translation pcnt on p.product_category_name = pcnt.product_category_name 
),
results as (select* from orders left join total_paid on orders.order_id = total_paid.order_id)
select* from results
/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
