--Total number of rows in the fountains table
SELECT COUNT(*) 
FROM fountains;

-- Count the number of fountains by fountain type
SELECT fountaintype, COUNT(*) AS fountain_count
FROM fountains
GROUP BY fountaintype;

-- Count the number of fountains in each borough
SELECT borough, COUNT(*) AS fountain_count
FROM fountains
GROUP BY borough;

-- Count the number of active and inactive fountains
SELECT featurestatus, COUNT(*) AS fountain_count
FROM fountains
GROUP BY featurestatus;

-- Count the number of fountains in each park
SELECT propname, COUNT(*) AS fountain_count
FROM fountains
GROUP BY propname;

-- Find fountains where the Painted column is NULL
SELECT *
FROM fountains
WHERE painted IS NULL;

-- Find fountains with more than one count
SELECT *
FROM fountains
WHERE fountaincount > 1;

-- Unique fountain types along with their associated average fountain count
SELECT fountaintype, AVG(fountaincount) AS avg_fountain_count
FROM fountains
GROUP BY fountaintype;

--  Find the top 5 parks with the highest number of fountains
SELECT 
    propname,
    COUNT(*) AS fountain_count
FROM fountains
GROUP BY propname
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Find the nearest fountains to a given latitude and longitude
SELECT *, 
    sqrt(power(latitude - 40.661576, 2) + power(longitude - -73.989329, 2)) AS distance
FROM fountains
ORDER BY distance
LIMIT 10;
 
--  Select fountains from parks with more than 10 fountains:
SELECT *
FROM fountains
WHERE gispropnum IN (SELECT gispropnum
                     FROM fountains
                     GROUP BY gispropnum
                     HAVING COUNT(*) > 10);

-- Calculate the total count of active and inactive fountains in each borough
SELECT 
    borough,
    SUM(CASE WHEN FeatureStatus = 'Active' THEN 1 ELSE 0 END) AS active_count,
    SUM(CASE WHEN FeatureStatus = 'Inactive' THEN 1 ELSE 0 END) AS inactive_count
FROM fountains
GROUP BY borough;

-- Rank the fountains based on their fountain counts across all boroughs
SELECT *,
       RANK() OVER (ORDER BY fountaincount DESC) AS overall_fountain_rank
FROM fountains;

-- Calculate the fountain density by borough
-- Create and populate the borough_areas table
CREATE TABLE borough_areas (
    Borough VARCHAR(255),
    Area_km2 FLOAT
);

INSERT INTO borough_areas (Borough, Area_km2) VALUES
('Brooklyn', 183.4),
('Manhattan', 59.1),
('Staten Island', 151.5),
('Bronx', 109.7),
('Queens', 283.0);

-- Calculate fountain density by borough using a CTE
WITH FountainCounts AS (
    SELECT Borough, COUNT(*) AS fountain_count
    FROM fountains
    GROUP BY Borough
)
SELECT 
    fc.Borough, 
    fc.fountain_count, 
    ba.Area_km2, 
    (fc.fountain_count / ba.Area_km2) AS fountain_density_per_km2
FROM 
    FountainCounts fc
JOIN 
    borough_areas ba ON fc.Borough = ba.Borough;
