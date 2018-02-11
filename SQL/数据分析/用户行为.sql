DROP TABLE IF EXISTS tianchi_customer_data;
CREATE TABLE tianchi_customer_data AS
SELECT pay.user_id,pay.shop_id,COUNT(*) as cust_count from tianchi_user_pay pay
group by pay.user_id,pay.shop_id;

CREATE TABLE tianchi_customer_frequenter AS 
SELECT customer_data.user_id ,customer_data.shop_id,customer_data.cust_count / customer_sum.cust_sum AS frequency
FROM tianchi_customer_data customer_data JOIN(
	SELECT user_id,SUM(cust_count) AS cust_sum
	FROM tianchi_customer_data
	GROUP BY user_id
) customer_sum
on customer_sum.user_id = customer_data.user_id WHERE customer_data.cust_count >1;

-- 忠实拥趸
CREATE TABLE tianchi_shop_frequenters
AS
SELECT default_fr.shop_id
	, most_fr.most_frquenters_number
	, default_fr.default_frquenters_number
FROM (
	SELECT shop_id
		, COUNT(*) AS default_frquenters_number
	FROM tianchi_customer_frequenter
	WHERE frequency != 1
	GROUP BY shop_id
) default_fr
JOIN (
	SELECT shop_id
		, COUNT(*) AS most_frquenters_number
	FROM tianchi_customer_frequenter
	WHERE frequency = 1
	GROUP BY shop_id
) most_fr
ON most_fr.shop_id = default_fr.shop_id;

select * from  tianchi_shop_frequenters order by floor(shop_id) asc limit 2000;

DROP TABLE IF EXISTS temp_shop_1