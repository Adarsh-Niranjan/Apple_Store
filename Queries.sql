--CHECKING IMPORTED TABLES
--1A
select * from applestore;
--1B
select * from description;

--EXPLORATORY DATA ANALYSIS
--2. Lets see if the apps in appstore and description-data in description are corresponding
select COUNT(DISTINCT id) as ID from applestore;
select COUNT(DISTINCT id) as ID from description;
--The data was found to be corresponding

--3. Now we will look into any possible missing values in the important columns of both tables
select count(id) as key_missing from applestore where track_name is null or user_rating is null or prime_genre is null;
select count(id) as key_missing from description where app_desc is null;
--no null value were found in any important columns of both the tables

--4. Finding the number of apps per genre
select prime_genre, count(id) as total_songs from applestore group by prime_genre order by total_songs desc;

--5. Apps rating overview
select max(user_rating) as maximum, min(user_rating) as minimum, avg(user_rating) as average from applestore;

--EXTRACTING INSIGHTS
--6. Analyzing which one of the paid/free category of apps have more average rating
select 
case
when price>0 then 'Paid'
else 'Free'
end as category,
avg(user_rating) as average_app_rating
from applestore
group by category;

--7. Checking if there is any correlation between number of languages offered and rating
select 
case
when lang_num < 10 then 'Below 10 languages' 
when lang_num between 10 and 30 then 'Between 10 and 30'
else 'More than 30'
end as languages_offered,
avg(user_rating) as average_app_rating
from applestore
group by languages_offered;

--8. Checking genres with low rating
select prime_genre  as genre, avg(user_rating) as average_rating from applestore
group by prime_genre
order by average_rating
limit 20;

--9. Checking if there is any correlation between length of app description and its rating
select
case
when length(d.app_desc) < 300 then 'short'
when length(d.app_desc) BETWEEN 300 and 1000 then 'Normal'
else 'Long'
end as description_length,
avg(a.user_rating) as average_rating
from
description as d
join
applestore as a
on a.id=d.id
group by description_length
order by average_rating;

--10. Checking the top rated apps for each genre
select prime_genre, track_name, user_rating
from
(select prime_genre, track_name, user_rating,
		RANK() OVER(PARTITION by prime_genre order by user_rating desc, rating_count_tot desc) as rank
from applestore) as a
where rank=1;