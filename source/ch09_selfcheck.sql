-- 셀프체크
-- 8장에서 만든 market DB를 토대로 다음 1~4를 수행하는 쿼리를 작성하세요.
-- (ch08_09_market_db.png 참고)

USE market;

-- 1. 다음은 모든 사용자 수를 세는 쿼리입니다. 
-- 이를 SELECT 절의 서브쿼리로 활용해 전체 사용자의 1인당 평균 결제 금액을 조회하세요.
SELECT COUNT(*)
FROM users;

-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답: 
SELECT SUM(amount) / (SELECT COUNT(*) FROM users) AS '1인당 평균 결제 금액'
FROM orders o
JOIN payments p ON o.id = p.order_id
WHERE o.status = '배송 완료';


-- 2. 다음은 사용자 아이디별로 총 결제 금액을 집계하는 쿼리입니다.
-- 이를 FROM 절의 서브쿼리로 활용해 전체 사용자의 1인당 평균 결제 금액을 조회하세요.
SELECT u.id AS user_id, SUM(amount) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN payments p ON o.id = p.order_id
GROUP BY u.id;

-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답:
SELECT AVG(total_amount) AS '1인당 평균 결제 금액'
FROM (
	SELECT u.id AS user_id, SUM(amount) AS total_amount
	FROM users u
	JOIN orders o ON u.id = o.user_id
	JOIN payments p ON o.id = p.order_id
	GROUP BY u.id
) AS sub; 


-- 3. 앞의 두 문제(1과 2)의 정답 쿼리를 실행하면 다음과 같이 동일한 결과가 나옵니다. 그 이유를 설명하세요.
-- ------------------
-- 1인당 평균 결제 금액
-- ------------------
-- 41790.0000

-- 정답: 서브쿼리를 활용하여 평균 금액과 합계를 집계하기 때문 


-- 4. 다음은 최근에 배송받은 사용자의 아이디를 찾는 쿼리입니다.
-- 이를 WHERE 절의 서브쿼리로 활용해 해당 사용자의 총 결제 금액을 조회하세요.
SELECT user_id
FROM orders
WHERE status = '배송 완료'
ORDER BY created_at DESC
LIMIT 1;

-- 정답:
SELECT SUM(amount)
FROM payments p
JOIN orders o ON o.id = p.order_id  
WHERE o.user_id = (
	SELECT user_id
	FROM orders
	WHERE status = '배송 완료'
	ORDER BY created_at DESC
	LIMIT 1 
);

