DROP TABLE IF EXISTS tianchi_ijcai_predict_weekday_model;
CREATE TABLE tianchi_ijcai_predict_weekday_model AS
SELECT floor(train.shop_id) AS shop_id, train.day_time,
	   -- 商户基本数据
	   shop.location_id,shop.shop_level,
	   -- 城市特征
	   city_info.code AS city_code,
	   -- 商店类型信息
	   category.is_restaurant,category.is_shop,category.is_entertaiment,category.is_pharmacy,category.is_convenient_shop,category.is_haircut,
	   -- 天气特征信息
	   weather.weather_t_30,weather.weather_t_20,weather.weather_t_10,weather.weather_t_0,weather.weather_t_minus,
	   weather.highest_t_normalization,weather.lowest_t_normalization,
	   weather.is_sunny,weather.is_rain,weather.is_snow,weather.is_fog,weather.is_overcast,
	   -- 半年平均数据
	   half_year.average_user AS half_year_average,
	   2*atan(half_year.average_user)/3.14 AS normalization_half_year_avg,
	   -- 季度平均数据
	   quarter_average.average_user AS quarter_average,
	   2*atan(quarter_average.average_user)/3.14 AS normalization_quarter_avg,
	   -- 同期平均数据
	   same_term.average_user AS same_term_average,
	   2*atan(same_term.average_user)/3.14 AS normalization_same_term_avg,
	   -- 上月平均数据
	   month_average.average_user AS month_average,
	   2*atan(month_average.average_user)/3.14  AS normalization_month_avg,
	   -- 验证用的User_count
	   summary.user_count AS user_count,
	   IF(last_week.standar_user_count!=0,((summary.user_count-last_week.average_count)/last_week.standar_user_count),0) AS standar_dev_count,
	   month_average.standar_user_count AS month_standar_user,
	   -- 时间相关数据
	   weekday(train.day_time) AS week_day,
	   datepart(train.day_time,'dd') AS day_of_month,
	   -- 假期特征
	   vocation.holiday,vocation.is_weekend,vocation.is_workday,vocation.is_public_holiday,
	   -- 地区统计数据
	   competition_shops.shop_count-1 AS competition_count,
	   -- 客流频率数据
	   frequenters.most_frquenters_number,frequenters.default_frquenters_number,
	   -- 客流量差值百分比
	   shop_avg_detail.ratio,
	   -- 地区统计数据
	   location_avg_detail.working_estate,location_avg_detail.housing_estate,
	   -- 客流量稳定数据
	   IF(loyalty.average_loyalty>0.85,1,0) AS customer_stable,
	   -- 上周统计数据
	   last_week.max_count AS last_week_max_user, last_week.min_count AS last_week_min_user , last_week.median_count AS last_week_median_user,
	   last_week.standar_user_count AS last_week_standar,last_week.average_count AS last_week_average
FROM tianchi_ijcai_dates_model train
JOIN tianchi_shop_info shop
ON shop.shop_id = train.shop_id 
JOIN tianchi_shop_category category
ON category.shop_id = shop.shop_id
JOIN tianchi_ijcai_weather_feature weather
ON weather.day_time = train.day_time AND weather.city = shop.city_name 
JOIN tianchi_ijcai_half_year_predict half_year
ON half_year.shop_id = shop.shop_id AND half_year.week_day = weekday(train.day_time)
JOIN tianchi_ijcai_quarter_predict quarter_average
ON quarter_average.shop_id = shop.shop_id AND quarter_average.week_day = weekday(train.day_time)
JOIN tianchi_ijcai_month_predict month_average
ON month_average.shop_id = shop.shop_id AND month_average.week_day = weekday(train.day_time)
JOIN tianchi_ijcai_same_term_predict same_term
ON same_term.shop_id = shop.shop_id AND same_term.week_day = weekday(train.day_time)
JOIN tianchi_ijcai_pay_summary_year_orgin summary
ON summary.shop_id = shop.shop_id AND summary.day_time = train.day_time
JOIN tianchi_ijcai_vocations_feature vocation
ON vocation.day_time = train.day_time
JOIN tianchi_city_code city_info
ON city_info.city_name = shop.city_name
JOIN tianchi_shop_location competition_shops
ON competition_shops.location_id = shop.location_id AND competition_shops.cate_1_name = shop.cate_1_name
JOIN tianchi_shop_frequenters frequenters
ON frequenters.shop_id = summary.shop_id 
JOIN tianchi_shop_avg_detail shop_avg_detail
ON shop_avg_detail.shop_id = summary.shop_id 
JOIN tianchi_location_avg_detail location_avg_detail
ON location_avg_detail.location_id = shop.location_id
JOIN tianchi_user_loyalty loyalty
ON loyalty.shop_id = shop.shop_id
JOIN tianchi_ijcai_last_week_predict last_week
ON last_week.shop_id = shop.shop_id;

-- 训练数据集安全校验
SELECT count(*) FROM tianchi_ijcai_predict_weekday_model GROUP BY shop_id HAVING count(*)!=31; 

