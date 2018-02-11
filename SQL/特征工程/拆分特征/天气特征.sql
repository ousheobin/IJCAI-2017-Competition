DROP TABLE IF EXISTS tianchi_ijcai_weather_avg;
CREATE TABLE tianchi_ijcai_weather_avg AS
SELECT weather.city,
	   datepart(weather.day_time,'MM') AS month,
	   AVG(weather.highest_t) AS highest_t_average,
	   STDDEV(weather.highest_t) AS hightest_t_standar,
	   AVG(weather.lowest_t) AS lowest_t_average,
	   IF(STDDEV(weather.lowest_t)!=0,STDDEV(weather.lowest_t),0.01) AS lowest_t_stander
FROM tianchi_ijcai_weather_orign weather
GROUP BY datepart(weather.day_time,'MM'),weather.city; 

CREATE TABLE tianchi_ijcai_weather_feature AS 
SELECT weather.day_time,
	   weather.city,
	   IF((weather.highest_t+weather.lowest_t)/2>=30,1,0) weather_t_30,
	   IF((weather.highest_t+weather.lowest_t)/2>=20 AND (weather.highest_t+weather.lowest_t)/2<30,1,0) weather_t_20,
	   IF((weather.highest_t+weather.lowest_t)/2>=10 AND (weather.highest_t+weather.lowest_t)/2<20,1,0) weather_t_10,
	   IF((weather.highest_t+weather.lowest_t)/2>=0 AND (weather.highest_t+weather.lowest_t)/2<10,1,0) weather_t_0,
	   IF((weather.highest_t+weather.lowest_t)/2<0,1,0) weather_t_minus,
	   weather.highest_t,weather.lowest_t,
	   round((weather.highest_t-average.highest_t_average)/average.hightest_t_standar,3) AS highest_t_normalization,
	   round((weather.lowest_t-average.lowest_t_average)/average.lowest_t_stander,3) AS lowest_t_normalization,
	   wea_situation.rank AS weather_rank,
	   (CASE wea_situation.rank WHEN 10 THEN 1 ELSE 0 END) AS is_sunny,
	   wea_situation.is_rain,wea_situation.is_snow,wea_situation.is_fog,wea_situation.is_overcast
FROM tianchi_ijcai_weather_orign weather
JOIN tianchi_ijcai_weather_avg average
ON average.month = datepart(weather.day_time,'MM') AND average.city = weather.city
LEFT OUTER JOIN tianchi_ijcai_weather_situation wea_situation
	ON wea_situation.situation = weather.weather_chs;