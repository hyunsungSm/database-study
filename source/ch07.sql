/*
	7. 테이블 조인하기
	7.1 조인이란
*/
-- 조인이 필요한 이유?
-- 예: "최근 주문 내역을 고객 이름과 상품명을 포함해서 보여줘"라고 요청이 왔을 때
-- customers, orders, products  테이블에서 주문 내역이 필요하기 때문에 orders의 정보가 필요
-- 그런데 orders 테이블에는 고객 이름과 상품명이 없다.
-- 이 테이블만 보고서는 customer_id가 1인 고객이 누구인지, product_id가 4인 상품이 무엇인지 즉시 알 수 없음
-- 결국 추가적으로
-- 고객 이름을 구하기 위해서는 customers 테이블을 통해 customer_id에 해당하는 고객명을 하나하나 직접 찾고
-- 상품명을 구하기 위해서는 products 테이블을 통해 product_id에 해당하는 상품명을 하나하나 직접 찾아야 함

-- 그렇다면 왜 이렇게 불편하게 데이터를 여러 테이블에 나누어 저장하는 걸까?
-- 차라리 처음부터 모든 데이터를 하나의 테이블(예: orders)에 저장한다면?
-- 데이터를 조회할 때는 편해 보이지만 이런 방식은 심각한 문제들이 발생함
-- 1) 데이터 중복
-- '재현' 고객이 상품을 100번 주문했다고 가정해 보자
-- 고객의 이름, 이메일, 주소 정보가 100번이나 불필요하게 반복 저장됨 => 저장 공간의 낭비
-- 2) 갱신 이상
-- 만약 '재현' 고객이 이메일 주소를 변경했다고 가정해 보자
-- 우리는 '재현'이 주문한 100개의 주문 데이터를 모두 찾아서, 이메일 정보를 일일이 새로운 주소로 변경해야 함 
-- 만약 실수로 단 하나라도 누락한다면? 
-- 어떤 주문에서는 고객의 이메일이 예전 주소로, 다른 주문에서는 새 주소로 저장되어 데이터의 일관성이 깨져버림
-- 어떤 정보가 맞는 건지 알 수 없게 됨


-- 조인이란?
-- 두 개 이상의 테이블로 나뉜 여러 정보를 하나로 연결하여 가져오는 명령
-- 테이블 간에 일치하는 컬럼을 기준으로 두 테이블을 하나로 합쳐 보여줌
-- 마치 처음부터 하나의 테이블이었던 것처럼 보여주는 기능

-- 조인 컬럼(기준이 되는 컬럼): 
-- 두 테이블이 동시에 가지고 있는 컬럼으로 조인하기 위해 사용하는 컬럼
-- 보통 한 테이블의 외래키(FK)와 다른 테이블의 기본키(PK)를 사용

-- (참고) 외래키를 사용하지 않아도 JOIN은 얼마든지 할 수 있음
-- 기본키(PK)와 외래키(FK)를 써서 테이블을 연결하는 것이 가장 일반적이고 기본이 되는 방식
-- 그러나 조인의 핵심 원리는 '두 테이블의 특정 열(column)의 값이 같으면' 연결
-- 즉, 어떤 컬럼이든 데이터 타입만 같다면 조인 조건으로 쓸 수 있음
-- 예: 동명이인 찾기(이름으로 조인)
-- 고객 테이블과 직원 테이블에 모두 name 컬럼이 있다면, 
-- 이 두 테이블을 name으로 조인하여 고객과 직원의 이름이 같은 경우를 찾아낼 수 있다.

-- 조인 하기
-- 특정 사진에 달린 모든 댓글의 작성자 닉네임과 댓글 본문을 조회하는 법? 

-- stargram DB 진입 
CREATE DATABASE stargram;
USE stargram; 

-- 1번 사진 댓글 정보 조회 
SELECT *
FROM comments 
WHERE photo_id = 1; 

