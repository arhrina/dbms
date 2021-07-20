-- user3 화면

-- 도서정보를 저장하기 위한 TABLE 생성

CREATE TABLE tbl_books(
    b_isbn	VARCHAR2(13)		PRIMARY KEY,
    b_title	nVARCHAR2(50)	NOT NULL	,
    b_comp	nVARCHAR2(50)	NOT NULL	,
    b_writer	nVARCHAR2(50)	NOT NULL,	
    b_price	NUMBER(5)		,
    b_year	VARCHAR2(10)	,	
    b_genre	VARCHAR2(3)		

);

-- 도서정보 추가
INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-001', '오라클 프로그래밍', '생능출판사', '서진수', 30000);

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-002', 'Do it 자바', '이지퍼블리싱', '박은종', 25000);

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-003', 'SQL 활용', '교육부', '교육부', 10000);

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-004', '무궁화꽃이 피었습니다', '새움', '김진명', 15000);

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-005', '직지', '쌤앤파커스', '김진명', 12600);

SELECT * FROM tbl_books;
SELECT * FROM tbl_books ORDER BY b_isbn ASC;

/* tbl_books 테이블에 price가 자리수가 모자라서 수정. 자료 추가 전이라면 삭제하고 수정하여 생성하면 되지만 데이터가 추가되어 있는 상황에선
테이블을 삭제하면 들어있는 데이터가 소실되므로 테이블을 유지하면서 price의 구조만 DDL로 수정 */

/*
DDL의 3개 키워드
CREATE 생성
DROP 삭제
ALTER 수정(변경)
*/

-- 이미 생성된 table의 column 하나를 수정하는 상황
ALTER TABLE tbl_books MODIFY(b_price NUMBER(7)); -- tbl_books에 있는 b_price를 NUMBER 7개로 modify

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('978-801', 'effective java', 'Addison', 'Joshua Bloch', '159000');

SELECT * FROM tbl_books;

-- 테이블 생성 당시 생각지 못한 칼럼이 필요한 경우가 있다
-- 이미 생성된 테이블에 새로운 칼럼 추가

ALTER TABLE tbl_books ADD(b_remark nVARCHAR2(125));

DESC tbl_books;

-- 기존 칼럼 삭제
ALTER TABLE tbl_books DROP COLUMN b_remark;
-- 칼럼 이름변경
ALTER TABLE tbl_books RENAME COLUMN b_remark TO b_rem;

/*
ALTER TABLE 수행시 주의사항

DROP COLUMN, 기존 사용하던 테이블에서 특정 칼럼을 삭제하면 저장된 데이터가 변형되어 문제가 발생할 수 있다
오라클은 명령 수행전에 절대 경고하지 않는다

MODIFY COLUMN, 칼럼의 타입을 변경하는 것으로 저장된 데이터가 변형될 수 있다
가. 자릿수를 줄이면 (보통) 실행오류가 발생. 실행오류가 발생하지 않으면 저장된 데이터의 일부가 잘릴 수 있다
나. 기존 데이터 형식이 변경되면서 데이터가 손실, 소실될 수 있다.
특히, CHAR와 VARCHAR2 사이에서 데이터 타입을 변경하면 SQL(SELECT) 결과가 엉뚱하게 나타나거나 데이터를 못찾을 수 있다

RENAME COLUMN, 칼럼의 이름을 변경하는 것은 데이터 변형이 잘 되지는 않지만 다른 SQL 명령문이나, 내장 프로시져, Java 프로그래밍에서 table에 접근하여
CRUD를 실행할 때 문제가 발생할 수 있다

테이블을 생성하거나 칼럼을 추가한 후에는 필요없더라도 다른 문제가 없으면 DROP, MODIFY 등을 수행하지 않는 것이 안전하다

*/

-- 사용자의 비밀번호 변경하기
-- 사용자 비밀번호는 보통 자신의 비밀번호를 변경하고, (SYS)DBA 역할에서는 다른 USER의 비밀번호를 변경하기도 한다
ALTER USER user3 IDENTIFIED BY 1234;

CREATE TABLE tbl_genre(
    g_code	VARCHAR(3)		PRIMARY KEY,
    g_name	nVARCHAR2(15)	NOT NULL	,
    g_remark	nVARCHAR2(125)		
);

