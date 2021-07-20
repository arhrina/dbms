-- user3
-- TABLE 구조를 조회
DESC tbl_student;

-- tbl_student 테이블을 테스트하는데 원본을 손상하지 않고 테스트를 수행하기 위해 테이블을 복제

CREATE TABLE tbl_test_std AS SELECT * FROM tbl_student;


DESC tbl_student;
/*
이름       널?       유형             
-------- -------- -------------- 
ST_NUM   NOT NULL VARCHAR2(3)                       PK : NOT NULL + UNIQUE
ST_NAME  NOT NULL NVARCHAR2(50)  
ST_TEL            VARCHAR2(20)   
ST_ADDR           NVARCHAR2(125) 
ST_GRADE          NUMBER(1)      
ST_DEPT           VARCHAR2(3)    
*/

DESC tbl_test_std;

/*
이름       널?       유형             
-------- -------- -------------- 
ST_NUM            VARCHAR2(3)                       제약조건으로 설정한 부분이 상당부분 삭제되어있다
ST_NAME  NOT NULL NVARCHAR2(50)  
ST_TEL            VARCHAR2(20)   
ST_ADDR           NVARCHAR2(125) 
ST_GRADE          NUMBER(1)      
ST_DEPT           VARCHAR2(3)    

테스트를 위해 테이블을 복제했는데 PK같은 제약조건들은 복제되지 않았다
제약조건을 추가한다
*/

-- TABLE을 새로 작성하지 않고 제약조건들만 추가하는 방법

-- 1. NOT NULL
ALTER TABLE tbl_test_std MODIFY (st_num nVARCHAR2(3) NOT NULL); -- NOT NULL은 이미 컬럼에 NULL 레코드가 있으면 이 명령은 오류를 발생한다. 값이 없는 레코드에 UPDTAE하여 값을 채우고 실행해야한다
-- 2. UNIQUE
ALTER TABLE tbl_test_std ADD UNIQUE(st_num); -- 컬럼에 중복된 값이 있다면 오류를 낸다
-- 3. PK
ALTER TABLE tbl_test_std ADD CONSTRAINT KEY_st_num PRIMARY KEY(st_num); -- 제약조건으로 기본키를 추가하는 명령어. UNIQUE가 이미 되어있다면 오류를 출력한다. UNIQUE를 삭제하고 실행해야한다
-- DBMS에 따라 이름을 지정하지 않으면 실행이 안되는 경우가 있으므로 ALTER TABLE을 이용해 PK를 추가할 때는 가급적 이름을 지정해주는 것이 좋다
-- 위의 명령문은 tbl_test_std TABLE에 KEY_st_num이라는 이름으로 st_num 컬럼을 pk로 설정하는 SQL이다

-- 경우에 따라 PK를 다중컬럼으로 설정하는 경우도 있다
-- ALTER TABLE tbl_test_std ADD CONSTRAINT KEY_st_name_tel PRIMARY KEY(st_name, st_tel). 이름과 전화번호를 한쌍으로 PK로 사용한다

-- 4. CHECK 제약조건
-- 데이터를 추가할 때 컬럼에 저장되는 데이터를 제한하고자 할 때 쓰이는 제약조건

ALTER TABLE tbl_test_std ADD CONSTRAINT st_grade_check CHECK (st_grade BETWEEN 1 AND 4); -- st_grade의 값은 1~4인 숫자만 저장되어야 한다는 제약조건을 지정하고 제약조건의 이름을 st_grade_check로
-- CONSTRAINT name을 사용하여 이름을 지정하는 이유는 나중에 조건이 필요없어져서 삭제할 때 이름을 사용해 삭제하기 위해서이다

-- 예시. 남, 여만 입력하는 제약조건을 거는 방법 ALTER TABLE tbl_test_std ADD CONSTRAINT st_gender_check CHECK (st_gender IN ('남', '여'));

ALTER TABLE tbl_test_std DROP UNIQUE(st_num); -- UNIQUE 제약조건 삭제
ALTER TABLE tbl_test_std DROP CONSTRAINT st_grade_check CASCADE; -- CHECK 제약조건 삭제. 이름으로 등록된 제약조건과 연관된 설정을 삭제
-- CASCADE : 연관된 모든 설정

-- 5. 참조무결성 설정
ALTER TABLE tbl_score2 ADD CONSTRAINT fk_std_score2 FOREIGN KEY (s_num) REFERENCES tbl_test_std(st_num);
-- ALTER TABLE tbl_score2 MODIFY (s_num VARCHAR2(3));
/*
tbl_score2 데이터를 추가하거나 학번을 변경할 때 tbl_test_std를 참조하여 학번(s_num, st_num)의 관계를 명확히하여 EQ JOIN을 실행했을 때, 결과가 신뢰성을 보장해주는
제약조건을 설정

참조무결성
tbl_score2에 s_num이 있으면 tbl_test_std에 st_num은 반드시 있다. 역은 성립하지 않으며 대우는 성립한다
*/