-- 테이블 조인 형식 
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A -- 기준이 되는 첫번째 테이블 지정 
-- JOIN 테이블B -- 연결할 두번째 테이블 지정(JOIN만 명시하면 기본적으로 INNER JOIN으로 해석) 
-- ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼; -- (중요) 두 테이블을 어떤 조건으로 연결할지 명시하는 연결고리 
-- -- ON 절의 조건이 참(true)이 되는 행들만 결과에 포함

-- 댓글 본문과 사용자 닉네임을 합쳐서 가져오기 
-- comments 테이블과 users 테이블 조인
SELECT * 
FROM comments 
JOIN users ON comments.user_id = users.id;  
-- JOIN users: 사용자 테이블을 붙일건데 
-- ON: 댓글 테이블의 외래키 = 사용자 테이블의 기본키가 같은 것끼리

-- 결과에서 볼 수 있듯이 조인은 쉽게 이야기해서 테이블을 옆으로 붙이는 것!!  

-- Quiz: 1번 사진에 달린 모든 댓글 본문과 작성자 닉네임 가져오기 
SELECT nickname, body
FROM comments 
JOIN users ON comments.user_id = users.id
WHERE photo_id = '1';

-- 조인 특징 7가지 
-- 1) 조인 컬럼이 필요 
-- 두 테이블을 연결하기 위한 공통 컬럼이 필요 
-- 보통 외래키와 기본키를 기준으로 조인 
SELECT * 
FROM comments 
JOIN users ON comments.user_id = users.id; -- 조인 컬럼(외래키) = 조인 컬럼(기본키) 

-- 2) 조인 컬럼은 서로 자료형이 일치 
-- 일치해야 조인 가능 
-- 예: 숫자 1과 문자열 '1'은 서로 조인 불가 
-- 다만 DBMS마다 자동 형 변환이 될 수도 있음 
-- 실무에서는 성능/안전성 때문에 자료형 일치가 원칙 

-- 3) 조인 조건이 필요 
-- ON 절과 함께 사용 
-- 두 테이블을 어떻게 연결할지를 조인 조건으로 명시 

-- 4) 연속적인 조인 가능 
SELECT nickname, body, filename -- 4) 원하는 컬럼 조회 
FROM comments -- 1) 댓글 테이블에 
JOIN users ON comments.user_id = users.id -- 2) 사용자 테이블 조인하고
JOIN photos ON comments.photo_id = photos.id; -- 3) 다시 사진 테이블 조인 후  

-- 5) 중복 컬럼은 테이블명을 붙여 구분 
-- 컬럼명이 같은 경우 어느 테이블의 것인지 명시해야 됨(그렇지 않은 경우 에러 발생)
-- 사용 예: 중복 컬럼 id에 테이블명 명시 
SELECT comments.id, body, users.id, nickname
FROM comments
JOIN users ON comments.user_id = users.id
WHERE photo_id = 2;
-- Error Code: 1052. Column 'id' in field list is ambiguous
-- 실무에서는 어떤 테이블의 컬럼인지 명시하는 것이 가독성을 높이고, 쉽게 인지할 수 있기 때문에 사용하는 것을 권장 
-- 다음에 나오는 테이블 별칭과 함께 사용하는 것이 좋음 

-- 6) 테이블명에 별칭 사용 가능 
-- 간결한 쿼리 작성 및 가독성 향상에 도움 
-- SELECT 
-- 	c.body, 
--     u.nickname
-- FROM comments AS c
-- JOIN users AS u ON c.user_id = u.id
-- 실무에서 테이블에 별칭을 붙일 때는 AS를 보통 생략 
-- (참고) SELECT 절에서 컬럼에 붙이는 별칭은 AS를 생략 안함

-- 7) 다양한 조인 유형 사용 가능 
-- 조인은 크게 내부 조인(INNER JOIN)과 외부 조인(OUTER JOIN)으로 나뉨 
-- 다양한 결과 테이블 생성에 도움 
-- INNER 조인
-- LEFT 조인
-- RIGHT 조인
-- FULL 조인

-- Quiz
-- 1. 다음은 comments 테이블과 photos 테이블을 조인하는 쿼리이다. 
-- 빈칸을 순서대로 채워 쿼리를 완성하시오. (예: aaa, bbb, ccc)

