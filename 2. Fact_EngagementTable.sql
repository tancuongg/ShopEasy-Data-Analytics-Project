-- Query to clean and normalize the engagement_data table 
SELECT 
    EngagementID,            
    ContentID,                
    CampaignID,            
    ProductID,       
    EngagementDate,   
    Likes,
    -- Normalize ContentType:
    -- 1. Replace "Socialmedia" with "Social media" for consistent spelling
    -- 2. Format to capitalize the first letter and make the rest lowercase
    UPPER(LEFT(REPLACE(ContentType,'Socialmedia', 'Social media'), 1)) 
        + LOWER(SUBSTRING(REPLACE(ContentType,'Socialmedia', 'Social media'), 2, LEN(ContentType))) AS ContentType,
    -- Split ViewsClicksCombined column into separate Views and Clicks columns:
    -- Example: "120-15" -> Views = 120, Clicks = 15
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views, 
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks
FROM dbo.engagement_data;
