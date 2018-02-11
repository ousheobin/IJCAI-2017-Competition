
SELECT shop_id,count(*)  FROM tianchi_ijcai_predict_weekday_model group by shop_id having count(*)!=31;

SELECT shop_id,count(*)  FROM tianchi_ijcai_predict_weekday_train  group by shop_id having count(*)!=30;

SELECT DISTINCT day_time FROM tianchi_ijcai_predict_weekday_train;

SELECT res.shop_id,res.day_time,floor(round(res.prediction_result + average.average_user)) AS result
FROM tianchi_ijcai_gbdt_pai_res res
JOIN tianchi_ijcai_predict_weekday_average average
	ON average.shop_id = res.shop_id
		 AND average.week_day = weekday(res.day_time)
WHERE res.shop_id = 2 order by day_time asc limit 100;



DROP TABLE IF EXISTS tianchi_arima_train_orign;

CREATE TABLE tianchi_arima_train_orign
AS SELECT *
FROM tianchi_ijcai_pay_summary
WHERE day_time < '2016-10-15 00:00:00'