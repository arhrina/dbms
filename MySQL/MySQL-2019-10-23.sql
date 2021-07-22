-- root 사용자로 로그인이 된 상태
-- MySQL에선 기본적으로 설치를 할 때 root 사용자가 활성화 된 상태이고
-- 일반적으로 MySQL Server가 원격에서 접속이 차단된 상태이므로
-- SQL 연습을 위해서 보통 그대로 사용한다

-- root 로그인 된 상태
-- Workbench에서 접속을 클릭하여 열어둔 화면
-- MySQL은 Schema 개념이 Database라는 것으로 집중되어있다
-- Oracle은 물리적 저장공간은 TableSpace로 설정이 되고 Data Schema는 사용자(User) ID를 생성함으로서 논리적으로 설정된다
-- MySQL은 root(사용자)가 Schema 개념이 아니라 Database가 물리적(내부), 논리적(개념) Schema를 같은 의미로 사용된다. 대부분의 DBMS는 DB를 스키마로 사용한다

/*
1. log-in(root)
2. 사용할 Database를 USE로 open(접속). 해당하는 DB로 작업하겠다는 의미

*/
-- 현재 사용가능한 DB를 확인하는 명령
SHOW databases;
-- 새로운 DB를 생성
CREATE DATABASE myDB_1;
USE myDB; -- 표준 SQL에 가깝다. 대부분의 DB에서 USE를 사용하여 DB를 open하여 사용한다
-- MySQL에서 DB는 사용자와의 연관성이 Oracle에 비해 느슨하다. 권한만 있다면 어떤 DB에도 접속할 수 있으며, 다양한 SQL을 수행할 수 있다

-- 현재 접속한 DB에 포함된 테이블을 확인
SHOW TABLES;


CREATE TABLE tbl_score(
s_id	INT(11)		PRIMARY KEY	AUTO_INCREMENT,
s_std	nVARCHAR(50)	NOT NULL		,
s_subject	nVARCHAR(50)	NOT NULL	,	
s_score	INT(3)	NOT NULL		,
s_rem	nVARCHAR(50)			
);

SHOW TABLES;
DESC tbl_score;
-- AUTO_INCREMENT로 지정된 컬럼은 PK로 지정되어 있지만 INSERT 시에 0의 값을 지정하면 자동으로 값을 생성해준다
INSERT INTO tbl_score(s_id, s_std, s_subject, s_score)
VALUES(0, '홍길동', '국어', 90);
INSERT INTO tbl_score(s_std, s_subject, s_score)
VALUES('홍길동', '수학', 80);
SELECT * FROM tbl_score;
INSERT INTO tbl_score(s_id,s_std, s_subject, s_score)
VALUES(2, '홍길동', '수학', 80); -- INT형 PK에 AUTO_INCREMENT가 지정되어 있더라도 0 이외의 값을 지정하면 지정한 값으로 저장하려고 시도한다
-- PK로 설정된 상태에서 중복값이 발생하여 INSERT 오류가 발생할 수 있다
-- AUTO_INCREMENT로 지정된 컬럼은 INT Type으로 지정을 해야하고, INSERT를 수행할 때 Projection으로 컬럼을 지정하지 않거나 0 값을 입력하여 수행해야한다

INSERT INTO tbl_score(s_id, s_std, s_subject, s_score)
VALUES(0, '홍길동', '영어', 80);
-- AUTO_INCREMENT는 PK값을 특정지어 저장하면 제일 큰값으로 카운트 기준이 바뀐다. 중간에 레코드를 삭제되더라도 기준은 바뀌지 않는다
-- 기본키는 삭제시 참조무결성을 설정하지 않으면 무결성이 깨질 염려가 있으므로 필요가 없더라도 삭제하지 않는 것이 좋으며, 삭제하게 된 경우에는 기존에 사용하던 값으로 기본키는 재활용하지 않는것이 좋다

DELETE FROM tbl_score
WHERE s_id >= 100;

INSERT INTO tbl_score(s_id, s_std, s_subject, s_score)
VALUES(0, '홍길동', '영어', 80);
SELECT * FROM tbl_score;
-- MySQL에선 ORDER BY를 사용하지 않고 SELECT를 수행하면 기본값으로 AUTO_INCREMENT가 설정된 PK순으로 정렬되어 보여준다. 오라클은 입력된 순서대로

-- ORDER BY. 많은 테이블을 조인하거나 서브쿼리를 사용하는 SQL을 작성할 때 가급적 ORDER BY는 최소한으로 사용하는 것이 좋다
-- SELECT 결과가 ORDER BY를 수행하는 과정에서 딜레이가 발생하는 경우가 있다
SELECT * FROM tbl_score WHERE s_std = '홍길동';

-- s_std로 그룹을 묶고 그룹의 합계를 표시
SELECT s_std, SUM(s_score) FROM tbl_score
GROUP BY s_std;

SELECT s_std, 
CASE WHEN s_subject = '국어' THEN s_score ELSE 0 END AS 국어,
CASE WHEN s_subject = '수학' THEN s_score ELSE 0 END AS 수학,
CASE WHEN s_subject = '과학' THEN s_score ELSE 0 END AS 과학
FROM tbl_score;
-- 표준 SQL문에 가깝다. CASE WHEN 조건이 TRUE면 THEN을 표기하고 아니면 ELSE를 표기한다
-- Oracle의 DECODE와 유사