-- SELECT body, filename
-- FROM comments ① __________
-- ② __________ photos AS p ③ __________ c.photo_id = p.id;

-- 정답: AS c, JOIN, ON

-- 2. 다음 조인에 대한 설명으로 옳지 않은 것은?
-- ① 조인 칼럼은 자료형이 달라도 된다. 
-- ② 조인 조건은 JOIN 절의 ON 키워드 다음에 작성한다.
-- ③ 중복 칼럼은 '테이블명.칼럼명'과 같이 테이블명을 붙여 구분한다.
-- ④ 조인 테이블에 별칭을 붙일 때는 AS 키워드를 사용한다.

-- 정답: 1


/*
	7.2 조인의 유형
*/
-- 1. 내부 조인(INNER JOIN)
-- 가장 기본이 되는 조인
-- 두 테이블에서 조인 조건을 만족하는(조인 컬럼이 같은) 데이터를 찾아 조인함
-- => 양쪽 테이블에 모두 공통으로 존재하는 데이터만을 결과로 보여줌(교집합에 해당)
-- 실무에서는 대부분 INNER 키워드 생략

-- 형식: 
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A 
-- INNER JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼

-- Quiz: photos 테이블과 users 테이블 INNER 조인
SELECT *
FROM photos 
JOIN users ON photos.user_id = users.id;

-- 2. 외부 조인(OUTER JOIN)
-- 두 테이블 간의 조인 결과에 누락된 행을 포함시킬 수 있는 조인 방식
-- 예: 쇼핑몰에 가입은 했지만, 아직 한 번도 주문하지 않은 고객의 정보는?
-- 또는 아직 단 한 번도 팔리지 않은 상품의 정보는?

-- 외부 조인의 필요성
-- 내부 조인(INNER JOIN)만으로는 주문 기록이 없는 고객을 찾을 수 없음
-- 이런 경우에는 외부 조인(OUTER JOIN)을 사용하면 한쪽 테이블에만 존재하는 데이터도 결과에 포함시킬 수 있음
-- 이처럼 한쪽에는 데이터가 있지만, 다른 한쪽에는 없는 데이터까지 모두 포함해서 보고 싶을 때 사용하는 것이 외부 조인
-- 종류는 크게 3가지가 존재

-- 2-1. LEFT 조인
-- 왼쪽 테이블(FROM 절 테이블)의 모든 데이터에 오른쪽 테이블(JOIN 절 테이블)을 조인함
-- 왼쪽 테이블은 모든 데이터를 가져오지만, 오른쪽 테이블은 조인 조건을 만족하는 것만 가져옴
-- 조인 조건을 만족하지 않는 경우, NULL 값으로 채움

-- 형식: 
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A 
-- LEFT JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼

-- photos 테이블과 users 테이블 LEFT 조인 
SELECT * 
FROM photos p
LEFT JOIN users u ON p.user_id = u.id;

-- 2-2. RIGHT 조인
-- 오른쪽 테이블(JOIN 절 테이블)의 모든 데이터에 왼쪽 테이블(FROM 절 테이블)을 조인함
-- 오른쪽 테이블은 모든 데이터를 가져오지만, 왼쪽 테이블은 조인 조건을 만족하는 것만 가져옴
-- 조인 조건을 만족하지 않는 경우, NULL 값으로 채움
-- LEFT 조인에서 기준만 바뀌고 동일하기에 거의 사용되지 않음

-- 형식: 
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A 
-- RIGHT JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼

-- photos 테이블과 users 테이블 LEFT 조인 
SELECT * 
FROM photos p
RIGHT JOIN users u ON p.user_id = u.id;


-- 2-3. FULL 조인
-- 두 테이블의 모든 데이터를 결합하는 조인
-- 조인 불가능한 것은 NULL 값으로 채움
-- LEFT 조인 + RIGHT 조인의 결과에 중복을 제거한 것(합집합)
-- 두 테이블에 조인 컬럼 값이 같은 데이터뿐만 아니라, 한쪽 테이블에 존재하는 데이터도 모두 반환

