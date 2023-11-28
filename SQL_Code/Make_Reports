/*
Viết câu query trả về top sản phẩm có doanh thu cao nhất. Chọn đáp án là tên của 2 sản phẩm có doanh thu cao nhất, theo thứ tự giảm dần.
*/
SELECT sales__order_lines.stock_item_id
  ,warehouse__stock_items.stock_item_name
  ,sum(sales__order_lines.quantity*sales__order_lines.unit_price) as total_revenue
FROM `vit-lam-data.wide_world_importers.sales__order_lines` as sales__order_lines
LEFT JOIN `vit-lam-data.wide_world_importers.warehouse__stock_items`  as warehouse__stock_items
  ON sales__order_lines.stock_item_id = warehouse__stock_items.stock_item_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 2



/*
Viết câu query trả về doanh thu theo tháng. Chọn đáp án là doanh thu tương ứng của tháng 1-2-3 của năm 2015.
*/

SELECT datetime_trunc(sales__orders.order_date, month) as periods
  , sum (sales__order_lines.quantity * sales__order_lines.unit_price) as monthly_revenue
FROM `vit-lam-data.wide_world_importers.sales__order_lines` as sales__order_lines
LEFT JOIN `vit-lam-data.wide_world_importers.sales__orders` as sales__orders
  ON sales__order_lines.order_id = sales__orders.order_id
WHERE sales__orders.order_date >= timestamp ("2015-1-1")
  and sales__orders.order_date < timestamp ("2015-4-1")
GROUP BY 1

/*
Viết câu query trả về doanh thu theo nhóm khách hàng. Chọn đáp án là tên nhóm khách hàng có doanh thu cao nhất và doanh thu tương ứng của nhóm. 
*/

WITH sales__customer_categories_info AS (
  SELECT sales__customers.customer_id
    ,sales__customers.customer_name
    ,sales__customers.customer_category_id
    ,sales__customer_categories.customer_category_name
  FROM `vit-lam-data.wide_world_importers.sales__customers` as sales__customers
  LEFT JOIN `vit-lam-data.wide_world_importers.sales__customer_categories` as sales__customer_categories
    on sales__customers.customer_category_id = sales__customer_categories.customer_category_id
) 
,sales__customer_orders as (
  SELECT sales__orders.order_id
    , sales__customer_categories_info.customer_category_id
    , sales__customer_categories_info.customer_category_name
    , sales__customer_categories_info.customer_name    
  FROM `vit-lam-data.wide_world_importers.sales__orders` as sales__orders
  LEFT JOIN sales__customer_categories_info
    on sales__orders.customer_id = sales__customer_categories_info.customer_id
)
SELECT sales__customer_orders.customer_category_id
  ,sales__customer_orders.customer_category_name
  ,sum(sales__order_lines.quantity*sales__order_lines.unit_price) as total_revenue 
FROM `vit-lam-data.wide_world_importers.sales__order_lines` as sales__order_lines
LEFT JOIN sales__customer_orders
  on sales__order_lines.order_id = sales__customer_orders.order_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1