SELECT s_std,
SUM(IF(s_subject = '국어', s_score, 0)) AS 국어,
SUM(IF(s_subject = '수학', s_score, 0)) AS 수학,
SUM(IF(s_subject = '과학', s_score, 0)) AS 과학,
SUM(s_score) AS 총점,
ROUND(AVG(s_score)) AS  평균 -- ROUND는 묶기만 하면 바로 정수로 만든다, ROUND(값, 자릿수) : 소수 이하 자릿수까지 표시 이하에서 반올림
-- TRUNCATE(값, 0) : 소수점 이하 컷. 버림
-- TRUNCATE(값, 1) : 소수점 이하 1자리까지 표기하고 이하 컷. 버림
FROM tbl_score
GROUP BY s_std;
SELECT * FROM tbl_score;

UPDATE tbl_score
SET s_score = 20
WHERE s_id = 3;

DELETE FROM tbl_score
WHERE s_id = 3;

-- UPDATE와 DELETE는 반드시 WHERE를 사용하여 PK나 1개의 레코드만을 대상으로 하자

CREATE TABLE tbl_score2(
s_id	INT(11)		PRIMARY KEY	AUTO_INCREMENT,
s_std	VARCHAR(5)	NOT NULL		,
s_subject	nVARCHAR(5)	NOT NULL		,
s_score	INT(3)	NOT NULL		,
s_rem	nVARCHAR(50)			
);

CREATE TABLE tbl_subject(
-- sb_code	INT		PRIMARY KEY	AUTO_INCREMENT, -- AUTO_INCREMENT가 붙으면 반드시 INT형만
sb_code VARCHAR(5) PRIMARY KEY, -- ALTER TABLE시 형전환을 할 때 대단히 주의해야하고, 오류가 발생할 수 있으므로 데이터가 없다면 지우고 다시 생성하는 것이 좋다
sb_name	nVARCHAR(20)	NOT NULL		,
sb_pro	nVARCHAR(20)			
);
DROP TABLE tbl_subject;

INSERT INTO tbl_score2(s_id, s_std, s_subject, s_score)
VALUES(0, 'S0001', 'B0001', 90);
INSERT INTO tbl_score2(s_id, s_std, s_subject, s_score)
VALUES(0, 'S0001', 'B0002', 80);
INSERT INTO tbl_score2(s_id, s_std, s_subject, s_score)
VALUES(0, 'S0001', 'B0003', 70);
INSERT INTO tbl_score2(s_id, s_std, s_subject, s_score)
VALUES(0, 'S0001', 'B0004', 66);

SELECT * FROM tbl_score2;

INSERT INTO tbl_subject(sb_code, sb_name)
VALUES('B0001', '국어');
INSERT INTO tbl_subject(sb_code, sb_name)
VALUES('B0002', '영어');
INSERT INTO tbl_subject(sb_code, sb_name)
VALUES('B0003', '수학');
INSERT INTO tbl_subject(sb_code, sb_name)
VALUES('B0004', '과학');
SELECT * FROM tbl_subject;

-- score와 subject table join
SELECT * FROM tbl_score2 AS SC, tbl_subject AS SB
WHERE SC.s_subject = SB.sb_code;

-- 테이블들의 컬럼이름이 중복(같은 컬럼이름이 존재)되지 않으면 projection을 나열할 때 Alias를 사용하지 않아도 된다
SELECT SC.s_id, s_std, s_subject, sb_name, s_score FROM tbl_score2 AS SC, tbl_subject AS SB
WHERE SC.s_subject = SB.sb_code;

-- LEFT JOIN은 TABLE간에 참조무결성이 보장되지 않을 경우,  EQ JOIN을 했을 때 레코드가 누락될 수 있는 경우에 사용
SELECT SC.s_id, s_std, s_subject, sb_name, s_score 
FROM tbl_score2 AS SC
LEFT JOIN tbl_subject AS SB
ON SC.s_subject = SB.sb_code;

CREATE VIEW view_score AS
(
SELECT SC.s_id AS id, s_std AS 학번, s_subject AS 과목코드, sb_name AS 과목명, s_score AS 점수 
FROM tbl_score2 AS SC
LEFT JOIN tbl_subject AS SB
ON SC.s_subject = SB.sb_code
);

SELECT * FROM view_score;

/*
VIEW
복잡한 SELECT 쿼리를 하나의 별도로 생성된 TABLE처럼 취급하기 위해 만드는 오브젝트
보기 전용이기 때문에 INSERT, UPDATE, DELETE 불가능
ALTER VIEW 불가능
*/

-- tbl_score와 tbl_subject간에 참조무결성 관계가 유지되고 있다. 이를 강제조항으로 설정하는 FK(Foreign Key) 제약조건
ALTER TABLE tbl_score2
ADD CONSTRAINT FK_SCORE_SUBJECT
FOREIGN KEY(s_subject)
REFERENCES tbl_subject(sb_code);

ALTER TABLE tbl_score2 MODIFY s_subject VARCHAR(5);
DESC tbl_score2;
DESC tbl_subject;
/*
MySQL FK 설정되는 컬럼에 제약조건이 있다
INT : NOT NULL DEFAUL = 0
문자열일 경우 NOT NULL
형이 같아야한다
*/


-- 설정된 FK로 테스트 수행