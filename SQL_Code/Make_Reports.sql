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


/*
Viết câu query có dùng CTE, phân nhóm khách hàng theo tổng chi tiêu trong năm 2015:
(1) Ít chi tiêu: $0 - $50,000
(2) Chi tiêu thường: $50,000 - $100,000
(3) Chi tiêu nhiều: > $100,000
*/

WITH customer_segments as (
  SELECT sales__orders.customer_id
    ,sum(sales__order_lines.quantity*sales__order_lines.unit_price) as expenditure
    ,case 
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) <= 50000 
        and sum(sales__order_lines.quantity*sales__order_lines.unit_price) > 0 then 1   
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) <= 100000 
        and sum(sales__order_lines.quantity*sales__order_lines.unit_price) > 50000 then 2
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) >= 100000 then 3
      else 0
    end  as segments_id    
    ,case 
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) <= 50000 
        and sum(sales__order_lines.quantity*sales__order_lines.unit_price) > 0 then "Ít chi tiêu"   
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) <= 100000 
        and sum(sales__order_lines.quantity*sales__order_lines.unit_price) > 50000 then "Chi tiêu thường"
      when sum(sales__order_lines.quantity*sales__order_lines.unit_price) >= 100000 then "Chi tiêu nhiều"
      else "Undefined"
    end  as segments_name
  FROM `vit-lam-data.wide_world_importers.sales__order_lines` as sales__order_lines
  JOIN `vit-lam-data.wide_world_importers.sales__orders` as sales__orders
    on sales__order_lines.order_id = sales__orders.order_id
  WHERE extract(year from sales__orders.order_date) = 2015
  GROUP BY 1
)

SELECT customer_segments.segments_id
  , customer_segments.segments_name
  ,count(customer_segments.customer_id)
FROM customer_segments
WHERE customer_segments.segments_id <> 0
GROUP BY 1,2
ORDER BY 1

/*
Viết câu query có dùng window function, tính doanh thu theo tháng và so sánh cùng kỳ năm ngoái (year-over-year). Xem hình dưới minh họa kết quả. Chọn đáp án là tỷ lệ year-over-year của tháng 6/2015 so với tháng 6/2014.
*/

WITH monthly_revenue as (
  SELECT date_trunc(sales__orders.order_date,month) as year_month

    , sum(sales__order_lines.quantity*sales__order_lines.unit_price) as total_revenue  
  FROM `vit-lam-data.wide_world_importers.sales__order_lines` as sales__order_lines
  JOIN `vit-lam-data.wide_world_importers.sales__orders` as sales__orders
    on sales__order_lines.order_id = sales__orders.order_id
  GROUP BY 1
)
SELECT format_date("%G-%m", this_year_monthly_revenue.year_month) year_month
  ,this_year_monthly_revenue.total_revenue as revenue
  ,format_date("%G-%m", last_year_monthly_revenue.year_month) last_year_month
  ,last_year_monthly_revenue.total_revenue as revenue_last_year
  ,this_year_monthly_revenue.total_revenue/last_year_monthly_revenue.total_revenue - 1 as year_over_year
FROM monthly_revenue as this_year_monthly_revenue
JOIN monthly_revenue as last_year_monthly_revenue
  on extract(year from this_year_monthly_revenue.year_month) = extract(year from last_year_monthly_revenue.year_month)+1
    and extract(month from this_year_monthly_revenue.year_month) = extract(month from last_year_monthly_revenue.year_month)
WHERE extract(year from this_year_monthly_revenue.year_month) = 2015
