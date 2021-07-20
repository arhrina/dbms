-- grade

/* DB이론에 있는 정규화
테이블을 어떻게 만들것인지를 고민해야한다

1개의 셀에 데이터를 집어넣는 엑셀 특성상 여러개의 자료가 들어있는 경우가 현실
홍길동 3 컴공 낚시,등산,독서

셀을 분리하여 데이터를 각각 분리하면 낭비되는 컬럼이 있거나 누락되는 데이터가 존재할 수 있다(가변적인 데이터일 경우)
홍길동 3 컴공 낚시  등산  독서

다른 방식으로 분리한다
홍길동 3 컴공 낚시
홍길동 3 컴공 등산
홍길동 3 컴공 독서

제1정규화가 수행된 TABLE 스키마


테이블의 고정되어있는 값을 다른 테이블로 분리하고 테이블간 JOIN을 통해 VIEW를 생성하도록 구조적 변경. 제2정규화
최소 제2정규화까진 이루어져야 좋은 데이터베이스로 볼 수 있다

홍길동 3 001 001
홍길동 3 001 002
홍길동 3 001 003
성춘향 2 002 003

001 낚시
002 등산
003 독서

001 컴공
002 정보
*/

DESC tbl_score;

/*
S_ID      NOT NULL NUMBER        
S_STD     NOT NULL NVARCHAR2(50) 
S_SUBJECT NOT NULL NVARCHAR2(50) 
S_SCORE   NOT NULL NUMBER(3)     
S_REM              NVARCHAR2(50) 

과목 subject를 제2정규화 수행
*/

-- tbl_score에서 과목명 확인
SELECT s_subject FROM tbl_score 
GROUP BY s_subject;
-- 확인한 과목으로 엑셀 작업

-- tbl_score에서 추출한 과목명을 저장할 테이블 생성
CREATE TABLE tbl_subject(
sb_code	VARCHAR2(4)		PRIMARY KEY,
sb_name	nVARCHAR2(20)	NOT NULL	,
sb_pro	nVARCHAR2(20)		
);
-- 엑셀데이터 임포트

-- tbl_score에서 tbl_subject 테이블 데이터를 생성. 생성된 tbl_subject하고 tbl_score하고 연결되는지 테스트
SELECT * FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_name;

-- 두 카운트가 동일하면 잘 일치됨
SELECT COUNT(*) FROM tbl_score;
SELECT COUNT(*) FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_name;

-- tbl_score의 s_subject 컬럼에 있는 과목명을 tbl_subject에 있는 코드로 변경
-- 1. 임시로 컬럼을 하나 추가
ALTER TABLE tbl_score ADD s_sbcode VARCHAR2(4);

SELECT * FROM tbl_score;

UPDATE tbl_score SC
SET s_sbcode = (SELECT sb_code FROM tbl_subject SB WHERE SC.s_subject = SB.sb_name); -- SubQ를 이용한 업데이트. UPDATE에 where가 없다 => 전부 교체
-- tbl_subject에 과목명을 조회해서 tbl_score의 과목명이랑 비교하고 해당 과목코드를 tbl_score의 s_sbcode에 입력하는 명령

SELECT SC.s_sbcode, SB.sb_code, SC.s_subject, SB.sb_name FROM tbl_score SC, tbl_subject SB
WHERE SC.s_sbcode = SB.sb_code; -- 다른 값이 있거나 누락된 값이 있으면 잘못 입력된 것임을 확인하는 코드

-- tbl_score에 있는 s_subject 컬럼을 삭제
ALTER TABLE tbl_score DROP COLUMN s_subject;

-- tbl_score에 s_sbcode를 s_subject로 컬럼이름 변경
ALTER TABLE tbl_score RENAME COLUMN s_sbcode TO s_subject;
DESC tbl_score;
/*
이름        널?       유형            
--------- -------- ------------- 
S_ID      NOT NULL NUMBER        
S_STD     NOT NULL NVARCHAR2(50) 
S_SCORE   NOT NULL NUMBER(3)     
S_REM              NVARCHAR2(50) 
S_SUBJECT          VARCHAR2(4)   
*/

-- 제2정규화 완료
SELECT * FROM tbl_score;

-- JOIN
SELECT s_std, s_subject, SB.sb_name, SB.sb_pro s_score FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_code;


-- TABLE을 JOIN 할때 TABLE들에 칼럼 이름이 같은 이름이 존재하면
-- 반드시 칼럼이 어떤 TABLE에 있는 칼럼인지 명시를 해 주어야
-- 문법적 오류가 발생하지 않는다.
-- 그래서 TABLE을 설계할때 가급적 접두사를 붙여서 만드는 것이 좋고
-- 그렇더라도 JOIN을 할때 TABLE alias를 설정하여
-- alias.Column 형식으로 작성하는 것이 좋다.
/*
Table1 : num, name, addr, dept 
Table2 : num, subject, pro

SELECT *
FROM Table1, tabl2
    WHERE dept = num
라는 형식으로 SQL을 작성하면 num이 누구의 Table인지 알수 없어서
문법적 오류가 발생한다

SELECT T1.num AS 학번, T1.name, T1.addr, T1.dept,
        T2.num AS 과목코드, T2.subject, T2.pro
FROM Table1 T1, Tabld2 T2
    WHERE T1.dept = T1.num
    
와 같은 형식으로 SQL을 작성하는 것이 만약의 오류를 줄일수 있다.    
*/
SELECT s_id, s_std, s_subject, s_score, s_rem 
FROM tbl_score ;

SELECT *
FROM tbl_score 
WHERE s_id > 600;

DELETE
FROM tbl_score
WHERE s_id > 600;
COMMIT ;




    





