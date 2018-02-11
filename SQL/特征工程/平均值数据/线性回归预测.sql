DROP TABLE IF EXISTS tianchi_linear_regression_res;
CREATE TABLE tianchi_linear_regression_res AS
SELECT prepare.shop_id,
	   prepare.day_time,
	   FLOOR(ABS((weekday(prepare.day_time)+1)*lr.rank)) as linear_res
FROM tianchi_ijcai_year_prepare prepare
JOIN tianchi_ijcai_linear_rank lr
ON lr.shop_id = prepare.shop_id
WHERE prepare.day_time >='2016-09-01 00:00:00';