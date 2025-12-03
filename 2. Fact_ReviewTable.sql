-- Clean up extra white spaces in ReviewText column
SELECT 
    ReviewID,       
    CustomerID,      
    ProductID,       
    ReviewDate,      
    Rating,         
    -- Normalize ReviewText:
    -- Replace double spaces with a single space to improve text consistency
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM dbo.customer_reviews;
