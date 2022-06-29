-- Use the `ref` function to select from other models
{{config(materialized='table')}}
select 
	ui.*,
	g.geolocation_lat ,
	g.geolocation_lng 
from
	brazilian_data.user_info ui 
	inner join brazilian_data.geolocation g on g.geolocation_zip_code_prefix = ui.customer_zip_code_prefix 
-- where order_id = 1
