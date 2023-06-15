/*markdown
# VIVINO DB
*/

/*markdown
## 10 wines to increase our sales, which ones should we choose and why?
*/

SELECT id, name, ratings_average,ratings_count, ROUND(ratings_average*ratings_count) AS weighted_average 
FROM wines
WHERE ratings_average >= 4.6
ORDER BY weighted_average DESC
LIMIT 10

/*markdown
## We have a marketing budget for this year, which country should we prioritise and why?
*/

SELECT countries.name AS country, ROUND(AVG(ratings_average),2) AS avg_rating, SUM(ratings_count), users_count,  
ROUND((wines_count*1.0)/users_count,2) AS wine_per_user, SUM(user_structure_count)
FROM wines
INNER JOIN regions
ON wines.region_id = regions.id
INNER JOIN countries
ON regions.country_code = countries.code
GROUP BY country_code
HAVING SUM(user_structure_count) > 50
ORDER BY users_count 

/*markdown
South Africa is one of the countries with less users of Vivino despite it's population (it's 7th),
but still has good wines being 6th out of 17 countries on average rating per country, 
It also has some engaged users regarding its sum of ratings_count, and user_structure_count who are voting for wines, 
and it has great number of wines regarding its wine_per_user.
So marketting campaign for South Africa may be useful considering its population and growing economy.
*/

/*markdown
## to give a price to the best winery, which one should we choose and why? 
*/

SELECT wines.winery_id, wineries.name as winery_name, 
ROUND(AVG(ratings_average),1) AS winery_rating, COUNT(wines.id) AS wines_count,
SUM(ratings_count) AS winery_total_ratings
FROM wines 
INNER JOIN wineries
ON wines.winery_id = wineries.id
GROUP BY winery_id 
HAVING COUNT(wines.id) >1
ORDER BY ratings_average DESC, SUM(ratings_count) DESC 

/*markdown
Vega Sicilia (winery_id:11050) with 4.7 rating average of 3 different wines and 130949 rating counts in total. 
Which has 2 out of 3 wines are already in ten mostly and highest rated wines.
Second winery is Caymus (winery_id:1301) with 2 different wines with 4.6 and 4.7 and 199180 rating counts in total. 
*/

/*markdown
## We have detected that a big cluster of customers like a specific combination of tastes. We have identified few primary keywords that matches this and we would like you to find all the wines that have those keywords. To ensure accuracy of our selection, ensure that more than 10 users confirmed those keywords. Also, identify the flavor_groups related to those keywords.
- coffee
- toast
- green apple
- cream
- citrus
*/

/*markdown
### all wines that have those keywords: 
*/

SELECT wine_id, wines.name
FROM keywords_wine
INNER JOIN keywords
ON keywords_wine.keyword_id = keywords.id
INNER JOIN wines
ON keywords_wine.wine_id = wines.id
WHERE keywords.name IN ("coffee","toast","green apple","cream","citrus") 
    AND keyword_type = 'primary'
    AND count > 10 
GROUP BY wine_id
HAVING COUNT(wine_id) >= 5

/*markdown
### flavor_groups:
*/

SELECT DISTINCT keywords.name, keywords_wine.group_name, keyword_type
FROM keywords_wine
INNER JOIN keywords
ON keywords_wine.keyword_id = keywords.id
INNER JOIN wines
ON keywords_wine.wine_id = wines.id
WHERE keywords.name IN ("coffee","toast","green apple","cream","citrus") 
AND count > 10 

/*markdown
## Find the top 3 most common grape all over the world?
*/

/*markdown
### 3 common grapes: 
*/

SELECT grapes.name, wines_count
FROM most_used_grapes_per_country
INNER JOIN grapes
ON most_used_grapes_per_country.grape_id = grapes.id
GROUP BY grape_id
ORDER BY wines_count DESC
LIMIT 3

/*markdown
##  We would to give create a country leaderboard, give us a visual that shows the average wine rating for each country. Do the same for the vintages. 
*/

SELECT countries.name AS country, ROUND(AVG(ratings_average),2) AS avg_rating, users_count
FROM wines
INNER JOIN regions
ON wines.region_id = regions.id
INNER JOIN countries
ON regions.country_code = countries.code
GROUP BY country_code
ORDER BY avg_rating DESC

/*markdown
### Vintages 
*/

SELECT countries.name AS country, ROUND(AVG(vintages.ratings_average),2) AS avg_rating
FROM vintages
INNER JOIN wines
ON vintages.wine_id = wines.id
INNER JOIN regions
ON wines.region_id = regions.id
INNER JOIN countries
ON regions.country_code = countries.code
GROUP BY country_code
ORDER BY avg_rating DESC

/*markdown
## Give us any other useful insights you found in our data. Be creative!
*/



/*markdown
## One of our VIP client like Cabernet Sauvignon, he would like a top 5 recommandation, which wines would you recommend to him? 
### Bases on everything you did previously, find what would suit best for another recommandation than Cabernet Sauvignon to this client.
*/

SELECT AVG(acidity), AVG(fizziness), AVG(intensity) , AVG(sweetness), AVG(tannin)
FROM wines
WHERE name LIKE '%Cabernet Sauvignon%'

SELECT id, name, acidity, fizziness, intensity, sweetness, tannin, ratings_average, user_structure_count
FROM wines
WHERE name NOT LIKE '%Cabernet Sauvignon%' 
    AND acidity BETWEEN 3 AND 3.6
    AND intensity BETWEEN 4.3 AND 4.9
    AND sweetness BETWEEN 1.4 AND 2
    AND tannin BETWEEN 3 AND 3.8
    AND ratings_average > 4.4
ORDER BY user_structure_count DESC
LIMIT 5