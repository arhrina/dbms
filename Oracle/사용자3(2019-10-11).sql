-- user3

SELECT * FROM tab;
-- TABLE과 VIEW의 차이
/* 
TABLE은 실제 저장된 데이터, CRUD 가능, 원본데이터
VIEW는 가상의 데이터, 테이블로부터 SELECT를 실행한 후 보여주는 형태, READ(조회, SELECT)만 가능, 테이블로부터 유도된 보기전용데이터
*/

SELECT * FROM tbl_score; -- 단순 테이블 조회. 이것만으로는 구체적인 다른 정보를 찾기 어렵다
-- 학번과 연계해 학생테이블을 연결하고 학과테이블과도 연결하여 하나의 데이트시트처럼 보기 위한 SQL => JOIN

DESC tbl_student;
/* 학생테이블에 학과 컬럼이 있음에도 SQL의 편의성을 고려해 성적테이블에 학과 컬럼을 추가하여 관리했다 => tbl_score2
tbl_score2에 등록된 학과가 실제 학생의 학과코드와 다른 값이 등록될 수 있다. 이런 경우 조회했을 때 실제 데이터와 차이가 있는 논리적 오류가 발생할 수 있다

tbl_score와 tbl_student를 join하고 학과를 기준으로 tbl_dept와 join
*/

SELECT * 
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num;

SELECT * FROM tbl_dept;

DELETE FROM tbl_student; -- 전체데이터 삭제. 주의
-- 테이블에 import하여 excel 파일의 내용을 삽입
SELECT * FROM tbl_student;

SELECT * 
FROM tbl_student ST
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num;

SELECT ST.st_num, ST.st_name, ST.st_dept, DP.d_name, DP.d_pro
FROM tbl_student ST
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num
ORDER BY ST.st_num;


-- 위 SELECT를 VIEW로 생성. ORDER BY 삭제, 각 컬럼에 별도의 Alias 설정, SELECT가 제대로 나오는지 확인하고 ()로 감싸기, () 앞에 CREATE VIEW AS
CREATE VIEW view_st_dept
AS
(
SELECT ST.st_num 학번,
ST.st_name 이름,
ST.st_dept 학과코드,
DP.d_name 학과이름,
DP.d_pro 담당교수
FROM tbl_student ST
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num
);

SELECT * FROM view_st_dept;

SELECT * FROM view_st_dept
WHERE 학과이름 = '컴퓨터공학';

SELECT * FROM view_st_dept
WHERE 학과이름 LIKE '컴퓨터%'
ORDER BY 학번 DESC;
-- view_st_dept를 사용해서 학과별 학생수(COUNT)를 확인
SELECT 학과코드, 학과이름, COUNT(학과코드) 
FROM view_st_dept
GROUP BY 학과코드, 학과이름
ORDER BY 학과코드 ASC;

-- 학생수를 기준으로 오름차순 정렬
SELECT 학과코드, 학과이름, COUNT(학과코드) 
FROM view_st_dept
GROUP BY 학과코드, 학과이름
ORDER BY COUNT(학과코드) ASC;
-- 집계함수 SUM COUNT MAX MIN AVERAGE 를 사용할 때 집계함수로 감싸지 않은 컬럼을 Projection(select 뒤에 나열하는 컬럼)에 표시하려고 하면 반드시 GROUP BY에 나열해줘야 한다
/*
전체에서 학과코드별로 묶어서 학과 코드가 무엇인지 select
포함된 학생수를 계산하여 보기 => 학과코드별 부분 합(개수)을 계산
*/

SELECT 학번, 이름, COUNT(*)
FROM view_st_dept
GROUP BY 학번, 이름; -- 학번은 절대 중복된 값이 없으므로 GROUP BY가 효과가 없다

-- 학과별 학생수 계산하고 학생수가 20명 이상인 과만 보인다
SELECT 학과코드, 학과이름, COUNT(*)
FROM view_st_dept
GROUP BY 학과코드, 학과이름
HAVING COUNT(*) >= 20;

-- 학생수를 계산하고 컴퓨터공학만 보여라
SELECT 학과코드, 학과이름, COUNT(*)
FROM view_st_dept
GROUP BY 학과코드, 학과이름
HAVING 학과이름 = '컴퓨터공학';
-- group by -> from -> count -> having순 실행. group by는 매우 느린 코드. having은 연산결과로 조건을 거는 것이 좋다
-- 개선코드
SELECT 학과코드, 학과이름, COUNT(*)
FROM view_st_dept
WHERE 학과이름 = '컴퓨터공학'
GROUP BY 학과코드, 학과이름;
-- where -> from -> group by -> count순 실행. 컬럼에 조건을 걸 경우 where가 having보다 더 낫다

SELECT *
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num;

SELECT SC.s_num, ST.st_name, ST.st_dept, SC.s_kor, SC.s_eng, SC.s_math
FROM tbl_score SC
LEFT JOIN tbl_student ST -- 101번 때문에 EQ JOIN을 쓰지 못하고 LEFT JOIN
ON SC.s_num = ST.st_num;

