CREATE DATABASE IF NOT EXISTS bronze;
CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;

-- Point tables to your existing Delta folders (
CREATE TABLE IF NOT EXISTS bronze.users
USING DELTA
LOCATION '/mnt/lz2/delta/tables/bronze/users';

CREATE TABLE IF NOT EXISTS bronze.buyers
USING DELTA
LOCATION '/mnt/lz2/delta/tables/bronze/buyers';

CREATE TABLE IF NOT EXISTS bronze.sellers
USING DELTA
LOCATION '/mnt/lz2/delta/tables/bronze/sellers';

CREATE TABLE IF NOT EXISTS bronze.countries
USING DELTA
LOCATION '/mnt/lz2/delta/tables/bronze/countries';

CREATE TABLE IF NOT EXISTS silver.users
USING DELTA
LOCATION '/mnt/lz2/delta/tables/silver/users';

CREATE TABLE IF NOT EXISTS silver.buyers
USING DELTA
LOCATION '/mnt/lz2/delta/tables/silver/buyers';

CREATE TABLE IF NOT EXISTS silver.sellers
USING DELTA
LOCATION '/mnt/lz2/delta/tables/silver/sellers';

CREATE TABLE IF NOT EXISTS silver.countries
USING DELTA
LOCATION '/mnt/lz2/delta/tables/silver/countries';

CREATE TABLE IF NOT EXISTS gold.ecom_one_big_table
USING DELTA
LOCATION '/mnt/lz2/delta/tables/gold/ecom_one_big_table';


SELECT * FROM gold.ecom_one_big_table LIMIT 20;

-- row counts for sanity
SELECT 'gold.ecom_one_big_table' AS table_name, COUNT(*) AS rows FROM gold.ecom_one_big_table
UNION ALL SELECT 'silver.users', COUNT(*) FROM silver.users
UNION ALL SELECT 'silver.buyers', COUNT(*) FROM silver.buyers
UNION ALL SELECT 'silver.sellers', COUNT(*) FROM silver.sellers
UNION ALL SELECT 'silver.countries', COUNT(*) FROM silver.countries;

-- Nulls and type issues for sanity
SELECT 
  SUM(CASE WHEN Country IS NULL THEN 1 END) AS null_country,
  SUM(CASE WHEN Users_hasanyapp IS NULL THEN 1 END) AS null_hasapp,
  SUM(CASE WHEN Users_socialnbfollowers IS NULL THEN 1 END ) AS null_followers
FROM gold.ecom_one_big_table;

-- app adoption by country
SELECT 
    Country,
    AVG(CASE WHEN Users_hasanyapp THEN 1.0 ELSE 0.0 END) AS app_adoption_rate
FROM gold.ecom_one_big_table
GROUP BY Country
ORDER BY app_adoption_rate DESC
LIMIT 15;

-- followers vs app adoption
SELECT 
    Users_hasanyapp,
    ROUND(AVG(Users_socialnbfollowers),1) AS avg_followers
FROM gold.ecom_one_big_table
GROUP BY Users_hasanyapp
ORDER BY avg_followers DESC;

-- wishlist vs. sellers capacity (country level)
SELECT 
    Country,
    SUM(Users_productsWished) AS wished_total,
    SUM(Users_productsSold)   AS sold_total,
    MAX(Sellers_MeanProductsListed) AS sellers_capacity_proxy
FROM gold.ecom_one_big_table
GROUP BY Country
ORDER BY wished_total DESC , sellers_capacity_proxy DESC
LIMIT 20;

-- Buyer gender balance & potential opportunity
SELECT 
    Country,
    Buyers_Female,
    Buyers_Male,
    ROUND(Buyers_Female * 1.0 / NULLIF(Buyers_Male,0), 2) AS female_to_male_ratio
FROM gold.ecom_one_big_table
ORDER BY female_to_male_ratio DESC
LIMIT 20;

-- Account maturity vs. engagement (feature/retention signal)
SELECT
  Users_account_age_group,
  ROUND(AVG(Users_socialnbfollowers), 1) AS avg_followers,
  ROUND(AVG(Users_productsWished), 1)    AS avg_wished,
  ROUND(AVG(Users_productsSold), 1)      AS avg_sold
FROM gold.ecom_one_big_table
GROUP BY Users_account_age_group
ORDER BY avg_followers DESC;

-- Country quality signal from sellers (supply health)
SELECT
  Country,
  ROUND(AVG(Sellers_MeanProductsListed), 2) AS avg_listed_per_seller,
  ROUND(AVG(Sellers_MeanProductsSold), 2)   AS avg_sold_per_seller
FROM gold.ecom_one_big_table
GROUP BY Country
ORDER BY avg_sold_per_seller DESC
LIMIT 15;

-- High‑performance markets flag (Silver signal)
SELECT country
FROM silver.countries
WHERE high_performance = 'True'
ORDER BY country;

-- Conversion‑like ratio (wish to sold proxy) by country
SELECT
  Country,
  ROUND(SUM(Users_productsSold) * 1.0 / NULLIF(SUM(Users_productsWished),0), 3) AS wish_to_sold_ratio
FROM gold.ecom_one_big_table
GROUP BY Country
HAVING SUM(Users_productsWished) > 0
ORDER BY wish_to_sold_ratio DESC
LIMIT 20;

