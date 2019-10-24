-- user3

CREATE TABLE tbl_score(
s_num	VARCHAR2(3)		PRIMARY KEY,
s_kor	NUMBER(3)		,
s_eng	NUMBER(3)		,
s_math	NUMBER(3)		
);
DESC tbl_score;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('001', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('002', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('003', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('004', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('005', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('006', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('007', 90, 80, 70);
INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES('008', 90, 80, 70);

SELECT * FROM tbl_score;

-- 성적의 총점, 평균
SELECT s_kor, s_eng, s_math,
s_kor + s_eng + s_math AS 총점,
(s_kor + s_eng + s_math) / 3 AS 평균
FROM tbl_score;

UPDATE tbl_score
SET s_kor = ROUND(DBMS_RANDOM.VALUE(50, 100), 0) , -- 50~100의 난수 하나 발생, 소수점을 제거(ROUND)
s_eng = ROUND(DBMS_RANDOM.VALUE(50, 100), 0) ,
s_math = ROUND(DBMS_RANDOM.VALUE(50, 100), 0) ;

SELECT * FROM tbl_score;

-- 값의 변경은 PK를 기준으로 하여야 무결성이 깨지지 않는다

SELECT s_kor, s_eng, s_math,
s_kor + s_eng + s_math AS 총점,
-- (s_kor + s_eng + s_math) / 3 AS 평균 -- 소수점이 무한대로 뻗어나오므로 ROUND함수를 이용해 소수점을 제어
ROUND((s_kor + s_eng + s_math) / 3, 0) AS 평균 
FROM tbl_score;

SELECT s_kor, s_eng, s_math,
s_kor + s_eng + s_math AS 총점,
ROUND((s_kor + s_eng + s_math) / 3, 0) AS 평균 
FROM tbl_score WHERE (s_kor + s_eng + s_math) / 3 >= 80; -- 평균이 80 이상

SELECT s_kor, s_eng, s_math,
s_kor + s_eng + s_math AS 총점,
ROUND((s_kor + s_eng + s_math) / 3, 0) AS 평균 
FROM tbl_score WHERE (s_kor + s_eng + s_math) / 3 BETWEEN 70 AND 80; -- 평균이 70-80

-- 통계집계 함수 SUM(), COUNT(), AVG(), MAX(), MIN() 교재 158p

SELECT SUM(s_kor) AS 국어총점, SUM(s_eng) AS 영어총점, SUM(s_math) AS 수학총점 FROM tbl_score;
SELECT SUM(s_kor) AS 국어총점, SUM(s_eng) AS 영어총점, SUM(s_math) AS 수학총점, SUM(s_kor+s_eng+s_math) AS 전체총점, ROUND(AVG(s_kor + s_eng + s_math)/3, 0) AS 전체평균 FROM tbl_score;
SELECT COUNT(*) FROM tbl_score;
SELECT COUNT(s_kor) FROM tbl_score;
SELECT MAX(s_eng) FROM tbl_score;
SELECT MIN(s_math) FROM tbl_score;
SELECT SUM(s_kor + s_eng + s_math) AS 총점,
ROUND(AVG(s_kor + s_eng + s_math)/3, 0) AS 평균, MAX(s_kor + s_eng + s_math) AS 최고점, MIN(s_kor + s_eng + s_math) AS 최저점 FROM tbl_score WHERE s_kor + s_eng + s_math >= 200;

SELECT SUM(s_kor) AS 국어총점, 
SUM(s_eng) AS 영어총점,
SUM(s_math) AS 수학총점,
ROUND(AVG(s_kor + s_eng + s_math), 0) AS 전체평균
FROM tbl_score WHERE ROUND(AVG(s_kor + s_eng + s_math), 0) >= 70;

SELECT s_num, (s_kor + s_eng + s_math) AS 총점,
RANK() OVER ( ORDER BY (s_kor + s_eng + s_math) DESC ) AS 석차 FROM tbl_score ORDER BY s_num;
-- OVER()를 기준으로 RANK(). s_kor + s_eng + s_math를 계산하고 내림차순(DESC)을 한 뒤 순서대로(ORDER BY)


SELECT s_num, (s_kor + s_eng + s_math) AS 총점,
DENSE_RANK() OVER ( ORDER BY (s_kor + s_eng + s_math) DESC ) AS 석차 FROM tbl_score ORDER BY s_num;
-- 중복된 값이 있으면 중복값 처리 시행


CREATE TABLE tbl_score2(
s_num	VARCHAR2(3)     PRIMARY KEY,
s_dept	VARCHAR2(3),
s_kor	NUMBER(3),
s_eng	NUMBER(3),
s_math	NUMBER(3)
);

CREATE TABLE tbl_dept(
d_num	VARCHAR2(3)		PRIMARY KEY,
d_name	nVARCHAR2(20)	NOT NULL	,
d_pro	VARCHAR2(3)		
);