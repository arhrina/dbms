SELECT '대한' || '민국' FROM dual;
-- git hub에 프로젝트를 업로드할 때 불필요한 파일이나 비밀번호가 입력된 파일 등 업로드를 하지 않아야 될 파일들은
-- .git폴더에 .gitignore파일을 만들고 파일의 이름, 폴더 이름들을 기록해주면 된다
-- test.java를 입력하면 test.java파일은 업로드되지 않으며 data/ 라고 기록하면 git 폴더 아래 data 폴더 이하는 업로드되지 않는다
-- 최초 프로젝트를 업로드 할 때 .gitignore를 먼저 설정해주어야 하며 이미 업로드된 파일이나 폴더의 삭제는 까다롭다

-- tbl_student 테이블에 데이터를 추가하고, 조회하기

SELECT * FROM tbl_student;

-- 기존데이터를 삭제하고 추가하기

DELETE FROM tbl_student;

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0001', '홍길동', '서울특별시', '010-111-1234');

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0002', '이몽룡', '익산시', '010-222-1234');

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0003', '성춘향', '남원시', '010-333-1234');

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0004', '장길산', '충청남도', '010-444-1234');

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0005', '장보고', '해남군', '010-555-1234');
-- 데이터를 추가할 때 [table](Columns)와 VALUES(값리스트)는 개수와 순서가 일치해야한다
-- 개수가 일치하지 않으면 오류가 발생하고
-- 순서가 일치하지 않으면 원하지 않는 모양으로 데이터가 추가될 수 있다
INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0006', '임꺽정', '010-666-1234', '함경도');

SELECT * FROM tbl_student;
-- 조건 없이 모든 데이터를 보이라는 DML. 별다른 수단을 쓰지 않으면 데이터 값에 영향을 미치지 않으므로 데이터가 안전한 DML이다

SELECT st_num, st_name, st_addr, st_tel FROM tbl_student;
-- 학번, 이름, 주소, 전화번호 column만 보여라. SELECT columns FROM [table] 형식으로 사용

SELECT st_name, st_num, st_tel, st_addr FROM tbl_student;
-- 이름, 학번, 전화번호, 주소 순으로 column을 배치

SELECT st_num AS 학번, st_name AS 이름, st_tel AS 전화번호, st_addr AS 주소 FROM tbl_student;
-- 리스트를 조회할 때 원래의 column 이름대신 다른 별명을 사용. 표준 SQL문은 AS 별명으로 사용해야한다

SELECT st_num 학번, st_name 이름, st_tel 전화번호, st_addr 주소 FROM tbl_student;
-- 오라클 SQL문. AS를 붙이지 않아도 되는 경우. 가급적이면 표준SQL문으로 습관


-- 데이터리스트(row, record) 중 필요한 부분만 보고 싶은 경우의 SELECT문


-- tbl_student에 보관중인 데이터 중 st_name이 홍길동인 레코드만 조회
SELECT * FROM tbl_student WHERE st_name = '홍길동';
-- WHERE 조건절. 프로그래밍 언어에서 if와 같은 역할

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0007', '홍길동', '부산광역시', '010-777-1234');
-- 동명이인인 홍길동 데이터 추가

SELECT * FROM tbl_student WHERE st_name = '홍길동'; -- java식 표현 if(tbl_student.st_name == '홍길동') viewList;

SELECT st_num, st_name, st_tel FROM tbl_student WHERE st_name = '홍길동';

/*
아래 두 SELECT문은 동일한 결과를 보여주지만
칼럼리스트를 *로 사용하지 안호 필요한 칼럼만 나열해주는 것이 많은 양의 데이터를 조회하는데 있어 속도면에서 유리하다
조회해서 응용프로그램에서 값들을 사용하려고 위치(index) 값으로 추출할 때 정확히 원하는 위치값을 보장하여 오류를 줄일 수 있다
*/

SELECT * FROM tbl_student;
SELECT st_num, st_name, st_tel, st_addr, st_grade, st_dept, st_age FROM tbl_student;
-- projection : column들을 나열하는 것

-- 학생테이블에서 이름이 홍길동이고 주소가 서울특별시인 레코드를 조회. 다중조건 조회
-- 조건이 모두 TRUE인 레코드만. AND
SELECT * FROM tbl_student WHERE st_name = '홍길동' AND st_addr = '서울특별시';


-- 여러 조건중 하나라도 TRUE인 레코드 모두를 조회. OR
SELECT * FROM tbl_student WHERE st_name = '홍길동' OR st_name = '이몽룡';
SELECT * FROM tbl_student WHERE st_name = '홍길동' OR st_addr = '서울특별시';

-- 칼럼값들을 연결해서 하나의 문자열처럼 생각하는 레코드 생성
SELECT st_num || ' + ' || st_name || ' + ' || st_tel AS 칼럼 FROM tbl_student;

-- 문자열칼럼에 저장된 값의 일부분만 조건으로 설정하는 방법
-- 데이터 추가시에 주소에 서울특별시와 서울시라고 넣었다면 둘 다 한꺼번에 조회하기 위해 '서울' 문자열만으로 조회하여야 한다
-- 부분 문자열 조건 조회를 사용한다. keyword : LIKE. 퍼포먼스를 가장 많이 떨어뜨리는 키워드. INDEX등의 기법을 사용하여
-- 퍼포먼스를 높이려는 노력들이 허사로 돌아간다
SELECT * FROM tbl_student WHERE st_addr = '서울시'; -- 조회되지 않는다
SELECT * FROM tbl_student WHERE st_addr LIKE '서울%'; -- addr이 서울로 시작하는 값은 모두 조회된다
SELECT * FROM tbl_student WHERE st_addr LIKE '%시'; -- addr이 시로 끝나는 값은 모두 조회된다
SELECT * FROM tbl_student WHERE st_name LIKE '%길%'; -- 중간에 길이 들어가는 모든 name에 있는 레코드를 조회한다

SELECT * FROM tbl_student WHERE st_tel >= '010-111-0000' AND st_tel <= '010-333-9999';
-- SQL에서는 문자열에 일정한 길이를 갖고 있을 때 비교연산자(부등호)를 사용하여 값들을 비교할 수 있다



-- 학생데이터를 조회하고 싶은데 학번이 3~6사이에 있었던거 같다면 문자열이지만
-- 저장된 구조가 5글자로 일정하므로 비교연산자를 사용해 데이터를 조회해볼 수 있다
SELECT * FROM tbl_student WHERE st_num >= 'A0003' AND st_num <= 'A0006';

-- 어떤 범위 내에 있는 데이터 레코드들을 보고자 할 때
-- Ex 학번이 A0003~A0006까지 보고자 할 때.
SELECT * FROM tbl_student WHERE st_num BETWEEN 'A0003' AND 'A0006';

SELECT * FROM tbl_student;

SELECT * FROM tbl_student WHERE st_addr IN ('익산시', '남원시', '해남군');

-- 찾고자 하는 데이터의 학번을 알고 있다면
SELECT * FROM tbl_student WHERE st_num = 'A0001';
-- 개체무결성 : 기본키(PK)로 자료를 조회하면 해당 레코드는 1개거나 NULL이다.
-- 데이터를 추가할 때 PK는 절대 중복된 데이터가 없어야하며 비어있어선(null) 안된다

-- INSERT를 하면 DBMS의 임의장소에 보관하며 물리저장소에는 데이터를 저장하지 않은 상태가 된다
-- DCL(TCL, Transaction Control Language)을 사용해 commit해줘야 물리저장소에 저장된다

COMMIT;

SELECT * FROM tbl_student;