DROP TABLE IF EXISTS tianchi_ijcai_predict_weekday_dataset;
CREATE TABLE tianchi_ijcai_predict_weekday_dataset AS
SELECT floor(vaild.shop_id) AS shop_id, vaild.day_time,
	   -- 商户基本数据
	   shop.location_id,shop.shop_level,
	   -- 城市特征
	   city_info.code AS city_code,
	   -- 商店类型信息
	   category.is_restaurant,category.is_shop,category.is_entertaiment,category.is_pharmacy,category.is_convenient_shop,category.is_haircut,
	   -- 天气特征信息
	   weather.weather_t_30,weather.weather_t_20,weather.weather_t_10,weather.weather_t_0,weather.weather_t_minus,
	   weather.highest_t_normalization,weather.lowest_t_normalization,
	   weather.is_sunny,weather.is_rain,weather.is_snow,weather.is_fog,weather.is_overcast,
	   -- 半年平均数据
	   half_year.average_user AS half_year_average,
	   2*atan(half_year.average_user)/3.14 AS normalization_half_year_avg,
	   -- 季度平均数据
	   quarter_average.average_user AS quarter_average,
	   2*atan(quarter_average.average_user)/3.14 AS normalization_quarter_avg,
	   -- 同期平均数据
	   same_term.average_user AS same_term_average,
	   2*atan(same_term.average_user)/3.14 AS normalization_same_term_avg,
	   -- 上月平均数据
	   month_average.average_user AS month_average,
	   2*atan(month_average.average_user)/3.14  AS normalization_month_avg,
	   -- 同期交易数据
	   time_seq.user_count AS time_seq_count,
	   -- 时间相关数据
	   weekday(vaild.day_time) AS week_day,
	   datepart(vaild.day_time,'dd') AS day_of_month,
	   -- 假期特征
	   vocation.holiday,vocation.is_weekend,vocation.is_workday,vocation.is_public_holiday,
	   -- 地区统计数据
	   competition_shops.shop_count-1 AS competition_count,
	   -- 客流频率数据
	   frequenters.most_frquenters_number,frequenters.default_frquenters_number,
	   -- 客流量差值百分比
	   shop_avg_detail.ratio,
	   -- 地区统计数据
	   location_avg_detail.working_estate,location_avg_detail.housing_estate,
	   -- 客流量稳定数据
	   IF(loyalty.average_loyalty>0.85,1,0) AS customer_stable,
	   -- 上周统计数据
	   last_week.max_count AS last_week_max_user, last_week.min_count AS last_week_min_user , last_week.median_count AS last_week_median_user,
	   last_week.standar_user_count AS last_week_standar,last_week.average_count AS last_week_average
FROM tianchi_ijcai_dates_predict vaild
LEFT OUTER JOIN tianchi_shop_info shop
ON shop.shop_id = vaild.shop_id 
LEFT OUTER JOIN tianchi_shop_category category
ON category.shop_id = shop.shop_id
LEFT OUTER JOIN tianchi_ijcai_weather_feature weather
ON weather.day_time = vaild.day_time AND weather.city = shop.city_name 
LEFT OUTER JOIN tianchi_ijcai_half_year_predict half_year
ON half_year.shop_id = shop.shop_id AND half_year.week_day = weekday(vaild.day_time)
LEFT OUTER JOIN tianchi_ijcai_quarter_predict quarter_average
ON quarter_average.shop_id = shop.shop_id AND quarter_average.week_day = weekday(vaild.day_time)
LEFT OUTER JOIN tianchi_ijcai_month_predict month_average
ON month_average.shop_id = shop.shop_id AND month_average.week_day = weekday(vaild.day_time)
LEFT OUTER JOIN tianchi_ijcai_same_term_predict same_term
ON same_term.shop_id = shop.shop_id AND same_term.week_day = weekday(vaild.day_time)
LEFT OUTER JOIN tianchi_ijcai_vocations_feature vocation
ON vocation.day_time = vaild.day_time
LEFT OUTER JOIN tianchi_ijcai_time_seq_predict time_seq
ON time_seq.shop_id = shop.shop_id AND time_seq.predict_date = vaild.day_time
JOIN tianchi_city_code city_info
ON city_info.city_name = shop.city_name
JOIN tianchi_shop_location competition_shops
ON competition_shops.location_id = shop.location_id AND competition_shops.cate_1_name = shop.cate_1_name
JOIN tianchi_shop_frequenters frequenters
ON frequenters.shop_id = vaild.shop_id 
JOIN tianchi_shop_avg_detail shop_avg_detail
ON shop_avg_detail.shop_id = vaild.shop_id 
JOIN tianchi_location_avg_detail location_avg_detail
ON location_avg_detail.location_id = shop.location_id
JOIN tianchi_user_loyalty loyalty
ON loyalty.shop_id = shop.shop_id
JOIN tianchi_ijcai_last_week_predict last_week
ON last_week.shop_id = shop.shop_id;

-- 验证数据集安全校验
SELECT count(*) FROM tianchi_ijcai_predict_weekday_dataset GROUP BY shop_id HAVING count(*)!=14; 
SELECT * FROM tianchi_ijcai_predict_weekday_dataset;