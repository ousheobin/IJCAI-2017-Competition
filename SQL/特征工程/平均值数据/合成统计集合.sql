DROP TABLE IF EXISTS tianchi_ijcai_pay_summary_year_orgin;
CREATE TABLE tianchi_ijcai_pay_summary_year_orgin AS
SELECT prepare.day_time,
	   prepare.shop_id,
	   IF(temp_aver.user_count IS NULL,0,temp_aver.user_count) AS user_count
FROM tianchi_ijcai_year_prepare prepare
LEFT OUTER JOIN (
	SELECT COUNT(*) AS user_count
		, datetrunc(time_stamp, 'DD') AS day_time
		, floor(shop_id) AS shop_id
	FROM tianchi_user_pay
	GROUP BY datetrunc(time_stamp, 'DD'), 
		shop_id
) temp_aver
ON prepare.day_time = temp_aver.day_time AND prepare.shop_id = temp_aver.shop_id
WHERE prepare.day_time<'2016-11-01 00:00:00';