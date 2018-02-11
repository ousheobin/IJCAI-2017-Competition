DROP TABLE IF EXISTS tianchi_shop_category;
CREATE TABLE tianchi_shop_category AS
SELECT shop.shop_id,
	   (CASE shop.cate_1_name WHEN '美食' THEN 1
	   		ELSE 0 END) AS is_restaurant,
	   (CASE shop.cate_1_name WHEN '购物' THEN 1
	   		ELSE 0 END) AS is_shop,
	   (CASE shop.cate_1_name WHEN '休闲娱乐' THEN 1
	   		ELSE 0 END) AS is_entertaiment,
	   (CASE shop.cate_1_name WHEN '医疗健康' THEN 1
	   		ELSE 0 END) AS is_pharmacy,
	   (CASE shop.cate_1_name WHEN '超市便利店' THEN 1
	   		ELSE 0 END) AS is_convenient_shop,
	   (CASE shop.cate_1_name WHEN '美发/美容/美甲' THEN 1
	   		ELSE 0 END) AS is_haircut
FROM tianchi_shop_info shop;