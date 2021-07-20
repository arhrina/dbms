-- iolist
-- 상품정보 제2정규화

-- 매입매출정보에 상품정보가 어떤식으로 저장되어 있는지 확인

SELECT io_pname, DECODE(io_inout, 1, io_price)
FROM tbl_iolist
GROUP BY io_pname, DECODE(io_inout, 1, io_price); -- 매입금액으로만 확인해보는 DECODE

SELECT io_pname, DECODE(io_inout, 1, io_price)
FROM tbl_iolist
WHERE DECODE(io_inout, 1, io_price) is NOT NULL
GROUP BY io_pname, DECODE(io_inout, 1, io_price);

SELECT io_pname
FROM tbl_iolist
GROUP BY io_pname
ORDER BY io_pname;

-- 상품정보 테이블 생성

CREATE TABLE tbl_product(
p_code	VARCHAR2(6)	NOT NULL	PRIMARY KEY,
p_name	VARCHAR2(50)	NOT NULL	,
p_iprice	NUMBER		,
p_oprice	NUMBER		
);

-- 스프레드시트 삽입

SELECT * FROM tbl_product;
-- 검증. 개수 확인
SELECT COUNT(*) FROM tbl_product;
-- 검증. tbl_iolist와 tbl_product EQ JOIN
SELECT io_inout, COUNT(*) FROM tbl_iolist IO, tbl_product P
WHERE IO.io_pname = P.p_name
GROUP BY io_inout;

-- 상품정보 TABLE에 단가를 어떻게 넣을 것인가..?

-- 상품의 매입단가 확인
SELECT io_inout, IO.io_pname, IO.io_price, COUNT(*) FROM tbl_iolist IO, tbl_product P
WHERE IO.io_pname = P.p_name
AND IO.io_inout = 1
GROUP BY io_inout, io_pname, io_price;

-- 매입매출 테이블에서 매입단가를 조회했더니 같은 상품명에 단가가 다른 상품은 없는 듯 해 보인다
-- Squery를 이용해 매입매출 테이블에서 매입단가를 상품정보테이블의 매입단가 컬럼에 세팅

/*
UPDATE tbl_product P
SET p_iprice = (
SELECT DISTINCT IO.io_price FROM tbl_iolist IO
WHERE io_inout = 1 -- 데이터를 매입으로 제한
AND P.p_name = IO.io_pname
GROUP BY p_name, IO.io_pname, io_price
);
상품명이 같은데 다른 가격을 가진 상품이 있어서 동작하지 않는다(서브쿼리에 2개가 리턴 오류)
*/

UPDATE tbl_product P
SET p_iprice = (
SELECT MAX(IO.io_price) FROM tbl_iolist IO
WHERE io_inout = 1 -- 데이터를 매입으로 제한
AND P.p_name = IO.io_pname
);

UPDATE tbl_product P
SET p_oprice = (
SELECT MAX(IO.io_price) FROM tbl_iolist IO
WHERE io_inout = 2 -- 데이터를 매출로 제한
AND P.p_name = IO.io_pname
);

SELECT * FROM tbl_product;

-- 상품거래정보에서 상품정보 매입, 매출 단가를 생성했더니 NULL값이 있다. 어떤 상품은 매입만 되고 어떤 상품은 매출만 된 경우

/*
매입단가에서 매출단가를 생성
공산품인 경우 보통 매입단가에 약 18%를 더해서 매출단가를 계산하고 10%의 VAT를 붙여서 한번 더 계산한다

(매입단가 + (매입단가 * 0.18)) * 1.1

매출단가에서 매입단가 생성
매출단가에서 부가세를 제외하고 18%를 빼서 계산
(매출단가 / 1.1) * 0.82
*/

/*
UPDATE tbl_product
SET p_iprice = (p_oprice + (p_oprice * 0.18)) * 1.1
WHERE p_iprice IS NULL; -- 잘못된 값 입력
ROLLBACK; -- 61번째줄이랑 그 아래 업데이트 전으로 롤백. 다시 61, 그아래 시행
*/



UPDATE tbl_product
SET p_iprice = (p_oprice /1.1) * 0.82
WHERE p_iprice IS NULL;

UPDATE tbl_product
SET p_oprice = (p_iprice + (p_iprice * 0.18)) * 1.1
WHERE p_oprice IS NULL;

UPDATE tbl_product
SET p_iprice = ROUND(p_iprice, 0), p_oprice = ROUND(p_oprice, 0); -- 0단위 이하 커트

SELECT * FROM tbl_product;

-- 1단위 자르기, 매입매출 테이블과 연결하기