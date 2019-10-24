-- user3

-- DUAL : 시스템 테이블. Dummy Table이라고도 한다. 1개의 레코드만 가진 테이블. 문법오류를 방지하기 위한 임시테이블
/*
표준 SQL에선 일반적인 프로그래밍 코드에서 사용하는 간단한 연산을 SELECT 문으로 실행할 수 있도록 하고 있다
SELECT 30 + 40
오라클에선 SELECT 다음에 FROM [table]이 없으면 문법오류가 발생한다. 그래서 표준SQL에 사용되는 간단한 코드를 실행하려면 다른 방법을 추가해야한다
문법 오류를 방지하고자 FROM DUAL이라는 Dummy Table명을 붙여주어야한다
*/
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM DUAL;

-- DUAL TABLE을 이용한 간단한 코드를 실제 데이터가 있는 TABLE을 상대로 실행하면 실제 테이블에 저장된 개수만큼 반복되어 실행된다
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM tbl_student;

-- UNION : 여러 테이블을 SELECT해서 생성된 VIEW를 하나의 결과처럼 묶어서 보고자 할 때 쓰는 키워드
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '2' AS num, '이몽룡' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '3' AS num, '성춘향' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '4' AS num, '장보고' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '5' AS num, '임꺽정' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '6' AS num, '장영실' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '7' AS num, '장길산' AS name, '컴공과' AS dept FROM DUAL;
-- 실제 테이블을 DBMS에 생성하지 않고 가상의 데이터를 만들어서 사용하고자 할 때 임시로 TABLE 구조와 데이터를 생성하여 TEST 용도로 사용하는 명령 군
-- 이 명령 군을 사용할 때 UNION이라는 키워드를 사용한다

SELECT * FROM tbl_score;
SELECT '====' AS 학번, '===='AS 국어, '====' AS 영어, '====' AS 수학 FROM DUAL
UNION ALL SELECT '학번' AS 학번, '국어' AS 국어, '영어' AS 영어, '수학' AS 수학 FROM DUAL
UNION ALL SELECT '====' AS 학번, '====' AS 국어, '====' AS 영어, '====' AS 수학 FROM DUAL
UNION ALL SELECT s_num AS 학번,
to_char(s_kor, '999') AS 국어,
to_char(s_eng, '999') AS 영어,
to_char(s_math, '999') AS 수학 FROM tbl_score
UNION ALL SELECT '----' AS 학번, '----' AS 국어, '----' AS 영어, '----' AS 수학 FROM DUAL
UNION ALL SELECT '총점' AS 학번,
to_char(SUM(s_kor), '99,999') AS 국어,
to_char(SUM(s_eng), '99,999') AS 영어,
to_char(SUM(s_math), '99,999') AS 수학 FROM tbl_score
UNION ALL SELECT '----' AS 학번, '----' AS 국어, '----' AS 영어, '----' AS 수학 FROM DUAL;

-- to_char(값, 자료형식). 숫자형 자료를 문자열형 자료로 변환시키는 cascading 함수. UNION ALL을 할 때 숫자는 문자로 변환해주어야한다
/*
형식
9 : 숫자자릿수를 나타낸다. 실제 출력되는 값의 자릿수만큼 개수를 지정해야한다
to_char(123, '99999') >> 123
0 : 숫자자릿수를 나타내는 형식. 실제 출력되는 값보다 자릿수가 많으면 나머지는 0으로 채운다
to_char(123, '00000') >> 00123
, : 구분기호. 콤마를 찍어주면 콤마를 찍은 단위마다 출력한다. 한국에서의 천단위 구분기호
. : 구분기호. 마침표를 찍어주면 마침표를 찍은 단위마다 출력한다. 어떤 국가에서의 천단위 구분기호

날짜형 데이터를 문자열형으로 바꿀 때
YYYY : 연도 형식
RRRR : 연도 형식
MM : 월 형식
DD : 일 형식

HH : 12시간식 시간
HH24 : 24시간식 시간
MI : 분
SS : 초

to_char(날짜값, 'YYYY MM DD HH MI SS')
*/

SELECT to_char(SYSDATE, 'YYYY-MM-DD, HH24-MI-SS') FROM DUAL;
-- SYSDATE : 오라클에서 현재 컴퓨터의 시간과 날짜를 가져오는 시스템 변수
-- UNION : TABLE의 결과를 집합하여 하나의 VIEW처럼 보여주는 형식
/*
UNION 중복데이터 배제, 내부적으로 SORT, 중복제거작업으로 쿼리가 늦어질 수 있음
UNION ALL 중복데이터 여부 상관없이 보여준다

SQL만으로 보고서를 만들고자 할 때 쓰인다
*/


