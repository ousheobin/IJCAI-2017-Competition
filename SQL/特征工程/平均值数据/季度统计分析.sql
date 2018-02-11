-- 训练集使用的半年期平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_half_year_vaild;
CREATE TABLE tianchi_ijcai_half_year_vaild AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2016-10-15 00:00:00'
	  AND year_summary.day_time >= '2016-04-15 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 预测集使用的半年期平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_half_year_predict;
CREATE TABLE tianchi_ijcai_half_year_predict AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2016-11-01 00:00:00'
	  AND year_summary.day_time >= '2016-05-01 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 训练集使用的短期季度平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_quarter_vaild;
CREATE TABLE tianchi_ijcai_quarter_vaild AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2016-10-15 00:00:00'
	  AND year_summary.day_time >= '2016-07-15 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 预测集使用的短期季度平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_quarter_predict;
CREATE TABLE tianchi_ijcai_quarter_predict AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2016-11-01 00:00:00'
	  AND year_summary.day_time >= '2016-08-01 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 训练集使用的同期平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_same_term_vaild;
CREATE TABLE tianchi_ijcai_same_term_vaild AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2015-11-01 00:00:00'
	  AND year_summary.day_time >= '2015-10-15 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 预测集使用的同期平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_same_term_predict;
CREATE TABLE tianchi_ijcai_same_term_predict AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2015-11-15 00:00:00'
	  AND year_summary.day_time >= '2015-11-01 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 训练集使用的上月平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_month_vaild;
CREATE TABLE tianchi_ijcai_month_vaild AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2015-10-15 00:00:00'
	  AND year_summary.day_time >= '2015-09-15 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 预测集使用的上月平均统计数据
DROP TABLE IF EXISTS tianchi_ijcai_month_predict;
CREATE TABLE tianchi_ijcai_month_predict AS
SELECT year_summary.shop_id,
	   floor(round(avg(year_summary.user_count))) AS average_user,
	   floor(round(stddev(year_summary.user_count))) AS standar_user_count,
	   weekday(year_summary.day_time) AS week_day
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE year_summary.day_time <'2015-11-01 00:00:00'
	  AND year_summary.day_time >= '2015-10-01 00:00:00'
GROUP BY year_summary.shop_id,weekday(year_summary.day_time);

-- 训练集训练的平移数据
DROP TABLE IF EXISTS tianchi_ijcai_time_seq_vaild;
CREATE TABLE tianchi_ijcai_time_seq_vaild AS
SELECT year_summary.shop_id,
	   year_summary.day_time,
	   dateadd(year_summary.day_time,14,'dd') AS predict_date,
	   year_summary.user_count 
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE dateadd(year_summary.day_time,14,'dd') <'2016-11-01 00:00:00'
	  AND dateadd(year_summary.day_time,14,'dd') >= '2016-10-15 00:00:00';
	
-- 预测集训练的平移数据
DROP TABLE IF EXISTS tianchi_ijcai_time_seq_predict;
CREATE TABLE tianchi_ijcai_time_seq_predict AS
SELECT year_summary.shop_id,
	   year_summary.day_time,
	   dateadd(year_summary.day_time,14,'dd') AS predict_date,
	   year_summary.user_count 
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE dateadd(year_summary.day_time,14,'dd') <'2016-11-15 00:00:00'
	  AND dateadd(year_summary.day_time,14,'dd') >= '2016-11-01 00:00:00';
	  
-- 训练集最后一周的统计数据表
CREATE TABLE tianchi_ijcai_last_week_vaild AS
SELECT year_summary.shop_id,
	   FLOOR(ROUND(AVG(year_summary.user_count))) AS average_count,
	   FLOOR(ROUND(MAX(year_summary.user_count))) AS max_count,
	   FLOOR(ROUND(MIN(year_summary.user_count))) AS min_count,
	   FLOOR(ROUND(MEDIAN(year_summary.user_count))) AS median_count,
	   FLOOR(ROUND(STDDEV(year_summary.user_count))) AS standar_user_count
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE dateadd(year_summary.day_time,14,'dd') <'2016-11-01 00:00:00'
	  AND dateadd(year_summary.day_time,14,'dd') >= '2016-10-15 00:00:00'
GROUP BY year_summary.shop_id;