INSERT INTO tbl_genre(g_code, g_name)
VALUES('001', '프로그래밍');

INSERT INTO tbl_genre(g_code, g_name)
VALUES('002', '데이터베이스');

INSERT INTO tbl_genre(g_code, g_name)
VALUES('003', '장편소설');

ALTER TABLE tbl_genre MODIFY g_name nVARCHAR2(50);

SELECT * FROM tbl_genre;
DESC tbl_books;
ALTER TABLE tbl_books MODIFY b_genre nVARCHAR2(10);

-- BOOK TABLE에 추가된 DATA들의 genre가 비어있는 상태. genre를 채운다
UPDATE tbl_books SET b_genre = '데이터베이스' WHERE b_isbn = '979-001';
UPDATE tbl_books SET b_genre = '데이터베이스' WHERE b_isbn = '979-003';
UPDATE tbl_books SET b_genre = '장편소설' WHERE b_isbn = '979-004';
-- UPDATE를 실행할 때 2개 이상의 레코드에 영향을 미치는 명령은 특별한 경우가 아니면 지양. PK를 확인하고 WHERE에 PK를 조건으로 걸어 사용

UPDATE tbl_books SET b_genre = '프로그래밍' WHERE b_isbn = '979-002';
UPDATE tbl_books SET b_genre = '장편소설' WHERE b_isbn = '979-005';
UPDATE tbl_books SET b_genre = '프로그래밍' WHERE b_isbn = '978-801';

SELECT * FROM tbl_books;
SELECT * FROM tbl_books WHERE b_genre = '데이터베이스';
SELECT * FROM tbl_books WHERE b_genre = '장편소설';

UPDATE tbl_books SET b_genre = '장르소설' WHERE b_genre = '장편소설';
INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price, b_genre)
VALUES('979-006', '황태자비 납치사건', '새움', '김진명',  25000, '장르 소설');

SELECT * FROM tbl_books WHERE b_genre = '장르소설';

-- 도서정보 데이터를 저장하기 위해 table을 만들고 많은 도서를 여러사람들이 입력한다면 일부 데이터에 빈칸 등이 잘못 삽입되어 데이터를 조회할 때 문제가 발생
-- 이름은 같은데 데이터는 조회되지 않은 현상. 이러한 논리적 문제를 해결하기 위해 'genre table'을 별도로 생성하고 books table을 정규화하여 오류를 제거

SELECT * FROM tbl_genre;
-- books table column에 저장된 문자열을 tbl_genre 의 코드값으로 변경
UPDATE tbl_books SET b_genre = '002' WHERE b_genre = '데이터베이스';
UPDATE tbl_books SET b_genre = '001' WHERE b_genre = '프로그래밍';
UPDATE tbl_books SET b_genre = '003' WHERE b_genre = '장르소설';
SELECT * FROM tbl_books;
SELECT * FROM tbl_genre;

-- 도서정보에 장르코드 대신 장르 이름으로 보고 싶다
/*
TABLE의 JOIN

2개 이상의 테이블을 서로 연계해서 하나의 리스트로 보여주는 것
Realationship. 관계
*/
SELECT * FROM tbl_books, tbl_genre WHERE tbl_books.b_genre = tbl_genre.g_code;

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, -- tbl_books.b_genre,
tbl_genre.g_code, tbl_genre.g_name
FROM tbl_books, tbl_genre WHERE tbl_books.b_genre = tbl_genre.g_code;

SELECT B.b_isbn, B.b_title, B.b_comp, B.b_writer, -- tbl_books.b_genre,
G.g_code, G.g_name
FROM tbl_books B, tbl_genre G WHERE B.b_genre = G.g_code; -- ANSI FROM tbl_books AS B

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_genre)
VALUES ('979-007', '자바의 정석', '도올출판', '남궁성', '004');

SELECT * FROM tbl_books;

SELECT * FROM [table1] , [table2] WHERE table1.col = table2.col; -- 완전 join이라고 하며 결과를 카티션 곱이라고 한다
-- table1과 table2를 Relation할 때 서로 연결하는 칼럼의 값이 두 테이블에 모두 존재할 때만 정상적인 결과를 낼 수 있다