-- SQL 테스트를 위해 임시로 테이블을 생성하는 오라클 SQL. 아래 있는 표준SQL SUBQUERY와 동일한 결과
WITH tbl_temp AS
(
SELECT '1' AS num, '홍길동' AS name FROM DUAL
UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL
)
SELECT * FROM tbl_temp;


-- 표준SQL에서 사용하는 가장 간단한 SUBQUERY. 어떤 TABLE의 결과를 FROM으로 받아서 다시 SELECT하는 SQL
SELECT * FROM(
SELECT '1' AS num, '홍길동' AS name FROM DUAL
UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL
);




-- 임시로 만든 테이블은 일반 TABLE에 접근하는 SELECT문과 동일한 접근들이 가능하다
WITH tbl_temp AS
(
SELECT '1' AS num, '홍길동' AS name FROM DUAL
UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL
)
SELECT * FROM tbl_temp
WHERE num IN ('3', '1', '5')
ORDER BY num;

SELECT * FROM tbl_student;
-- ('기은성', '남동예', '내세원', '갈한수', '방채호', '배채호'); 검색

SELECT * FROM tbl_student
WHERE st_name IN ('기은성', '남동예', '내세원', '갈한수', '방채호', '배채호');


-- SUBQUERY. JOIN과 비슷한 용도로 사용. 교재 438p


-- 1. WHERE에 사용하는 QUBQUERY. 중첩(서브)쿼리. 가장 많은 빈도로 사용된다
WITH tbl_temp AS
( /* 이 괄호에 있는 값들을 tbl_temp에 만들고 */
SELECT '기은성' AS name FROM DUAL
UNION ALL SELECT '남동예' AS name FROM DUAL
UNION ALL SELECT '내세원' AS name FROM DUAL
UNION ALL SELECT '방채호' AS name FROM DUAL
UNION ALL SELECT '배채호' AS name FROM DUAL
)
SELECt * FROM tbl_student
WHERE st_name IN (SELECT name FROM tbl_temp/* 위 테이블에 있는 괄호에 있는 자료들을 조건으로 tbl_student에 있는 st_name을 검색한다 */);

/*
WHERE에 포함된 SELECT를 실행

이 WHERE를 사용해서 tbl_student 데이터를 조회
*/

-- 2. FROM에 사용되는 SUBQUERY. 인라인뷰라고 하며 다른 TABLE의 결과를 FROM에서 사용
-- 여러 TABLE을 결합하여 나오는 결과값들을 모아서 하나의 쿼리로 연결하여 VIEW로 보여주기 위한 SubQuery
-- EQ JOIN을 대신해서 쓸 수 있다

SELECT * FROM (SELECT * FROM tbl_student WHERE st_grade = 1);

SELECT * FROM tbl_score2 SC, tbl_student ST
WHERE SC.s_num = ST.st_num;


-- 단순한 JOIN을 이용해 보여주기 복잡한 통계, 집계 등을 사용할 때 먼저 SubQuery에서 통계, 집계 등을 수행하고 그 결과와 main table을 JOIN
SELECT * FROM tbl_student ST, (SELECT SC.s_num, (SC.s_kor + SC.s_eng + SC.s_math) FROM tbl_score2 SC) SC_S
WHERE ST.st_num = SC_S.s_num;

-- 3. SELECT SUBQUERY
-- 스칼라 서브 쿼리
-- 1, 2 쿼리와 달리 List를 출력하면 안된다. 단 1줄의 Record만 보낸다

/*
내부로직을 java로 가상으로 표현

tbl_student를 for로 반복
tbl_student의 st_num값을 subQuery에 전달. SubQuery는 마치 메소드처럼 작동
SubQuery에서 WHERE를 실행하여 SELECT 될 데이터를 추리고 추린 결과로 SUM(s_kor+s_eng+s_math)를 실행하여 결과를 return
st_num, return 형식으로 표시
*/
SELECT st_num, 
( -- 이 내부 SQuery는 1줄의 레코드만을 return한다
SELECT SUM(s_kor + s_eng + s_math) FROM tbl_score SC
WHERE ST.st_num = SC.s_num
)
FROM tbl_student ST;