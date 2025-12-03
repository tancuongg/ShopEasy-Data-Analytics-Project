-- Query to clean up customer_journey data:
-- 1. Remove duplicate records
-- 2. Normalize Stage column (capitalize first letter, lowercase the rest)
-- 3. Replace NULL Duration values with averages (by VisitDate, then by Stage)

-- Step 1: CTE to identify duplicate records
WITH DuplicateRecords AS (
    SELECT JourneyID, CustomerID, ProductID, VisitDate, Stage, Action, Duration,
           -- ROW_NUMBER(): assigns a sequential number to each row within a partition
           -- Partition by key attributes: CustomerID, ProductID, VisitDate, Stage, Action, Duration
           -- If two rows are identical across these fields, they are grouped together
           -- DuplicateCount = 1 → keep this record; > 1 → mark as duplicate
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action, Duration 
               ORDER BY JourneyID
           ) AS DuplicateCount
    FROM dbo.customer_journey
),

-- Step 2: CTE to calculate average Duration by VisitDate
AvgByDate AS (
    SELECT VisitDate, AVG(Duration) AS AvgDateDuration
    FROM dbo.customer_journey
    GROUP BY VisitDate
),

-- Step 3: CTE to calculate average Duration by Stage
AvgByStage AS (
    SELECT Stage, AVG(Duration) AS AvgStageDuration
    FROM dbo.customer_journey
    GROUP BY Stage
)

-- Step 4: Final query - select cleaned data
SELECT d.JourneyID,
       d.CustomerID,
       d.ProductID,
       d.VisitDate,
       -- Normalize Stage: capitalize first letter, lowercase the rest
       UPPER(LEFT(d.Stage, 1)) + LOWER(RIGHT(d.Stage, LEN(d.Stage) - 1)) AS Stage,
       d.Action,
       -- Handle NULL Duration values:
       -- If Duration is NULL → use average by VisitDate
       -- If still NULL → use average by Stage
       COALESCE(d.Duration, ad.AvgDateDuration, ast.AvgStageDuration) AS Duration
FROM DuplicateRecords d
-- Join with average by date
LEFT JOIN AvgByDate ad ON d.VisitDate = ad.VisitDate
-- Join with average by stage
LEFT JOIN AvgByStage ast ON d.Stage = ast.Stage
-- Keep only the first occurrence of each duplicate group
WHERE d.DuplicateCount = 1
-- Sort results by VisitDate ascending
ORDER BY d.VisitDate ASC;
