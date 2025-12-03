-- Query to categorize products into price tiers (Low / Medium / High)
SELECT *,
       -- Use NTILE(3) to split the ordered dataset into 3 equal groups (tertiles)
       -- Each row is assigned a bucket number (1, 2, or 3) based on Price ranking
       CASE NTILE(3) OVER (ORDER BY Price) 
            /* 
               T1 (tertile 1): Lowest 33.3% of prices → 'Low'
               T2 (tertile 2): Middle 33.3% of prices → 'Medium'
               T3 (tertile 3): Highest 33.3% of prices → 'High'
            */
            WHEN 1 THEN 'Low'
            WHEN 2 THEN 'Medium'
            ELSE 'High'
       END AS [Price Tier]  -- New column categorizing each product
FROM dbo.products
ORDER BY ProductID;
