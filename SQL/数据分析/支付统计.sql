-- 创建用于平均数统计和模型训练的交易数据汇总表
DROP TABLE IF EXISTS tianchi_ijcai_pay_summary_orign;
CREATE TABLE tianchi_ijcai_pay_summary_orign AS
SELECT *
FROM (
	SELECT COUNT(*) AS user_count
		, datetrunc(time_stamp, 'DD') AS day_time
		, floor(shop_id) AS shop_id
	FROM tianchi_user_pay
	GROUP BY datetrunc(time_stamp, 'DD'), 
		shop_id
) temp_aver
WHERE temp_aver.day_time >= '2016-08-01 00:00:00';

DROP TABLE IF EXISTS tianchi_ijcai_pay_summary_t;
CREATE TABLE tianchi_ijcai_pay_summary_t AS
SELECT prepare.shop_id 
	   , prepare.day_time 
	   , orign.user_count 
FROM tianchi_ijcai_dataset_prepare prepare
LEFT OUTER JOIN tianchi_ijcai_pay_summary_orign orign
ON orign.shop_id = prepare.shop_id AND orign.day_time = prepare.day_time;

DROP TABLE IF EXISTS tianchi_ijcai_pay_summary;
CREATE TABLE tianchi_ijcai_pay_summary AS
SELECT * FROM(
	SELECT shop_id,day_time,DATEADD(day_time,1,'DD') AS predict_date,user_count,weekday(day_time) AS week_day FROM tianchi_ijcai_pay_summary_t WHERE user_count IS NOT NULL 
	UNION ALL
	SELECT shop_id,day_time,DATEADD(day_time,1,'DD') AS predict_date,1 AS user_count,weekday(day_time) AS week_day FROM tianchi_ijcai_pay_summary_t  WHERE user_count IS NULL 
)d;

-- 创建单点平均交易数据表
DROP TABLE IF EXISTS tianchi_ijcai_pay_average;
CREATE TABLE tianchi_ijcai_pay_average AS 
SELECT floor(shop_id) as shop_id,
	   AVG(user_count) AS average_count,
	   max(user_count) AS weekday_max,
	   min(user_count) AS weekday_min
FROM tianchi_ijcai_pay_summary
GROUP BY shop_id;
