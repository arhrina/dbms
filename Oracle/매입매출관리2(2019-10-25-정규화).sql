-- iolist2
-- 데이터 임포트하고 데이터 확인
SELECT COUNT(*) FROM tbl_iolist;

-- 구분컬럼을 그룹으로 묶어서 그룹 내의 개수가 몇개씩인지 확인
SELECT io_input, COUNT(*) FROM tbl_iolist
GROUP BY io_input;

-- 제1정규화가 완료된 데이터
-- 제1정규화 : 펼쳐진 컬럼을 데이터화해서 추가되거나 삭제될때도 적절하게 대처할 수 있도록 원자화. 여러 값을 가진 컬럼이 존재할 수 없다. 즉 반복되는 그룹이 존재해서는 안 된다. 각 행과 열에는 하나의 값만이 올수 있다


/*
제2정규화
1개의 테이블에 정리된 데이터를 다른 테이블로 데이터를 분리하여 UPDATE 등을 수행할 때 데이터의 무결성을 보장하기 위한 조치

모든키가 아닌 컬럼은 기본 키 전체에 의존적이여야 한다. 기본키의 일부분에 의존적이어서는 안 된다.
*/

UPDATE tbl_iolist
SET io_pname = ''
WHERE io_pname = '';
/*
이 UPDATE는 다수의 레코드를 변경해버린다. 이 코드가 실행되면서 실행되지 않아야 할 데이터들에도 적용될 수 있고 변경되야 할 데이터들이 적용되지 않을 수도 있다
상품정보를 별도의 테이블로 분리하고 현재 테이블에는 상품정보 테이블과 연결하는 컬럼만 두어서 상품정보를 최소한으로 변경을 해도 보이는 데이터가 원하는 방향으로
변경될 수 있도록 하는 것이 이 테이블의 제2정규화이다
*/
SELECT io_pname,
AVG(DECODE(io_input, '매입', io_price)) AS 매입단가,
AVG(DECODE(io_input, '매출', io_price)) AS 매출단가
FROM tbl_iolist
GROUP BY io_pname
ORDER BY io_pname;

ALTER TABLE tbl_iolist RENAME COLUMN io_input TO io_out;
ALTER TABLE tbl_iolist RENAME COLUMN io_out TO io_inout;

SELECT io_pname FROM tbl_iolist
GROUP BY io_pname;

CREATE TABLE tbl_product(
p_code	VARCHAR2(5)		PRIMARY KEY,
p_name	nVARCHAR2(50)	NOT NULL	,
p_iprice	NUMBER		,
p_oprice	NUMBER		,
p_vat	VARCHAR2(1)		
);

SELECT COUNT(*) FROM tbl_product;

-- 작성한 상품정보 테이블과 매입매출 테이블을 EQ JOIN하여 데이터가 정확히 작성되었는지
SELECT COUNT(*)
FROM tbl_iolist, tbl_product
WHERE io_pname = p_name;

SELECT COUNT(*) FROM tbl_iolist;

-- 매입매출데이터에 상품코드컬럼을 추가한다
ALTER TABLE tbl_iolist
ADD io_pcode VARCHAR2(5);

-- 상품테이블에서 상품코드를 가져와서 매입매출데이터에 상품코드 컬럼에 UPDATE 실행
UPDATE tbl_iolist
SET io_pcode = 
(SELECT p_code FROM tbl_product -- 매입매출 테이블을 펼치고 각 레코드에 상품이름을 추출해 상품테이블의 SELECT 문으로 삽입하고 상품테이블에서 해당 상품이름으로 WHERE하여 나타나는 상품코드를 매입매출 테이블의 상품코드 컬럼에 업데이트
WHERE io_pname = p_name);

-- 상품코드 확인절차
SELECT COUNT(*) FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code;

-- 매입매출 테이블에서 상품이름 컬럼 제거
ALTER TABLE tbl_iolist DROP COLUMN io_pname;

SELECT * FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code;

-- 거래처 정보를 제2정규화

