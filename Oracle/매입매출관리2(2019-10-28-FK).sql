SELECT D_CODE, D_NAME, D_CEO, D_TEL, D_ADDR FROM tbl_dept;
SELECT P_CODE, P_NAME, P_IPRICE, P_OPRICE, P_VAT FROM tbl_product;
SELECT IO_SEQ, IO_DATE, IO_INOUT, IO_QTY, IO_PRICE, IO_TOTAL, IO_PCODE, IO_DCODE FROM tbl_iolist;

/*
tbl_iolist   -   tbl_product
io pcode        pcode

tbl_iolist   -   tbl_dept
io dcode        dcode

테이블들의 참조무결성을 보장하기 위해 Foreign Key 설정을 수행해야 한다
*/

ALTER TABLE tbl_iolist -- 연동되는 테이블
ADD CONSTRAINT FK_PRODUCT
FOREIGN KEY(io_pcode) -- PK키와 연동되는 테이블의 컬럼
REFERENCES tbl_product(p_code); -- PK키로 설정된 것. n:1에서 1 쪽의 컬럼

ALTER TABLE tbl_iolist -- 연동되는 테이블
ADD CONSTRAINT FK_dept
FOREIGN KEY(io_dcode) -- PK키와 연동되는 테이블의 컬럼
REFERENCES tbl_dept(d_code); -- PK키로 설정된 것. n:1에서 1 쪽의 컬럼

/*
오라클 SQL문의 LEVEL
1부터 <= 변수까지 연속된 값을 레코드로 뽑아내주는 오라클SQL
SELECT LEVEL(연산) FROM dual CONNECT BY LEVEL 비교연산자 숫자(변수)
처음 LEVEL을 조작하여 단위나 시작하는 숫자를 바꾸거나 값의 정렬순서를 설정할 수 있다

오라클의 대치연산자 &
SQL 사용자로부터 값을 입력받아서 SQL을 수행하기 위한 방법
*/
SELECT LEVEL FROM DUAL
CONNECT BY LEVEL <= 10;
SELECT LEVEL FROM DUAL
CONNECT BY LEVEL <= &변수;
SELECT LEVEL FROM DUAL
CONNECT BY LEVEL <= &ㅣㅁㄴㅅ;
SELECT LEVEL*10 FROM DUAL -- 10부터 100까지 10단위로
CONNECT BY LEVEL <= 10;
SELECT LEVEL * &시작 FROM DUAL CONNECT BY LEVEL <= &종료;
SELECT (LEVEL-10) * -1 FROM DUAL CONNECT BY LEVEL < 10; -- 내림차순
SELECT IO_SEQ, IO_DATE, IO_INOUT, IO_QTY, IO_PRICE, IO_TOTAL, IO_PCODE, IO_DCODE FROM tbl_iolist
WHERE io_date BETWEEN '&시작일자' AND '&종료일자';

SELECT TO_DATE('20190101', 'YYYYMMDD') FROM DUAL; -- 문자열을 날짜로 바꿔주는 Keyword
SELECT TO_DATE('2019-01-01', 'YYYY-MM-DD') FROM DUAL; -- 문자열을 날짜로 바꿔주는 Keyword
-- 날짜값으로 어떠한 연산을 하고자 할 때는 변환해야할 필요가 있는데 그 때 사용한다

SELECT TO_DATE('2019-01-01', 'YYYY-MM-DD') + LEVEL FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2019-01-31', 'YYYY-MM-DD') - TO_DATE('2019-01-01', 'YYYY-MM-DD');
-- 하루하루를 DATE로 연산하여 결과값을 보기

SELECT TO_DATE('2019-02-01', 'YYYY-MM-DD') - 1 + LEVEL FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2019-09-30', 'YYYY-MM-DD') - (TO_DATE('2019-02-01', 'YYYY-MM-DD') + 1);

SELECT TO_CHAR(ADD_MONTHS(TO_DATE ('2019-02-01', 'YYYY-MM-DD'), LEVEL - 1), 'YYYY-MM') FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2019-09-30', 'YYYY-MM-DD') - (TO_DATE('2019-02-01', 'YYYY-MM-DD') + 1); -- 2019-02-01부터 2019-09-30까지 년, 월 추출해서 문자열로