-- 실무에서는 잘 사용하지 않고, MySQL은 FULL 조인을 지원하지 않음 

-- 형식: 
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A 
-- FULL JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼

-- 3. UNION 연산자
-- 두 쿼리의 결과를 하나의 테이블로 합치는 집합 연산자 
-- SELECT 결과를 단순히 위아래로 붙이는 연산 
-- UNION을 사용하려면 반드시 지켜야 할 규칙 
-- 1) UNION으로 연결되는 모든 SELECT 문은 "컬럼 개수가 동일" 해야 하고, 
-- 2) "각 컬럼의 자료형이 서로 호환 가능한 타입" 이어야 함(예: 숫자는 숫자 타입끼리, 문자는 문자 타입끼리)

-- 사용 예: 
-- 대학교의 학생 정보를 재학생과 졸업생으로 별도의 테이블로 나눠서 보관한다고 가정했을 때,
-- 새해를 맞아 모든 학생(재학중 + 졸업)에게 신년인사 이메일을 보내기 위해, 
-- 두 테이블에 흩어져 있는 이름과 이메일을 합쳐서 하나의 전체 목록을 만들어야 한다면
-- JOIN 으로는 해결 불가 => 이유? 두 테이블은 서로 연결된 관계가 아니라, 구조는 비슷하지만 분리된 별개의 집합이기 때문
SELECT name, email FROM students -- 재학생
UNION
SELECT name, email FROM graduates; -- 졸업생

-- (참고) UNION 연산을 활용하면 FULL 조인 결과를 생성 가능 
-- photos 테이블과 users 테이블 FULL 조인 = LEFT 조인 + RIGHT 조인 + 중복 제거 => UNION
(
	SELECT * 
	FROM photos p
	RIGHT JOIN users u ON p.user_id = u.id
)
UNION -- 두 쿼리의 결과 테이블을 위 아래로 합치고 중복 데이터는 제거 
(
	SELECT * 
	FROM photos p
	RIGHT JOIN users u ON p.user_id = u.id
);

-- 4. UNION ALL 연산자
-- UNION과 UNION ALL의 차이 
-- 유일한 차이점은 "중복 처리" 여부 
-- UNION: 두 결과 집합을 합친 후, 중복된 행을 제거
-- UNION ALL: 중복 제거 과정 없이, 두 결과 집합을 그대로 모두 합침 

-- UNION과 UNION ALL 중 무엇을 쓸지는 정답이 없고 비즈니스 요구사항에 따라 다름
-- 사용 예: '전자기기' 카테고리 상품을 한 번이라도 구매한 고객과 
-- '도서' 카테고리 상품을 한 번이라도 구매한 고객을 대상으로 할인 쿠폰을 발송하려고 한다.
-- 두 카테고리 모두 구매한 고객에게는 쿠폰을 중복 발송하려고 한다면 UNION ALL을 사용

(
	SELECT * 
	FROM photos p
	RIGHT JOIN users u ON p.user_id = u.id
)
UNION ALL -- 단순히 두 쿼리의 결과 테이블을 위아래로 붙임 
(
	SELECT * 
	FROM photos p
	RIGHT JOIN users u ON p.user_id = u.id
);

-- (참고) UNION과 UNION ALL의 성능 비교
-- UNION ALL이 UNION 보다 훨씬 빠르다.
-- UNION: 두 결과를 합친 뒤, 중복을 제거하기 위해 데이터베이스는 추가 작업을 수행
-- 보통 전체 결과를 정렬한 다음, 서로 인접한 행들을 비교하여 중복을 찾아내는 과정을 거침
-- 데이터의 양이 수십만, 수백만 건이라면 이 정렬과 비교 작업은 많은 비용과 시간을 소모
-- UNION ALL: 이런 추가 작업이 전혀 없음
-- 그냥 첫 번째 SELECT 결과 아래에 두 번째 SELECT 결과를 가져다 붙이기만 하면 끝

