
-- Use the `ref` function to select from other models

select *
from {{ ref('orders') }}
limit 10
-- where order_id = 1
