-- user4 화면

/*
테이블 생성

이름 : tbl_books
컬럼 : 
    코드  b_code  VARCHAR(4)
    이름  b_name  VARCHAR(50)
    출판사 b_comp  VARCHAR(50)
    저자  b_writer    VARCHAR(20)
    가격  b_price INT

*/

-- TABLE 생성시엔 항상 기본키를 어디에 줄지
/*
요구사항
도서정보를 추가하는데 isbn과 별도로, 자체적으로 일련번호를 부여하여 관리를 하겠다
1 ~ n의 숫자를 입력순서대로 번호를 부여

요구사항2
기존에 입력된 번호와 다른 새로운 번호를 사용해서 데이터를 입력

요구사항3
데이터를 입력할 때 일련번호를 기억하기 싫다
항상 새로운 번호로 일련번호를 생성하여 데이터를 추가할 수 있도록

요구사항4
입력된 데이터 중에서 b_price는 숫자값인데, NULL값이 추가되는 경우 프로그래밍 언어에서 데이터를 가져다 사용할 때 문제를 일으킬 수 있다
가격 칼럼에 값이 없이 추가되면 자동으로 0을 채우도록 해야 오류를 방지할 수 있다. DEFAULT 키워드 사용
*/

CREATE TABLE tbl_books (
b_code VARCHAR2(4) PRIMARY KEY,
b_name nVARCHAR2(50) NOT NULL,
b_comp nVARCHAR2(50),
b_writer nVARCHAR2(20),
b_price NUMBER DEFAULT 0 -- INSERT 수행시 값이 없으면 NULL 대신 0 입력
);

INSERT INTO tbl_books(b_code, b_name, b_comp, b_writer)
VALUES(1, '자바입문', '이지퍼블', '박은종');

SELECT * FROM tbl_books;

INSERT INTO tbl_books -- (b_code, b_name, b_comp, b_writer) 컬럼들을 입력하지 않으면 테이블을 만들 때 넣은 순서대로 데이터를 나열해서 추가. 모든 컬럼을 추가시켜야한다
-- 테이블의 컬럼 순서가 정확하다는 보장이 있고 모든 컬럼에 데이터가 있다 라는 보장이 있을 때는 INSERT 명령문에 projection(컬럼을 리스트하는 것)을 하지 않아도
-- 데이터만 정확히 나열하여 명령을 수행할 수 있다. 하지만 프로젝션하여 값을 넣는 것이 좋다
VALUES(2, '오라클', '생능', '서진수', 35000);
SELECT * FROM tbl_books;

/*
데이터를 추가할 때마다 b_code 컬럼의 값을 새로 생성하는 방법.

자바 Random을 사용하는 방법(일련번호가 아닌 뒤죽박죽된 숫자. 컴퓨터의 랜덤값은 완전한 랜덤이 아니기 때문에 중복값이 나타날 수도 있음)
일련번호를 순서대로 자동생성되도록 컬럼을 설정(Oracle 11 이하에선 불가능, mysql, mssql, oracle 12 이상 등에선 AUTO INCREAMENT 옵션을 부여하면 가능)
일련번호를 AUTO INCREMENT PK로 설정하는 경우 일련번호는 추가된 순서가 된다
RANDOM을 사용하면 그러한 조건을 만들 수 없다

AUTO INCREMENT가 없는 오라클 11 이하에서는 SEQUENCE 객체(Object)를 사용하여 AUTO INCREMENT를 대체한다
오라클에서 가장 많이 사용하는 일련번호 부여 방식
*/

INSERT INTO tbl_books(b_code, b_name)
VALUES( ROUND(DBMS_RANDOM.VALUE(1000000000, 9999999999), 0), '연습도서'); -- 시작값, 끝값까지의 범위 내에서 실수형 난수를 발생

CREATE SEQUENCE SEQ_BOOKS
START WITH 1 INCREMENT BY 1; -- 1부터(START WITH 1) 1씩 증가하는 형태(INCREMENT BY 1)로 숫자를 생성하는 SEQUENCE 객체 SEQ_BOOK를 생성

