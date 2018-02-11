CREATE TABLE tianchi_ijcai_vocations_feature AS
SELECT vocation.day_time,
	   floor(vocation.holiday) AS holiday,
	   (CASE vocation.holiday WHEN  1 THEN 1 ELSE 0 END) AS is_weekend,
	   -- 工作日数据
	   (CASE vocation.holiday WHEN  0 THEN 1 ELSE 0 END) AS is_workday,
	   -- 公众假期数据
	   (CASE vocation.holiday WHEN  2 THEN 1 ELSE 0 END) AS is_public_holiday,
	   -- 是否放假
	   IF(vocation.holiday>0,1,0) AS not_Work
FROM (
	SELECT vocation.day_time,2 AS holiday FROM tianchi_ijcai_vocations vocation
	WHERE vocation.day_time <='2016-10-07 00:00:00'
		  AND vocation.day_time >='2016-10-01 00:00:00'
	UNION ALL SELECT vocation.day_time,2 AS holiday FROM tianchi_ijcai_vocations vocation
	WHERE vocation.day_time <='2015-10-07 00:00:00'
		  AND vocation.day_time >='2015-10-01 00:00:00'
	UNION ALL SELECT * FROM tianchi_ijcai_vocations vocation
	WHERE vocation.day_time >'2015-10-07 00:00:00'
		  AND vocation.day_time <'2016-10-01 00:00:00'
	UNION ALL SELECT * FROM tianchi_ijcai_vocations vocation
	WHERE vocation.day_time >'2016-10-07 00:00:00'
		  AND vocation.day_time <'2016-12-31 00:00:00'
	UNION ALL SELECT * FROM tianchi_ijcai_vocations vocation
	WHERE vocation.day_time <'2015-10-01 00:00:00'
)  vocation;