CREATE VIEW view_sc_st
AS
(
SELECT SC.s_num AS 학번, ST.st_name AS 이름, ST.st_dept AS 학과코드, SC.s_kor AS 국어, SC.s_eng AS 영어, SC.s_math AS 수학
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num);

SELECT * FROM view_sc_st;

-- 생성된 2개의 뷰를 JOIN
SELECT *
FROM view_sc_st SC-- 주 테이블
LEFT JOIN view_st_dept DP -- 서브 테이블
ON SC.학과코드 = DP.학과코드;

SELECT SC.학번, SC.이름, SC.학과코드, DP.학과이름, SC.국어, SC.영어, SC.수학
FROM view_sc_st SC
LEFT JOIN view_st_dept DP
ON SC.학과코드 = DP.학과코드
ORDER BY SC.학번;
-- 2개의 뷰를 JOIN했더니 결과가 중복값들 등 이상하면 조인들을 다시 수행

SELECT *
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num;

SELECT SC.s_num, ST.st_name, DP.d_name, DP.d_pro, SC.s_kor, SC.s_eng, SC.s_math
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num;


CREATE VIEW view_성적일람표
AS
(
SELECT SC.s_num AS 학번, ST.st_name AS 학생이름, ST.st_dept AS 학과코드, DP.d_name AS 학과이름, DP.d_pro AS 담당교수, SC.s_kor AS 국어, SC.s_eng AS 영어, SC.s_math AS 수학,
SC.s_kor + SC.s_eng + SC.s_math AS 총점, ROUND((SC.s_kor + SC.s_eng + SC.s_math) / 3, 0) AS 평균,
RANK() OVER(ORDER BY (SC.s_kor + SC.s_eng + SC.s_math) DESC ) AS 석차
FROM tbl_score SC
LEFT JOIN tbl_student ST
ON SC.s_num = ST.st_num
LEFT JOIN tbl_dept DP
ON ST.st_dept = DP.d_num);

SELECT * FROM view_성적일람표;

-- 전체학생에 대한 과목별 총점
SELECT SUM(국어), SUM(영어), SUM(수학)
FROM view_성적일람표;

-- 학과별 과목별 총점
SELECT 학과코드, 학과이름, SUM(국어), SUM(영어), SUM(수학)
FROM view_성적일람표
GROUP BY 학과코드, 학과이름;

SELECT 학과코드, 학과이름, SUM(국어) AS 국어총점, SUM(영어) AS 영어총점, SUM(수학) AS 수학총점, SUM(총점) AS 전체총점, ROUND(AVG(평균), 1) AS 전체평균
FROM view_성적일람표
GROUP BY 학과코드, 학과이름;



-- 특정 과만 집계
SELECT 학과코드, 학과이름, SUM(국어) AS 국어총점, SUM(영어) AS 영어총점, SUM(수학) AS 수학총점, SUM(총점) AS 전체총점, ROUND(AVG(평균), 1) AS 전체평균
FROM view_성적일람표
WHERE 학과이름 IN ('영어영문', '군사학')
GROUP BY 학과코드, 학과이름;

SELECT 학과코드, 학과이름, SUM(국어) AS 국어총점, SUM(영어) AS 영어총점, SUM(수학) AS 수학총점, SUM(총점) AS 전체총점, ROUND(AVG(평균), 1) AS 전체평균
FROM view_성적일람표
WHERE 학과코드 IN ('002', '005')
GROUP BY 학과코드, 학과이름;
-- WHERE, HAVING으로 조건을 설정할 땐 길이가 가변적인 값보단 고정된 길이의 값으로 조회하는 것이 더 안정적이다

-- 성적 excel에서 score로 import

-- 학과별 평균이 75 초과만 표시
SELECT 학과코드, 학과이름, SUM(국어) AS 국어총점, SUM(영어) AS 영어총점, SUM(수학) AS 수학총점, SUM(총점) AS 전체총점, ROUND(AVG(평균), 1) AS 전체평균
FROM view_성적일람표
GROUP BY 학과코드, 학과이름
HAVING ROUND(AVG(평균), 1) > 75;

-- 학과코드가 002부터 004까지
-- 문자열이지만 길이가 같으면 관계연산자를 사용한 범위 조회가 가능
SELECT 학과코드, 학과이름, SUM(국어) AS 국어총점, SUM(영어) AS 영어총점, SUM(수학) AS 수학총점, SUM(총점) AS 전체총점, ROUND(AVG(평균), 1) AS 전체평균
FROM view_성적일람표
WHERE 학과코드 BETWEEN '002' AND '004'
GROUP BY 학과코드, 학과이름
ORDER BY 학과코드 ASC;

SELECT 학과코드, 학과이름
FROM view_성적일람표
GROUP BY 학과코드, 학과이름; -- view_성적일람표에 학과코드, 학과이름을 확인

SELECT 학과코드, 학과이름, COUNT(*) 학생수, MAX(총점) AS 최고점, MIN(총점) AS 최저점, SUM(총점), ROUND(AVG(평균), 1)
FROM view_성적일람표
GROUP BY 학과코드, 학과이름
ORDER BY 학과코드;

-- 통계집계, SUB Query, UNION
-- 제약조건 참조무결성 설정, 기존테이블에 제약조건을 추가