SELECT io_dname, COUNT(*)
FROM tbl_iolist
GROUP BY io_dname;


-- 거래처 정보는 같은 이름의 거래처가 있을 수 있기 때문에(같은 이름의 회사), 거래처 정보 테이블을 생성할 때는 거래처명과 대표이름을 함께 묶어서 정보를 추출
SELECT io_dname, io_dceo, COUNT(*)
FROM tbl_iolist
GROUP BY io_dname, io_dceo;

SELECT io_dname, io_dceo
FROM tbl_iolist
GROUP BY io_dname, io_dceo;
-- EXCEL ="010-"&TEXT(RANDBETWEEN(1000,9999), "0000")&"-"&TEXT(RANDBETWEEN(1000,9999), "0000")

CREATE TABLE tbl_dept(
d_code	VARCHAR2(5)		PRIMARY KEY,
d_name	nVARCHAR2(50)	NOT NULL	,
d_ceo	nVARCHAR2(50)	NOT NULL	,
d_tel	VARCHAR2(20)		,
d_addr	nVARCHAR2(125)		
);
-- 임포트

SELECT COUNT(*) FROM tbl_dept;

-- 매입매출테이블에 거래처코드 컬럼 추가
ALTER TABLE tbl_iolist
ADD io_dcode VARCHAR2(5);

DESC tbl_iolist;

-- 거래처정보 테이블과 매입매출정보 테이블 EQ JOIN을 실행해서 거래처정보가 정확히 생성되었는지 확인
SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name AND io_dceo = d_ceo;
-- 항상 정확하게 정보가 입력되었는지 검증하는 것을 습관화

-- 매입매출테이블에 거래처 코드 UPDATE
UPDATE tbl_iolist
SET io_dcode = (

-- UPDATE의 SUBQUERY에선 반드시 1개의 레코드만 추출되도록 WHERE 조건을 성립시켜야한다
SELECT d_code
FROM tbl_dept
WHERE io_dname = d_name AND io_dceo = d_ceo
);

SELECT COUNT(*) FROM tbl_iolist, tbl_dept
WHERE tbl_iolist.io_dcode = tbl_dept.d_code; -- 테이블의 이름이 중복되는 경우 ambiguous 오류가 뜨는데, 이를 해결하기 위해서는 컬럼 앞에 어떤 테이블인지 정확하게 지정해주면 해결된다

-- 매입매출에서 거래처명, 대표컬럼 삭제
ALTER TABLE tbl_iolist DROP COLUMN io_dname;
ALTER TABLE tbl_iolist DROP COLUMN io_dceo;

SELECT * FROM tbl_iolist;

DROP VIEW view_iolist;
CREATE VIEW view_iolist AS
(
SELECT 
tbl_iolist.IO_SEQ,
tbl_iolist.IO_DATE,
tbl_iolist.IO_INOUT,

tbl_iolist.IO_PCODE,
tbl_product.P_NAME AS tbl_iolist_pname,
tbl_product.P_IPRICE AS tbl_iolist_iprice,
tbl_product.P_OPRICE AS tbl_iolist_oprice,
tbl_product.P_VAT AS tbl_iolist_pvat,

tbl_iolist.IO_DCODE,

tbl_dept.D_NAME AS tbl_iolist_DNAME,
tbl_dept.D_CEO AS tbl_iolist_DCEO,
tbl_dept.D_TEL AS tbl_iolist_DTEL,
tbl_dept.D_ADDR AS tbl_iolist_DADDR,

tbl_iolist.IO_QTY,
tbl_iolist.IO_PRICE,
tbl_iolist.IO_TOTAL

FROM tbl_iolist
LEFT JOIN tbl_product
ON tbl_iolist.io_pcode = tbl_product.p_code
LEFT JOIN tbl_dept
ON tbl_iolist.io_dcode = tbl_dept.d_code
);

SELECT * FROM view_iolist;

SELECT * FROM view_iolist
ORDER BY io_date;