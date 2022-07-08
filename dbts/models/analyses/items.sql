{{config(materialized='table')}}
with
    name_length
    as
    (
        select product_id, product_name_lenght, product_description_lenght, product_photos_qty
        from brazilian_data.products p2
    ),
    products_size
    as
    (
        select p.index, p.product_id, pcnt.product_category_name_english, p.product_weight_g, p.product_length_cm * p.product_height_cm * p.product_width_cm as volume_cm3
        from
            brazilian_data.products p inner join brazilian_data.product_category_name_translation pcnt on p.product_category_name = pcnt.product_category_name
    )
,
    results2
    as
    (
        select oi.order_id, oi.product_id, ps.product_weight_g, ps.volume_cm3, oi.price, oi.freight_value , ps.product_category_name_english, nl.product_name_lenght, nl.product_description_lenght, oi.seller_id, s.seller_zip_code_prefix::text , s.seller_city, s.seller_state
        from brazilian_data.order_items oi left join products_size ps on oi.product_id = ps.product_id
            left join name_length nl on oi.product_id = nl.product_id
            left join brazilian_data.sellers s on oi.seller_id = s.seller_id
        order by oi.index
    )
select i.*, o.order_purchase_timestamp  
from results2 i left join
brazilian_data.orders o 
on i.order_id =o.order_id 