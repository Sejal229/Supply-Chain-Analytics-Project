Create Database Supply_chain_data;

Use Supply_chain_data;

-- 1. Loss & Cost Efficiency Analysis
-- Identifying cities with negative profit (Loss) and checking if high logistics costs are affecting their overall cost efficiency ratio.
SELECT 
    Location, 
    ROUND(AVG(Net_profit), 2) AS Avg_Profit, 
    ROUND(SUM(Total_Logistics_Cost), 2) AS Total_Cost,
    ROUND(AVG(Cost_Efficiency_Ratio), 2) AS Avg_Efficiency
FROM Final_Supply_Chain_Analysis
GROUP BY Location
ORDER BY Avg_Profit ASC;

-- Warehouse Space & Utilization
-- Analyzing warehouse capacity utilization and inventory turnover by product category to identify underutilized storage space.
SELECT 
    Product_Category, 
    ROUND(AVG(Capacity_Utilization), 2) AS Avg_Utilization,
    ROUND(AVG(Inventory_Turnover_Ratio), 2) AS Avg_Turnover
FROM Final_Supply_Chain_Analysis
GROUP BY Product_Category
ORDER BY Avg_Utilization DESC;

-- Stockout Risk (Urgent Action)
-- Identifying specific warehouses with low stock-to-demand ratio (< 0.6) and high stockout risk scores (> 15).

SELECT 
    Warehouse_ID, 
    Location, 
    Product_Category, 
    Current_Stock, 
    Demand_Forecast,
    Stockout_Risk
FROM Final_Supply_Chain_Analysis
WHERE Stock_to_Demand_Ratio < 0.6 AND Stockout_Risk > 15
ORDER BY Stockout_Risk DESC;

-- Delivery Delay Impact
-- Evaluating the impact of high 'Total Order Cycle Time' (> 7 days) on Customer Ratings.

SELECT 
    Location,
    ROUND(AVG(Total_order_cycle_time), 2) AS Avg_Wait_Time,
    ROUND(AVG(Customer_Rating), 2) AS Avg_Rating
FROM Final_Supply_Chain_Analysis
GROUP BY Location
HAVING Avg(Total_order_cycle_time) > 7
ORDER BY Avg_Rating ASC;

-- Supplier Quality Check
-- Ranking suppliers based on their average order processing time and total count of damaged goods.

SELECT 
    Supplier_ID, 
    AVG(Order_Processing_Time) AS Avg_Process_Time,
    SUM(Damaged_Goods) AS Total_Damaged
FROM Final_Supply_Chain_Analysis
GROUP BY Supplier_ID
ORDER BY Total_Damaged DESC;

-- Shipping Time Buckets
-- Categorizing orders into Shipping Day buckets to find the exact threshold where customer ratings decline.

SELECT 
    ROUND(Shipping_Time_Days, 0) AS Shipping_Days_Bucket,
    AVG(Customer_Rating) AS Avg_Rating,
    COUNT(*) AS Total_Orders
FROM Final_Supply_Chain_Analysis
GROUP BY ROUND(Shipping_Time_Days, 0)
ORDER BY Shipping_Days_Bucket;


-- Outlier identifiation 
-- Detecting outlier warehouses that exhibit a critical combination of high shipping delays and very low customer ratings.

SELECT 
    Warehouse_ID, 
    Location, 
    AVG(Shipping_Time_Days) AS Avg_Time, 
    AVG(Customer_Rating) AS Avg_Rating
FROM Final_Supply_Chain_Analysis
GROUP BY Warehouse_ID, Location
HAVING AVG(Customer_Rating) < 3.0 -- Jo red dots the
AND AVG(Shipping_Time_Days) > 4.0; -- Jo late the


-- Strategic Delivery Speed Analysis
-- Strategic analysis of Delivery Speed (Fast/Medium/Slow) against Net Profit and Ratings.
SELECT 
    CASE 
        WHEN Shipping_Time_Days <= 3 THEN 'Fast (0-3 days)'
        WHEN Shipping_Time_Days <= 5 THEN 'Medium (4-5 days)'
        ELSE 'Slow (5+ days)'
    END AS Delivery_Speed,
    AVG(Net_Profit) AS Avg_Profit,
    AVG(Customer_Rating) AS Avg_Rating
FROM Final_Supply_Chain_Analysis
GROUP BY 
    CASE 
        WHEN Shipping_Time_Days <= 3 THEN 'Fast (0-3 days)'
        WHEN Shipping_Time_Days <= 5 THEN 'Medium (4-5 days)'
        ELSE 'Slow (5+ days)'
    END;