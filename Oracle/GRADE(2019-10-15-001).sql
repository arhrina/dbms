-- grade 유저

-- PK 지정 방법으로 컬럼에 지정하는 방법(표준SQL)과 CONSTRAINT로 추가하는 방법(표준SQL 지정방식이 안되는 DBMS)이 있다. 다수의 컬럼으로 PK를 지정할 때도 CONSTRAINT
CREATE TABLE tbl_score(
s_id	NUMBER		,
s_std	nVARCHAR2(50)	NOT NULL	,
s_subject	nVARCHAR2(50)	NOT NULL	,
s_score	NUMBER(3)	NOT NULL	,
s_rem	nVARCHAR2(50)		,
CONSTRAINT pk_score PRIMARY KEY(s_id)
);

-- 테이블에 엑셀데이터 임포트
SELECT COUNT(*) FROM tbl_score;

SELECT * FROM tbl_score;

-- 학생별로 총점, 평균 계산시 SUM, AVG. 학생데이터가 같은 레코드를 묶고(GROUP) 묶여진 그룹에서 총점과 평균을 계산
SELECT s_std, SUM(s_score) AS 총점, ROUND(AVG(s_score), 0) AS 평균
FROM tbl_score
GROUP BY s_std
ORDER BY s_std ASC;


-- 학생이름-과목-점수를 학생이름-국어-영어-수학-과학....으로 펼치기. 세로 데이터를 가로방향으로 펼치기. Pivot 데이터
-- 1. 저장된 과목명 확인
SELECT s_subject FROM tbl_score
GROUP BY s_subject
ORDER BY s_subject;

/*
과학
국사
국어
미술
수학
영어
*/
/*
성적테이블을 과목이름으로 컬럼을 만들어서 생성을 하면 데이터 추가, 단순 조회에는 편리하게 쓸 수 있지만
사용중에 과목이 추가되거나 과목명이 변경되는 경우엔 테이블 구조를 변경해야 하는 상황이 발생한다. 이러한 변경은 DBMS 입장이나 사용자 입장에서
많은 비용(사용중지 시간, 투입되는 노력, 데이터 손실의 위험성 등)을 지불해야하므로 테이블의 변경은 신중해야 한다

실제 데이터는 고정된 컬럼으로 생성된 테이블에 저장을 하고 VIEW로 확인시 PIVOT 방식으로 펼쳐보면 실제 컬럼이 존재하는 것처럼 사용할 수 있다
SELECT, VIEW는 실제데이터와 별개로 데이터를 사용할 수 있으며 가상의 데이터이므로 위험성을 현저히 낮춘다

즉, 전혀 새로운 데이터를 넣더라도 테이블 구조를 해치지 않을 수 있다
*/


SELECT s_std AS 학생,
SUM(DECODE(s_subject, '과학', s_score)) AS 과학,
SUM(DECODE(s_subject, '국사', s_score)) AS 국사,
SUM(DECODE(s_subject, '국어', s_score)) AS 국어,
SUM(DECODE(s_subject, '미술', s_score)) AS 미술,
SUM(DECODE(s_subject, '수학', s_score)) AS 수학,
SUM(DECODE(s_subject, '영어', s_score)) AS 영어
FROM tbl_score
-- WHERE s_std = '갈한수'
GROUP BY s_std
ORDER BY s_std;


-- oracle 11g 이후 사용하는 PIVOT 전용문법. SQL developer에서 명령수행에 제한이 있다
-- 메인인 from에 SUB QUERY를 사용해서 테이블을 지정해야한다
SELECT * FROM
(SELECT s_std, s_subject, s_score FROM tbl_score)
PIVOT(
SUM(s_score) -- 컬럼 이름별로 분리하여 표시할 데이터
FOR s_subject IN ( -- 묶어서 펼칠 컬럼 이름
'과학' AS 과학, -- 펼쳤을 때 보여질 컬럼 이름 목록
'국사' AS 국사,
'국어' AS 국어,
'미술' AS 미술,
'수학' AS 수학,
'영어' AS 영어
)
)
ORDER BY s_std;


CREATE VIEW view_score AS
(
SELECT s_std AS 학생,
SUM(DECODE(s_subject, '과학', s_score)) AS 과학,
SUM(DECODE(s_subject, '국사', s_score)) AS 국사,
SUM(DECODE(s_subject, '국어', s_score)) AS 국어,
SUM(DECODE(s_subject, '미술', s_score)) AS 미술,
SUM(DECODE(s_subject, '수학', s_score)) AS 수학,
SUM(DECODE(s_subject, '영어', s_score)) AS 영어,
SUM(s_score) AS 총점, ROUND(AVG(s_score), 0) AS 평균,
RANK() OVER (ORDER BY SUM(s_score) DESC) AS 석차
FROM tbl_score
-- WHERE s_std = '갈한수'
GROUP BY s_std
-- ORDER BY s_std
);

SELECT * FROM view_score 
ORDER BY 학생;