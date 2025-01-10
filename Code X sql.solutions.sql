CREATE TABLE fact_survey_responses (
    Response_ID varchar(50) PRIMARY KEY,
    Respondent_ID varchar(50),
    Consume_frequency varchar(25),
    Consume_time varchar(50),
    Consume_reason varchar(50),
    Heard_before varchar(5),
    Brand_perception varchar(10),
    General_perception varchar(15),
    Tried_before varchar(5),
    Ratings integer,
    Reasons_preventing_trying varchar(50),
    Current_brands varchar(25),
    Reasons_for_choosing_brands varchar(25),
    Improvements_desired varchar(50),
    Ingredients_expected varchar(20),
    Health_concerns varchar(10),
    Interest_in_natural_or_organic varchar(10),
    Marketing_channels varchar(50),
    Packaging_preference varchar(50),
    Limited_edition_packaging varchar(50),
    Price_range varchar(25),
    Purchase_location varchar(50),
    Typical_consumption_situations varchar(50)
);

select * from fact_survey_responses;

create table dim_respondents (
      Respondent_ID varchar(50),
	  Name varchar(50),
	  Age varchar(50),
	  Gender varchar(50),
	  City_ID varchar(50)
);
select * from dim_respondents;

create table dim_cities (
          City_ID varchar(50),
		  City	varchar(50),
		  Tier varchar(50)
);

select * from fact_survey_responses;
select * from dim_respondents
select * from dim_cities;

--Primary Insights (Sample Sections / Questions) 

----Demographic Insights  
--a. Who prefers energy drink more?  (male/female/non-binary?) 

select gender,count(*) as total_preferences
from dim_respondents
group by gender
order by total_preferences desc;

--b. Which age group prefers energy drinks more? 

select age,count(*) as total_preferences
from dim_respondents
group by age
order by total_preferences desc;

--c. Which type of marketing channels reaches the most Youth (15-30)? 

SELECT Marketing_channels,COUNT(*) AS Total 
FROM fact_survey_responses fs
JOIN dim_respondents dr ON fs.Respondent_ID = dr.Respondent_ID
WHERE Age IN ('15-18', '19-30')
GROUP BY Marketing_channels
ORDER BY Total DESC;

----2. Consumer Preferences: 
--a. What are the preferred ingredients of energy drinks among respondents? 

select ingredients_expected, count(*) as preferred_ingredients
from fact_survey_responses
group by ingredients_expected
order by preferred_ingredients desc;

--b. What packaging preferences do respondents have for energy drinks? 

select packaging_preference, count(*) as packaging_preferences
from fact_survey_responses
group by packaging_preference
order by packaging_preferences desc;

----3. Competition Analysis: 
--a. Who are the current market leaders? 

select current_brands as market_leaders
from fact_survey_responses
group by current_brands
limit 5;

--b. What are the primary reasons consumers prefer those brands over ours?

SELECT Consume_reason,COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Consume_reason
ORDER BY Total DESC;

----4. Marketing Channels and Brand Awareness: 
--a. Which marketing channel can be used to reach more customers? 

Select marketing_channels, Count(*) as channel_effectiveness
From fact_survey_responses
Group By marketing_channels 
Order By channel_effectiveness Desc;

--b. How effective are different marketing strategies and channels in reaching our customers?

SELECT Marketing_channels,COUNT(*) AS Total, 
AVG(ratings) AS Avg_Taste_Rating
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Avg_Taste_Rating DESC;

----5. Brand Penetration: 
--a. What do people think about our brand?  

SELECT Brand_perception, COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Brand_perception
ORDER BY Total DESC;

--b. Which cities do we need to focus more on? 

SELECT                               --cities with low responses or negative perceptions
City,COUNT(*) AS Total, 
AVG(CASE WHEN Brand_perception = 'Positive' THEN 1 ELSE 0 END) AS Positive_Perception_Rate
FROM fact_survey_responses fs
JOIN dim_respondents dr ON fs.Respondent_ID = dr.Respondent_ID
JOIN dim_cities dc ON dr.City_ID = dc.City_ID
GROUP BY City
ORDER BY Positive_Perception_Rate asc, Total asc;

----6. Purchase Behavior: 
--a. Where do respondents prefer to purchase energy drinks? 

SELECT Purchase_location, 
COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Total DESC;

--b. What are the typical consumption situations for energy drinks among respondents?

SELECT Typical_consumption_situations, 
COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY Total DESC;

--c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging? 

SELECT 'Price Range' AS Factor,
    Price_range AS Value, 
    COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Price_range
UNION ALL
SELECT 'Limited Edition Packaging' AS Factor,
    Limited_edition_packaging AS Value, 
    COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY Limited_edition_packaging
ORDER BY Factor, Total DESC;


----7. Product Development 
--a. Which area of business should we focus more on our product development? (Branding/taste/availability) 

SELECT reasons_for_choosing_brands,
COUNT(*) AS Total 
FROM fact_survey_responses
GROUP BY reasons_for_choosing_brands
ORDER BY Total DESC;