SELECT ADD_MONTHS(TO_DATE('2019-01-01', 'YYYY-MM-DD'), 1) FROM DUAL; -- 날짜에 월을 더해서 날짜데이터로 리턴
SELECT ADD_MONTHS(TO_DATE('2019-01-01', 'YYYY-MM-DD'), LEVEL - 1) FROM DUAL
CONNECT BY LEVEL <= 5; -- 날짜에 월을 더해서 날짜데이터로 리턴
-- 오라클에서 날짜관련 연산을 수행할 때는 문자열 형태로는 불가능하여 TO_DATE를 사용해서 날짜타입으로 변환한다

SELECT SYSDATE FROM DUAL; -- 컴퓨터의 현재 날짜
SELECT LAST_DAY(SYSDATE) FROM DUAL; -- 현재 날짜가 포함된 달의 마지막 날짜

SELECT TO_CHAR(TRUNC(SYSDATE, 'month') + (LEVEL - 1), 'yyyy-mm-dd') FROM DUAL CONNECT BY LEVEL <= (LAST_DAY(SYSDATE) - TRUNC(SYSDATE, 'month') +1);
-- 현재 날짜가 포함된 달의 첫번째 날부터 마지막 날까지 리스트로

SELECT TO_CHAR(ADD_MONTHS(TO_DATE ('2018-01-01', 'YYYY-MM-DD'), LEVEL - 1), 'YYYY-MM') FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2018-12-31', 'YYYY-MM-DD') - (TO_DATE('2018-01-01', 'YYYY-MM-DD') + 1);
-- 2018년 1월 1일부터 12월 31일까지 MONTH값만

SELECT * FROM tbl_iolist IO, (
SELECT TO_CHAR(ADD_MONTHS(TO_DATE ('2018-01-01', 'YYYY-MM-DD'), LEVEL - 1), 'YYYY-MM') FROM DUAL
CONNECT BY LEVEL <= 12
);

SELECT TO_CHAR(ADD_MONTHS(TO_DATE(io_date, 'YYYY-MM-DD'), 0), 'YYYY-MM') FROM tbl_iolist;

SELECT SUBSTR(io_date, 0, 7) AS IO_MONTH, SUM(io_total) FROM tbl_iolist IO
GROUP BY SUBSTR(io_date, 0, 7); -- 월별로 합계 계산

-- 월 리스트를 서브쿼리로 생성한 다음 월 리스트를 가지고 월별합계 계산
SELECT IO_MONTH, SUM(io_total)
FROM tbl_iolist IO,
(
SELECT TO_CHAR(ADD_MONTHS(TO_DATE ('2018-01-01', 'YYYY-MM-DD'), LEVEL - 1), 'YYYY-MM') FROM DUAL
CONNECT BY LEVEL <= 12
)
WHERE IO_MONTH = SUBSTR(io_date, 0, 7)
GROUP BY IO_MONTH;

SELECT MAX(io_total) FROM tbl_iolist; -- 1500000
SELECT MIN(io_total) FROM tbl_iolist; -- 12250

SELECT SUB.TOTAL, SUM(io_total), COUNT(io_total) FROM tbl_iolist, 
(SELECT LEVEL * 10000 AS TOTAL FROM DUAL CONNECT BY LEVEL <= 150) SUB
WHERE io_total >= SUB.TOTAL AND io_total < SUB.TOTAL + 10000 AND io_inout = '매출'
GROUP BY TOTAL
ORDER BY TOTAL; -- SUB 10000~1500000까지 10000단위로 증가하는 값 생성 후 각각의 값 범위 내에 있는 값들의 합계와 개수 계산

-- 서브쿼리와 EQ JOIN으로 학생수가 있는 점수대만 보이기
SELECT 점수, COUNT(SC.sc_score) FROM tbl_score SC, 
(SELECT LEVEL * 10 AS 점수 FROM DUAL CONNECT BY LEVEL <= 10) SUB
WHERE SC.sc_score >= 점수 AND SC.sc_score <= 점수+10
GROUP BY 점수
ORDER BY 점수;