-- 预测集最后一周的统计数据表
CREATE TABLE tianchi_ijcai_last_week_predict AS
SELECT year_summary.shop_id,
	   FLOOR(ROUND(AVG(year_summary.user_count))) AS average_count,
	   FLOOR(ROUND(MAX(year_summary.user_count))) AS max_count,
	   FLOOR(ROUND(MIN(year_summary.user_count))) AS min_count,
	   FLOOR(ROUND(MEDIAN(year_summary.user_count))) AS median_count,
	   FLOOR(ROUND(STDDEV(year_summary.user_count))) AS standar_user_count
FROM tianchi_ijcai_pay_summary_year_orgin year_summary
WHERE dateadd(year_summary.day_time,14,'dd') <'2016-11-15 00:00:00'
	  AND dateadd(year_summary.day_time,14,'dd') >= '2016-11-01 00:00:00'
GROUP BY year_summary.shop_id;

-- 各家店铺假期销售平均情况
CREATE TABLE tianchi_shop_holiday_count AS
SELECT shop_id,
	   ROUND(AVG(user_count)) AS average_count
FROM tianchi_ijcai_pay_summary_year_orgin summary
JOIN tianchi_ijcai_vocations vocations
ON vocations.day_time = summary.day_time
WHERE summary.day_time >'2016-09-01 00:00:00'
AND vocations.holiday>0
GROUP BY shop_id;

-- 各家店铺工作日销售平均情况
CREATE TABLE tianchi_shop_workday_count AS
SELECT shop_id,
	   ROUND(AVG(user_count)) AS average_count
FROM tianchi_ijcai_pay_summary_year_orgin summary
JOIN tianchi_ijcai_vocations vocations
ON vocations.day_time = summary.day_time
WHERE summary.day_time >'2016-09-01 00:00:00'
AND vocations.holiday=0
GROUP BY shop_id;

-- 统计出各家商店的平均数据
DROP TABLE IF EXISTS tianchi_shop_avg_detail;
CREATE TABLE tianchi_shop_avg_detail AS
SELECT workday.shop_id,
	   workday.average_count AS workday_avg,
	   holiday.average_count AS holiday_avg,
	   (holiday.average_count/workday.average_count)-1 AS ratio,
	   IF(workday.average_count<holiday.average_count,1,0) AS popular_holiday,
	   IF(workday.average_count>holiday.average_count,1,0) AS popular_workday
FROM tianchi_shop_workday_count workday
JOIN tianchi_shop_holiday_count holiday
ON holiday.shop_id = workday.shop_id;

DROP TABLE IF EXISTS tianchi_shop_workday_count;
DROP TABLE IF EXISTS tianchi_shop_holiday_count;

-- 按区域统计假期数据
CREATE TABLE tianchi_location_holiday_count AS
SELECT shop.location_id,
	   ROUND(AVG(user_count)) AS average_count
FROM tianchi_ijcai_pay_summary_year_orgin summary
JOIN tianchi_ijcai_vocations vocations
ON vocations.day_time = summary.day_time
JOIN tianchi_shop_info shop
ON shop.shop_id = summary.shop_id
WHERE summary.day_time >'2016-09-01 00:00:00'
AND vocations.holiday>0
GROUP BY shop.location_id;

-- 按区域统计工作日销售平均情况
CREATE TABLE tianchi_location_workday_count AS
SELECT shop.location_id,
	   ROUND(AVG(user_count)) AS average_count
FROM tianchi_ijcai_pay_summary_year_orgin summary
JOIN tianchi_ijcai_vocations vocations
ON vocations.day_time = summary.day_time
JOIN tianchi_shop_info shop
ON shop.shop_id = summary.shop_id
WHERE summary.day_time >'2016-09-01 00:00:00'
AND vocations.holiday=0
GROUP BY shop.location_id;

-- 统计出各个区域的平均数据
CREATE TABLE  tianchi_location_avg_detail AS 
SELECT floor(workday.location_id) AS location_id,
	   workday.average_count AS workday_avg,
	   holiday.average_count AS holiday_avg,
	   (holiday.average_count/workday.average_count)-1 AS ratio,
	   IF(workday.average_count<holiday.average_count,1,0) AS working_estate,
	   IF(workday.average_count>holiday.average_count,1,0) AS housing_estate 
FROM tianchi_location_workday_count workday
JOIN tianchi_location_holiday_count holiday
ON workday.location_id = holiday.location_id;