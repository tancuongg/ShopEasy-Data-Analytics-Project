-- Join customer dimension with geography dimension to enrich customer data 
-- by adding geographic attributes such as country and city
SELECT 
    c.CustomerID,             
    c.CustomerName,         
    c.Email,                  
    c.Age,                     
    g.Country,                 
    g.City,                    
    -- Age classification into demographic groups
    CASE 
        WHEN c.Age <= 12 THEN 'Children'                  -- 0 - 12 years
        WHEN c.Age BETWEEN 13 AND 18 THEN 'Teenagers'     -- 13 - 18 years
        WHEN c.Age BETWEEN 19 AND 34 THEN 'Young Adults'  -- 19 - 34 years
        WHEN c.Age BETWEEN 35 AND 54 THEN 'Middle-aged Adults' -- 35 - 54 years
        WHEN c.Age >= 55 THEN 'Older Adults'              -- 55 years and above
    END AS AgeGroup       -- New column classifying age into groups

FROM dbo.customers c 
-- Join with geography table to bring in location information
INNER JOIN dbo.geography AS g 
    ON c.GeographyID = g.GeographyID;  -- Match customers with their corresponding geography