-- 서브쿼리와 LEFT JOIN으로 학생수가 없어도 모든 점수대를 보이기
SELECT 점수, COUNT(SC.sc_score) FROM 
(
SELECT LEVEL * 10 AS 점수 FROM DUAL CONNECT BY LEVEL <= 10
) SUB
LEFT JOIN tbl_score SC
ON SC.sc_score >= 점수 AND SC.sc_score <= 점수 + 10
GROUP BY 점수
ORDER BY 점수;

-- 오라클에서 숫자를 연속된 값의 리스트로 만들 때
SELECt LEVEL/* 시작점, 단위를 조정 */ FROM DUAL CONNECT BY LEVEL <= &변수;
SELECt LEVEL*0.1/* 시작점, 단위를 조정 */ FROM DUAL CONNECT BY LEVEL <= &변수;


SELECT sc_subject FROM tbl_score
GROUP BY sc_subject
ORDER BY sc_subject;

SELECT * FROM (SELECT sc_name, sc_subject, sc_score FROM tbl_score)
PIVOT ( -- sc_subject에 들어있는 과목명(제1정규형)의 리스트. 보고서 형태로 보여주는 쿼리
SUM(sc_score)
FOR sc_subject IN(
'국어' as 국어,
'수학' as 수학,
'과학' as 과학,
'영어' as 영어,
'국사' as 국사,
'미술' As 미술
)
);


SELECT sc_name, 
SUM(DECODE(sc_subject, '과학', sc_score)) AS 과학,
SUM(DECODE(sc_subject, '국어', sc_score)) AS 국어,
SUM(DECODE(sc_subject, '수학', sc_score)) AS 수학,
SUM(DECODE(sc_subject, '국사', sc_score)) AS 국사,
SUM(DECODE(sc_subject, '영어', sc_score)) AS 영어,
SUM(DECODE(sc_subject, '미술', sc_score)) AS 미술
FROM tbl_score
GROUP BY sc_name; -- SUM으로 묶이면 GROUP BY를 따로 해주지 않아도 된다
-- 한 사람을 기준으로 과목을 나열하여 보이기 위해 이름으로 GROUP BY를 하고 나머지 항목에서 GROUP BY를 수행하여야 SQL문이 정상으로 작동되는데
-- 학생 이름을 제외한 나머지 항목을 SUM해주면 GROUP BY에 나열하지 않아도 된다
-- SUM으로 묶지 않으면 GROUP BY 코드가 길어지고 원하지 않는 결과가 나온다
SELECT sc_name, 
DECODE(sc_subject, '과학', sc_score) AS 과학,
DECODE(sc_subject, '국어', sc_score) AS 국어,
DECODE(sc_subject, '수학', sc_score) AS 수학,
DECODE(sc_subject, '국사', sc_score) AS 국사,
DECODE(sc_subject, '영어', sc_score) AS 영어,
DECODE(sc_subject, '미술', sc_score) AS 미술
FROM tbl_score
GROUP BY sc_name,
DECODE(sc_subject, '과학', sc_score),
DECODE(sc_subject, '국어', sc_score),
DECODE(sc_subject, '수학', sc_score),
DECODE(sc_subject, '국사', sc_score),
DECODE(sc_subject, '영어', sc_score),
DECODE(sc_subject, '미술', sc_score)
ORDER BY sc_name;


-- 표준 SQL CASE WHEN. MySQL, MSSQL IF, ORACLE DECODE
SELECT sc_name, 
SUM(CASE WHEN sc_subject = '과학' THEN sc_score END) AS 과학,
SUM(CASE WHEN sc_subject = '수학' THEN sc_score END) AS 수학,
SUM(CASE WHEN sc_subject = '국어' THEN sc_score END) AS 국어,
SUM(CASE WHEN sc_subject = '영어' THEN sc_score END) AS 영어,
SUM(CASE WHEN sc_subject = '미술' THEN sc_score END) AS 미술,
SUM(CASE WHEN sc_subject = '국사' THEN sc_score END) AS 국사
FROM tbl_score
GROUP BY sc_name;