-- 그럼 실무에서는
-- 1. 중복을 제거해야만 하는 명확한 요구사항이 있을 때만 UNION을 사용
-- (예: 고유한 이메일 주소 목록, 고유한 고객 ID 목록 등)
-- 2. 그 외의 모든 경우에는 UNION ALL을 우선적으로 사용
-- 두 결과 집합에 중복이 발생할 수 없다는 것을 명확히 아는 경우
-- 또는 중복이 발생해도 상관없는 경우
-- 즉, 중복을 제거할 필요가 없다면, 항상 UNION ALL을 사용

-- Quiz
-- 3. 다음 빈칸에 들어갈 용어를 차례대로 쓰시오. (예: ㄱㄴㄷㄹㅁ)
-- ① __________: 가장 기본적인 조인 유형으로, 두 테이블에서 조인 조건을 만족하는 튜플을 찾아 조인
-- ② __________: 왼쪽 테이블의 모든 튜플에 대해 조인 조건을 만족하는 오른쪽 테이블의 튜플을 조인하고, 조인할 수 없는 경우 NULL 값으로 채움
-- ③ __________: 오른쪽 테이블의 모든 튜플에 대해 조인 조건을 만족하는 왼쪽 테이블의 튜플을 조인하고, 조인할 수 없는 경우 NULL 값으로 채움
-- ④ __________: 두 테이블 사이에서 조인이 가능한 튜플뿐만 아니라 조인 불가능한 튜플도 모두 가져오고 빈 칼럼은 NULL 값으로 채움
-- ⑤ __________: 두 쿼리의 결과 테이블을 하나로 합침

-- (ㄱ) FULL JOIN
-- (ㄴ) INNER JOIN
-- (ㄷ) UNION
-- (ㄹ) RIGHT JOIN
-- (ㅁ) LEFT JOIN

-- 정답: ㄴ, ㅁ, ㄹ, ㄱ, ㄷ

/*
	7.3 조인 실습: 별그램 DB
*/
-- 가장 많이 사용되는 INNER 조인과 LEFT 조인을 연습!

-- 1. 특정 사용자가 올린 사진 목록 출력하기
-- 예: 홍팍이 업로드한 모든 사진의 파일명은? 
-- SELECT nickname, filename
-- FROM users
-- JOIN photos ON photos.user_id = users.id
-- WHERE nickname = '홍팍'; 

-- (참고) 또는 필터링을 조인과 동시에 가능 
-- SELECT nickname, filename
-- FROM users
-- JOIN photos ON photos.user_id = users.id
-- AND nickname = '홍팍'; 

-- 2. 특정 사용자가 올린 사진의 좋아요 개수 
-- 예: 홍팍이 올린 모든 사진의 좋아요 개수는? 
SELECT COUNT(*)
FROM users u 
JOIN photos p ON u.id = p.user_id
JOIN likes l ON p.id = l.photo_id
WHERE nickname = '홍팍';

-- 3. 특정 사용자가 쓴 댓글 개수 
-- 예: 해삼이가 작성한 모든 댓글의 개수는? 
SELECT COUNT(*)
FROM comments c
JOIN users u ON c.user_id = u.id
WHERE nickname = '해삼'; 

-- 4. 모든 댓글 본문과 해당 댓글이 달린 사진의 파일명 
SELECT body, filename
FROM comments c
LEFT JOIN photos p ON c.photo_id = p.id;

-- Quiz
-- 4. 다음 설명이 맞으면 O, 틀리면 X를 순서대로 표시하시오. (예: O, X, O, X)
-- ① INNER 조인은 INNER 키워드를 생략할 수 있다. (  )
-- ② INNER 조인은 조인이 불가능한 레코드도 가져와 연결한다. (  )
-- ③ LEFT 조인은 왼쪽 테이블의 모든 데이터에 대해 오른쪽 테이블에 조인 조건을 만족하는 데이터를 가져와 연결하고 
--   오른쪽 테이블에 해당하는 데이터가 없으면 NULL 값으로 채운다. (  )
-- ④ 조인 조건에 AND 연산자를 사용하면 조인과 동시에 데이터 필터링을 할 수 있다. (  )

-- 정답: o, x, o, o



















