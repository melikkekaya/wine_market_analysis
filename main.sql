/* VIVINO DB  */

/* 10 wines to increase our sales, which ones should we choose and why?*/
SELECT id, name, ratings_average,ratings_count, ROUND(ratings_average*ratings_count) AS weighted_average 
FROM wines
WHERE ratings_average >= 4.7
ORDER BY weighted_average DESC
LIMIT 10



/* which country should we prioritise and why? (since We have a marketing budget for this year) */



/* to give a price to the best winery, which one should we choose and why? */
-- SELECT wines.winery_id, wineries.name as winery_name, ratings_average, COUNT(wines.id),SUM(ratings_count)
-- FROM wines 
-- INNER JOIN wineries
-- ON wines.winery_id = wineries.id
-- GROUP BY winery_id 
-- ORDER BY ratings_average DESC, SUM(ratings_count) DESC 

-- Vega Sicilia, winery_id: 11050 with 4.8 rating average of 3 different wines and 130949 rating counts in total.




/* We have detected that a big cluster of customers like a specific combination of tastes.  */



/* We have identified few primary keywords that matches this and we would like you 
to find all the wines that have those keywords. 
To ensure accuracy of our selection, ensure that more than 10 users confirmed those keywords. 
Also, identify the flavor_groups related to those keywords.
Coffee,Toast,Green apple,cream,citrus */




/* Find the top 3 most common grape all over the world and for each grape, give us the the 5 best rated wines.(since We would like to do a selection of wines that are easy to find all over the world. ) */

/* We would to give create a country leaderboard, give us a visual that shows the average wine rating for each country. Do the same for the vintages. */

/* Give us any other useful insights you found in our data. Be creative! */