SELECT sc_name, 
SUM(CASE WHEN sc_subject = '과학' THEN sc_score ELSE 0 END) AS 과학,
SUM(CASE WHEN sc_subject = '수학' THEN sc_score ELSE 0 END) AS 수학,
SUM(CASE WHEN sc_subject = '국어' THEN sc_score ELSE 0 END) AS 국어,
SUM(CASE WHEN sc_subject = '영어' THEN sc_score ELSE 0 END) AS 영어,
SUM(CASE WHEN sc_subject = '미술' THEN sc_score ELSE 0 END) AS 미술,
SUM(CASE WHEN sc_subject = '국사' THEN sc_score ELSE 0 END) AS 국사
FROM tbl_score
GROUP BY sc_name;

SELECT io_inout,
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist
GROUP BY io_inout;

SELECT 
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist;

SELECT 
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출,
SUM(DECODE(io_inout, '매출', io_total, 0)) -
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 마진
FROM tbl_iolist;

SELECT 
TO_CHAR(SUM(DECODE(io_inout, '매입', io_total, 0)), '999,999,999,999,999') AS 매입,
TO_CHAR(SUM(DECODE(io_inout, '매출', io_total, 0)), '999,999,999,999,999') AS 매출,
TO_CHAR(SUM(DECODE(io_inout, '매출', io_total, 0)) -
SUM(DECODE(io_inout, '매입', io_total, 0)), '999,999,999,999,999') AS 마진
FROM tbl_iolist;

-- 월별집계
SELECT 
SUBSTR(io_date, 0, 7), 
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist
GROUP BY SUBSTR(io_date, 0, 7)
ORDER BY SUBSTR(io_date, 0, 7);


-- 거래처별로 매입매출 집계. 거래처 테이블과 JOIN
SELECT io_dcode, d_name, d_ceo, d_tel,
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist IO
LEFT JOIN tbl_dept D
ON IO.io_dcode = D.d_code
GROUP BY io_dcode, d_name, d_ceo, d_tel
ORDER BY io_dcode;

SELECT io_dcode, d_name || d_ceo || d_tel AS 거래처,
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist IO
LEFT JOIN tbl_dept D
ON IO.io_dcode = D.d_code
GROUP BY io_dcode, d_name || d_ceo || d_tel -- 내부 실행 순서가 차이가 있다. SELECT Projection에 계산식을 쓰는 경우 GROUP BY에 프로젝션을 모두 적어야한다
-- 순서에 있어 Alias가 있는 SELECT가 GROUP BY보다 늦게 실행되므로 AS로는 적을 수 없다
ORDER BY io_dcode;

SELECT io_dcode, d_name || d_ceo || d_tel AS 거래처,
SUM(DECODE(io_inout, '매입', io_total, 0)) AS 매입,
SUM(DECODE(io_inout, '매출', io_total, 0)) AS 매출
FROM tbl_iolist IO
LEFT JOIN tbl_dept D
ON IO.io_dcode = D.d_code
GROUP BY io_dcode, d_name || d_ceo || d_tel -- HAVING도 마찬가지로 순서 문제로 다 적어줘야한다
HAVING SUM(DECODE(io_inout, '매입' , io_total, 0)) > 100000 -- 매입합계가 100000 이상인 조건
ORDER BY io_dcode;

SELECT io_date, io_pcode, p_name,
DECODE(io_inout, '매입', io_price) AS 매입단가,
DECODE(io_inout, '매입합계', io_total) AS 매입합계,
DECODE(io_inout, '매출', io_price) AS 매출,
DECODE(io_inout, '매출합계', io_total) AS 매출합계
FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code
ORDER BY io_date;

SELECT io_date, io_dcode, d_name, io_pcode, p_name,
DECODE(io_inout, '매입', io_price) AS 매입단가,
DECODE(io_inout, '매입합계', io_total) AS 매입합계,
DECODE(io_inout, '매출', io_price) AS 매출,
DECODE(io_inout, '매출합계', io_total) AS 매출합계
FROM tbl_iolist
LEFT JOIN tbl_product
ON io_pcode = p_code
LEFT JOIN tbl_dept
ON io_dcode = d_code
ORDER BY io_date;