-- QUERY #1
-- Pull in avg_total_golds by region
SELECT
	region,
	AVG(total_golds) AS avg_total_golds
FROM
	(SELECT
		region,
		country_id,
		SUM(gold) AS avg_total_golds
	FROM summer_games_clean AS s
	JOIN countries AS c
	ON s.country_id = c.id
	-- Alias the subquery
	GROUP BY region, country_id) AS subquery
GROUP BY region
-- Order by avg_total_golds in descending order
ORDER BY avg_total_golds DESC;

-- QUERY #2
SELECT
	-- Query region, athlete_name, and total gold medals
	region,
	name AS athlete_name,
	SUM(gold) AS total_golds,
	-- Assign a regional rank to each athlete
	ROW_NUMBER() OVER (PARTITION 
BY region ORDER BY SUM(gold) DESC)
AS row_num
FROM summer_games_clean AS s
JOIN athletes AS a
ON a.id = s.athlete_id
JOIN countries AS c
ON s.country_id = c.id
GROUP BY region, athlete_name;

-- QUERY #3
-- Query region, athlete_name, and total_golds
SELECT
	region,
	athlete_name,
	total_golds
FROM
	(SELECT
		-- Query region, athlete_name, and total gold medals
		region,
		name AS athlete_name,
		SUM(gold) AS total_golds,
		-- Assign a regional rank to each athlete
		ROW_NUMBER() OVER (PARTITION 
BY region ORDER BY SUM(gold) DESC) AS 
row_num
	FROM summer_games_clean AS s
	JOIN athletes AS a
	ON a.id = s.athlete_id
	JOIN countries AS c
	ON s.country_id = c.id 
	-- Alias as subquery
	GROUP BY region, athlete_name) AS subquery
-- Filter for only the top athlete per region
WHERE row_num = 1;


-- QUERY #4
-- Pull country_gdp by region and country 
SELECT
	region,
	country,
	sum(gdp) AS country_gdp
FROM country_stats AS cs 
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country 
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

-- QUERY #5
-- Pull country_gdp by region and country 
SELECT
	region,
	country,
	sum(gdp) AS country_gdp,
	-- Calculate the global gdp
	sum(sum(gdp)) OVER () global_gdp
FROM country_stats AS cs 
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country 
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

-- QUERY #6
-- Pull country_gdp by region and country 
SELECT
	region,
	country,
	sum(gdp) AS country_gdp,
	-- Calculate the global gdp
	sum(sum(gdp)) OVER () global_gdp,
	-- Calculate percent of global gdp 
	sum(gdp) / (sum(sum(gdp))
OVER ()) AS perc_global_gdp
FROM country_stats AS cs 
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country 
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

-- QUERY #7
-- Pull country_gdp by region and country 
SELECT
	region,
	country,
	sum(gdp) AS country_gdp,
	-- Calculate the global gdp
	sum(sum(gdp)) OVER () global_gdp,
	-- Calculate percent of global gdp 
	sum(gdp) / (sum(sum(gdp))
OVER ()) AS perc_global_gdp,
	-- Calculate percent of gdp relative to its region
	sum(gdp) / sum(sum(gdp)) OVER (PARTITION BY region)
	AS perc_region_gdp
FROM country_stats AS cs 
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country 
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;
