# Project-Deforestation

Create database Deforestation; 

select * from land_area;
select * from forest_area;
select * from region;


SELECT TOTAL_AREA_SQ_MI, CASE WHEN TOTAL_AREA_SQ_MI IS NULL THEN 0 ELSE TOTAL_AREA_SQ_MI END FROM Land_Area;

UPDATE Land_Area SET TOTAL_AREA_SQ_MI = CASE WHEN TOTAL_AREA_SQ_MI IS NULL THEN 0 ELSE TOTAL_AREA_SQ_MI END;

--Question 1: What are the total number of countries involved in deforestation?

select count(country_name) total_countries_involved from (
select country_name, count(year) as year_without_deforestation from
(select country_name, year, forest_area_sqkm,
rank() over(partition by country_name order by forest_area_sqkm) rank from forest_area) u
where rank = 2
group by country_name) B
where year_without_deforestation < 27;

![Q1](https://github.com/BigDaps6470/Deforest/assets/162059540/8118d5b0-eed2-46b1-80c0-4f47db76b6c2)


--Question 2: Show the income groups of countries having total area ranging from 75,000 to 150,000 square meters?

SELECT DISTINCT Land_Area.country_name, region.income_group
FROM Land_Area
JOIN region on Land_Area.country_code = region.country_code 
WHERE land_area.total_area_sq_mi BETWEEN 75000 AND 150000;
![Q2](https://github.com/BigDaps6470/Deforest/assets/162059540/29501d89-c88d-4afb-ad7e-b31f00b5fb20)

-- Question 3: Calculate average area in square miles for countries in the 'upper middle income region'. 
-- Compare the result with the rest of the income categories.

SELECT
  r.income_group,
  AVG(l.total_area_sq_mi) AS average_area_sq_miles
FROM
  region r
JOIN
  land_area l ON r.country_code = l.country_code
WHERE
  r.income_group = 'Upper Middle Income'
GROUP BY
  r.income_group
UNION
SELECT
  r.income_group,
  AVG(l.total_area_sq_mi) AS average_area_sq_miles
FROM
  region r
JOIN
  land_area l ON r.country_code = l.country_code
WHERE
  r.income_group != 'Upper Middle Income'
GROUP BY
  r.income_group;
![Q3](https://github.com/BigDaps6470/Deforest/assets/162059540/e047baa9-1efb-4052-a4e3-8317ed07c41d)


-- Question 4: Determine the total forest area in square km for countries in the 'high income' group. 
-- Compare result with the rest of the income categories.
select * from forest_area
SELECT
  r.income_group,
  SUM(l.forest_area_sqkm) AS total_forest_area_sq_km
FROM
  region r
JOIN
  forest_area l ON r.country_code = l.country_code
WHERE
  r.income_group = 'High Income'
GROUP BY
  r.income_group
UNION
SELECT
  r.income_group,
  SUM(l.forest_area_sqkm) AS total_forest_area_sqkm
FROM
  region r
JOIN
  forest_area l ON r.country_code = l.country_code
WHERE
  r.income_group != 'High Income'
GROUP BY
  r.income_group;
![Q4](https://github.com/BigDaps6470/Deforest/assets/162059540/4f02eac7-17c0-4db6-878c-8a6e18e281fe)

 
  -- Question 5: Show countries from each region(continent) having the highest total forest areas. 
  WITH ranked_forest_area AS (
  SELECT
    r.region,
    f.country_name,
    f.forest_area_sqkm,
    ROW_NUMBER() OVER (PARTITION BY r.region ORDER BY f.forest_area_sqkm DESC) AS area_rank
  FROM
    region r
  JOIN
    forest_area f ON r.country_code = f.country_code
)
SELECT
  region,
  country_name,
  forest_area_sqkm
FROM
  ranked_forest_area
WHERE
  area_rank = 1;

![Q5](https://github.com/BigDaps6470/Deforest/assets/162059540/9418d3d1-2dc0-4837-a95a-ea62a2f58cd6)

  
