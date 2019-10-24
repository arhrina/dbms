-- iolist

-- 매출장 TABLE 생성

CREATE TABLE tbl_iolist(
io_seq	NUMBER	NOT NULL	PRIMARY KEY,
io_date	VARCHAR2(10)	NOT NULL	,
io_pname	nVARCHAR2(50)	NOT NULL	,
io_dname	nVARCHAR2(50)	NOT NULL	,
io_dceo	nVARCHAR2(20)		,
io_inout	NUMBER(1)	NOT NULL	,
io_qty	NUMBER	NOT NULL	,
io_price	NUMBER		,
io_amt	NUMBER		
);

-- 엑셀원본데이터 분리(제1정규화)
-- 날짜데이터 문자열로 수정
-- 엑셀 데이터 import

SELECT io_inout, COUNT(*) FROM tbl_iolist
GROUP BY io_inout;

SELECT DECODE(io_inout, 1, '매입', '매출') AS 구분,
COUNT(*) FROM tbl_iolist
GROUP BY DECODE(io_inout, 1, '매입', '매출');
-- DECODE(컬럼, 값, T, F)

SELECT DECODE(io_inout, 1, '매입', 2, '매출') AS 구분,
COUNT(*) FROM tbl_iolist
GROUP BY DECODE(io_inout, 1, '매입', 2, '매출');
-- DECODE(컬럼, 값1, T1, 값2, T2, 값3, T3) 오라클 문법. 여러개의 값에 대해 사용할 수 있다

/*
자바 표현
IF(컬럼 == 값){
T
}
else if(컬럼 == 값2){
T2
}
else if(컬럼 == 값3){
T3
}

SQL 표현
DECODE(컬럼, 값, T, DECODE(컬럼, 값2, T2, DECODE(컬럼, 값3, T3)))

ORACLE 표현
DECODE(컬럼, 값, T, 값2, T2, 값3, T3)

1개의 컬럼이 여러개의 값을 가지고 있고 이를 분리하여 처리하고자 하면 오라클의 DECODE는 좋은 모양을 이룰 수 있다
*/

SELECT DECODE(io_inout, 1, '매입', 2, '매출') AS 거래구분,
SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계
FROM tbl_iolist
GROUP BY DECODE(io_input, 1, '매입', 2, '매출');

SELECT SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계
FROM tbl_iolist;

SELECT io_date, SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계
FROM tbl_iolist
GROUP BY io_date;


-- LEFT : 표준SQL에서 왼쪽부터 문자열 자르기
-- RIGHT : 표준SQL에서 오른쪽부터 문자열 자르기
-- MID(문자열, 시작, 개수) : 중간문자열 자르기
SELECT SUBSTR(io_date, 0, 7) AS 월, SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계
FROM tbl_iolist
GROUP BY SUBSTR(io_date, 0, 7);


SELECT SUBSTR(io_date, 0, 7) AS 월, SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계
FROM tbl_iolist
GROUP BY SUBSTR(io_date, 0, 7)
ORDER BY SUBSTR(io_date, 0, 7);

SELECT SUBSTR(io_date, 0, 7) AS 월, SUM(DECODE(io_inout, 1, io_amt, 0)) AS 매입합계,
SUM(DECODE(io_inout, 2, io_amt, 0)) AS 매출합계,

SUM(DECODE(io_inout, 2, io_amt, 0)) -
SUM(DECODE(io_inout, 1, io_amt, 0)) AS 마진

FROM tbl_iolist
GROUP BY SUBSTR(io_date, 0, 7)
ORDER BY SUBSTR(io_date, 0, 7);