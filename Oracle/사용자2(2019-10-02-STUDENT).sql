-- user2
-- 학생정보를 저장할 table 생성. 테이블 구조 엑셀파일 참조, 엑셀 데이터를 복사해와서 ctrl v로 생성. 각 줄 끝에 콤마 넣고 코드 정리

CREATE TABLE tbl_student(
    st_num	VARCHAR2(5)	PRIMARY KEY,
    st_name	nVARCHAR2(30)	NOT NULL,
    st_addr	nVARCHAR2(125),
    st_grade	NUMBER(1),
    st_height	NUMBER(3),
    st_weight	NUMBER(3),
    st_nick	nVARCHAR2(20),
    st_nick_rem	nVARCHAR2(50),	
    st_dep_no	CHAR(3)	NOT NULL
);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0001', '홍길동', '001', 3);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0002', '이몽룡', '001', 2);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0003', '성춘향', '002', 1);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0004', '임꺽정', '003', 4);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0005', '장보고', '003', 2);

SELECT * FROM tbl_student;

-- 이름순 정렬
SELECT * FROM tbl_student ORDER BY st_name;

-- 학번 2번부터 4번까지인 레코드만
SELECT * FROM tbl_student WHERE st_num >= 'A0002' AND st_num <= 'A0004';
SELECT * FROM tbl_student WHERE st_num BETWEEN 'A0002' AND 'A0004';

-- grade가 2인 레코드만
SELECT * FROM tbl_student WHERE st_grade = 2; -- 숫자 2와 문자 2인 경우를 모두 찾아버린다. SQL 특징

-- 학번 2~4 레코드를 이름순으로
SELECT * FROM tbl_student WHERE st_num BETWEEN 'A0002' AND 'A0004' ORDER BY st_name;

-- 학번이 2~4인 레코드를 고학년부터
SELECT * FROM tbl_student WHERE st_num BETWEEN 'A0002' AND 'A0004' ORDER BY st_grade DESC;

-- SQL 함수 교재 158p
-- tbl_student의 테이블에 저장된 데이터 레코드의 개수 확인
SELECT COUNT(*) FROM tbl_student;
-- tbl_student의 테이블에 저장된 데이터 레코드 중 2학년의 개수 확인
SELECT COUNT(*) FROM tbl_student WHERE st_grade = 2;
-- tbl_student의 테이블에 저장된 데이터 레코드 중 가장 고학년은 몇학년
SELECT MAX(st_grade) FROM tbl_student;
-- tbl_student의 테이블에 저장된 데이터 레코드 중 가장 저학년은 몇학년
SELECT MIN(st_grade) FROM tbl_student;
-- tbl_student의 테이블에 저장된 데이터 레코드들의 학년을 다 더하면
SELECT SUM(st_grade) FROM tbl_student;
-- tbl_student의 테이블에 저장된 데이터 레코드들의 학년의 평균
SELECT AVG(st_grade) FROM tbl_student;

SELECT 30 + 40 FROM dual; -- 오라클 이외에 다른 DBMS에선 간단한 연산 등을 수행할 때 SELECT 연산형식으로 사용됨(FROM 없이). 오라클에선 FROM dual이라는 무의미한 코드를 붙여야함
SELECT * FROM dual; -- 1개의 레코드와 column을 가진 연산을 위한 DUMMY 데이터
SELECT 30 * 40 FROM tbl_student; -- 레코드 수만큼

-- 레코드 셋(Record Set, Result Set) SELECT 명령이 실행된 후 console에 보여지는 리스트
SELECT * FROM tbl_student;

-- NULL인 성춘향의 addr를 광주광역시로, 이몽룡 addr을 익산시로, 홍길동 addr을 서울특별시로. 이미 있는 레코드의 특정 칼럼을 입력하고자 할 때는 UPDATE
UPDATE tbl_student SET st_addr = '광주광역시' WHERE st_name = '성춘향';
UPDATE tbl_student SET st_addr = '익산시' WHERE st_name = '이몽룡';
UPDATE tbl_student SET st_addr = '서울특별시' WHERE st_name = '홍길동';
-- PK가 아닌 값을 참조해서 UPDATE했다. st_name에 같은 값이 있다면 모든 값들이 변경되어 DB의 무결성이 훼손된다

SELECT * FROM tbl_student;

INSERT INTO tbl_student (st_num, st_name, st_grade, st_dep_no)
VALUES('A0006', '성춘향', 2, '001');
SELECT * FROM tbl_student;

UPDATE tbl_student SET st_addr = NULL WHERE st_name = '성춘향' AND st_grade = 2;
SELECT * FROM tbl_student;

INSERT INTO tbl_student (st_num, st_name, st_grade, st_dep_no)
VALUES('A0007', '성춘향', 1, '001');
SELECT * FROM tbl_student;

UPDATE tbl_student SET st_addr = '광주광역시' WHERE st_name = '성춘향' AND st_grade = 1 AND st_dep_no = '002';
SELECT * FROM tbl_student;

/* DATA 추가를 마치고 각각의 addr을 업데이트하려고 한다. 학생들의 이름으로 조회를 하여 업데이트를 하니
1. 동명이인이 다수 있다
이름과 학년으로 조회
2. 이름과 학년이 같은 학생이 다수 존재
이름과 학년, 학과로 조회
3. 세 칼럼 모두 같은 레코드가 다수 존재

데이터의 신뢰도 유지를 위해(DB 객체무결성 보장) UPDATE를 수행하고자 할 때는 테이블의 PK로 설정된 학번 칼럼을 기준으로 해야만한다
*/