SELECT SEQ_BOOKS.NEXTVAL FROM DUAL;
INSERT INTO tbl_books(b_code, b_name)
VALUES(SEQ_BOOKS.NEXTVAL, '시퀀스 연습');
SELECT * FROM tbl_books;


-- 기존에 생성된 테이블에 SEQUENCE 적용하기
/*
매입매출에서 tbl_iolist에 데이터를 추가하면서
EXCEL SPREAD SHEET로 데이터를 정리하고 SEQ 컬럼을 만든 다음
일련번호를 추가해 두었다
새로 만든 App에서 데이터를 추가할 때 SEQ를 사용하고자 한다

1. 기존 데이터의 SEQ 컬럼에 최대값이 얼마인지 확인 : 589
2. 새로운 SEQ를 생성할 때 START WITH (VALUE)를 기존 SEQ 컬럼의 값보다 큰 값으로 설정
*/
CREATE SEQUENCE SEQ_IOLIST
START WITH 1 INCREMENT BY 1;

-- 실수로 시작값을 잘못설정했을 경우 ALTER SEQUENCE [SEQ]
ALTER SEQUENCE SEQ_IOLIST INCREMENT BY 600; -- 증가값을 최대값보다 큰 값으로 설정하고
SELECT SEQ_IOLIST.NEXTVAL FROM DUAL; -- 1회 실행하고
ALTER SEQUENCE SEQ_IOLIST INCREMENT BY 1; -- 다시 증가값을 1로 설정
-- 아니면 DROP하고 다시 시작값을 세팅


SELECT SEQ_IOLIST.CURRVAL FROM DUAL; -- 현재 시퀀스의 값을 확인. 간혹 실제값이 아닌 값을 알려주는 경우도 있다

/*
테이블에 특정할 수 있는 PK가 있는 경우는 해당하는 값을 INSERT 수행하면서 입력하는 것이 좋고
그렇지 못한 경우는 SEQUENCE를 사용하여 일련번호 형식으로 지정하자
*/

DROP TABLE tbl_books;

CREATE TABLE tbl_books (
b_code VARCHAR2(5) PRIMARY KEY,
b_name nVARCHAR2(50) NOT NULL,
b_comp nVARCHAR2(50),
b_writer nVARCHAR2(20),
b_price NUMBER DEFAULT 0 -- INSERT 수행시 값이 없으면 NULL 대신 0 입력
);
-- b_code : B0001 생성하기. 이 방식은 ORACLE에선 간단하다. 다른 DBMS에선 복잡한 방법
INSERT INTO tbl_books(b_code, b_name) -- ||은 오라클에서 문자열 연결기호
VALUES( 'B' || TRIM(TO_CHAR(SEQ_BOOKS.NEXTVAL, '0000')), '시퀀스 연습');
-- TRIM(). 문자열 앞 뒤를 삭제. 중간공백은 제거불가
-- LTRIM(), RTRIM(). 문자열 앞, 문자열 뒤를 삭제. DBMS에 따라 같은 것으로 쓰일 수 있다
-- TO_CHAR(값, 포맷형)
-- TO_CHAR(숫자, '0000') 자리수를 4개로 설정하고 공백부분을 0으로
-- TO_CHAR(숫자, '9999') 자리수를 4개로 설정하고 공백부분은 없이
SELECT * FROM tbl_books;

/*
오라클의 고정길이 문자열 생성


원래값이 숫자형인 경우
TO_CHAR(값, 포맷형)

원래값이 다양한 형
LPAD(값, 총길이, 채움문자)
RPAD(값, 총길이, 채움문자)
*/

-- LPAD. 왼쪽부터 총 길이를 10개로 하고 남는 부분은 *로 채워서 문자열 생성하는 예시
SELECT LPAD(30, 10, '*') FROM dual;

-- RPAD. 오른쪽부터 총 길이를 10개로 하고 남는 부분은 A로 채워서 문자열 생성하는 예시
SELECT RPAD(30, 10, 'A') FROM dual;


SELECT 'B' || LPAD(SEQ_BOOKS.NEXTVAL, 4, '0') FROM dual;
SELECT RPAD('우리', 20, ' ') FROM DUAL;