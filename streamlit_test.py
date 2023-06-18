import sqlite3
import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt


conn = sqlite3.connect("vivino.db")

st.set_page_config(page_title="Vivino les bons plans", layout="wide")
st.title(body="VIVINO ANALYSIS PROJECT")
st.subheader(body="Market analysis of Vivino regarding data from its website")
st.image("./utils/sample.jpg")



st.title ("Vivino's Bests")
st.markdown("As the world’s largest online wine marketplace and most downloaded wine app, the Vivino community is made up of millions of wine drinkers from around the world, coming together to make buying the right wine simple, straightforward, and fun. ")
st.subheader("Best 10 Wines Regarding Rating Averages of Wines")

m1,m2 = st.columns(2)
with m1:
    st.image("./utils/1.png", width=600)
with m2:
    st.dataframe(pd.read_sql_query("""SELECT name AS 'Wine Name', ratings_average AS 'Average Rating',ratings_count AS 'Total Ratings', 
        ROUND(ratings_average*ratings_count) AS 'Weighted Average' 
        FROM wines WHERE ratings_average >= 4.6 
        ORDER BY 'Weighted Average' DESC 
        LIMIT 10""",conn,)
    ,hide_index=True, width=600)



st.subheader("Best Winery Prize Recommendations")

m2,m1 = st.columns(2)
with m1:
    st.image("./utils/2.png")
with m2:
    st.dataframe(pd.read_sql_query("""SELECT wineries.name as 'Winery Name', 
        ROUND(AVG(wines.ratings_average),2) AS 'Winery Rating', COUNT(wines.id) AS 'Total Wines',
        SUM(wines.ratings_count) AS 'Total Winery Ratings'
        FROM wines 
        INNER JOIN wineries
        ON wines.winery_id = wineries.id
        GROUP BY wines.winery_id 
        HAVING COUNT(wines.id) > 1
        ORDER BY ROUND(AVG(wines.ratings_average),2) DESC 
        LIMIT 10""",conn,)
    ,hide_index=True, width=600)


st.image("./utils/a.png")
st.title ("Market Overview")

m1,m2 = st.columns(2)
with m1:
    st.subheader("Average Wine Rating for Countries")
    st.image("./utils/3.png")
with m2:
    st.subheader("Average Vintage Wine Rating for Countries")
    st.image("./utils/4.png")


st.subheader("Market to Focus")
st.markdown("""South Africa is one of the countries with less users of Vivino, being 7th worldwide, despite it's population,
but still has good wines being 6th out of 17 countries on average rating per country.
It also has some engaged users regarding its sum of total ratings, and it has great number of wines regarding its wine per user data.
So marketting campaign for South Africa may be useful considering its population and growing economy.""")

m1,m2 = st.columns(2)
with m1:
    st.image("./utils/5.png")
with m2:
    st.dataframe(pd.read_sql_query("""SELECT countries.name AS Country, ROUND(AVG(ratings_average),2) AS 'Average Rating', SUM(ratings_count) AS 'Total Ratings', users_count AS 'Total Users',  
        ROUND((wines_count*1.0)/users_count,2) AS wine_per_user, ROUND(SUM(ratings_count)*100.0/users_count,2) AS rating_percent
        FROM wines
        INNER JOIN regions
        ON wines.region_id = regions.id
        INNER JOIN countries
        ON regions.country_code = countries.code
        GROUP BY country_code
        ORDER BY users_count 
        LIMIT 10""",conn,)
    ,hide_index=True)



st.title ("Focusing Taste")



m1,m2 = st.columns(2)
with m1:
    st.image("./utils/b.png", width=500)
with m2:
    st.header("Most Common Grape Types")
    labels = "Cabernet Sauvignon","Chardonnay", "Pinot Noir","Others"
    sizes = [8,16,33,43]
    colors=['darkred', 'bisque', 'brown', 'gainsboro']

    fig, ax = plt.subplots()
    ax.pie(sizes, labels=labels, autopct='%1.1f%%', colors=colors)

    st.pyplot(fig)



m2,m1 = st.columns(2)
with m1:
    n1,n2 = st.columns(2)
    with n1:
        st.image("./utils/a1.jpg")
        st.image("./utils/c1.jpg")
    with n2:
        st.image("./utils/b1.jpg")
        st.image("./utils/d1.jpg")
with m2:
    st.subheader("Specific Combination of Tastes")
    st.dataframe(pd.read_sql_query("""SELECT DISTINCT keywords.name, keywords_wine.group_name, keyword_type
        FROM keywords_wine
        INNER JOIN keywords
        ON keywords_wine.keyword_id = keywords.id
        INNER JOIN wines
        ON keywords_wine.wine_id = wines.id
        WHERE keywords.name IN ("coffee","toast","green apple","cream","citrus") 
        AND count > 10 """,conn,)
    ,hide_index=True)

    st.subheader("Wines with the Specific Combination")
    st.dataframe(pd.read_sql_query("""SELECT wines.name AS Wines, wineries.name AS Winery
        FROM keywords_wine
        INNER JOIN keywords
        ON keywords_wine.keyword_id = keywords.id
        INNER JOIN wines
        ON keywords_wine.wine_id = wines.id
        INNER JOIN wineries
        ON wines.winery_id = wineries.id
        WHERE keywords.name IN ("coffee","toast","green apple","cream","citrus") 
        AND keyword_type = 'primary'
        AND count > 10 
        GROUP BY wine_id
        HAVING COUNT(wine_id) >= 5 """,conn,)
    ,hide_index=True, width=700, height=630)

