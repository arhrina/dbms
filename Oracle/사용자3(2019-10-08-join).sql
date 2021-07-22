-- user3
-- 2개 이상의 테이블에 나뉘어져 저장된 데이터를 연계해서 하나의 리스트처럼 출력하는 SQL 명령

SELECT * FROM tbl_books B, tbl_genre G WHERE B.b_genre = G.g_code; -- EQ, 완전, 내부 조인
-- 2개 이상의 테이블에 연계된 컬럼이 모두 존재할 경우(두 테이블 간 완전 참조무결성이 보장되는 경우)
-- 이 조인이 표현하는 리스트를 카티션 곱이라고 표현한다

-- EQ 조인의 경우, 두 테이블이 완전 참조무결성 조건에 위배되는 경우(조인의 조건으로 어떠한 값이 누락되는 경우), 데이터는 있지만 DB의 참조하는 신뢰성을 상실
-- 참조무결성 조건은 EQ JOIN의 결과에 신뢰성을 보장하는 조건


-- 완전 참조무결성. A가 B를 참조할 때 A에 있는 것은 B에도 반드시 있어야한다. 역은 성립하지 않는다

-- 두 테이블 간 참조무결성을 무시하고 JOIN 실행하기
-- (시나리오) 새로운 도서가 입고되었는데 사용하던 장르와 다른 장르여서 새로운 장르코드를 생성해서 010 이라고 사용하기로 했다
INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_genre) VALUES('979-009', '아침형인간', '하늘소식', '이몽룡', '010');
-- 참조무결성 조건을 사전에 설정해두었다면 이 INSERT 수행은 불가능했을 것이지만 아직 설정하지 않았기에 이 INSERT는 가능하다

SELECT * FROM tbl_books B, tbl_genre G WHERE B.b_genre = G.g_code;
-- EQ 조인을 확인해보니 새로 등록한 도서는 누락되어 있다. 출력 결과는 신뢰성을 잃게 되었다


-- 참조 무결성을 무시하고 (일부) 신뢰성이 있는 리스트를 보기 위해 다른 JOIN을 수행한다
-- LEFT JOIN
-- 왼쪽에 있는 table 리스트는 모두 보여주고 ON 조건에 일치하는 값이 오른쪽 테이블에 있으면 값을 보이고 없어도 null로 표현
SELECT * FROM tbl_books B -- 리스트를 확인하고자 하는 table
LEFT JOIN tbl_genre G -- 참조할 table
ON B.b_genre = G.g_code -- 참조할 컬럼 연계
ORDER BY B.b_isbn; -- 코드순으로 정렬


/*
tbl_books 테이블에 b_title 컬럼 값이 아침형인간인 리스트를 보이면서 b_genre 값과 일치하는 값이 tbl_genre의 g_code 컬럼에 있으면 값을 같이 보여주고
그렇지 않으면 null이라고 리스트를 보여라
*/
SELECT * FROM tbl_books B
LEFT JOIN tbl_genre G
ON B.b_genre = G.g_code
WHERE B.b_title = '아침형인간';

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, tbl_genre.g_code, tbl_genre.g_name
FROM tbl_books LEFT JOIN tbl_genre ON tbl_books.b_genre = tbl_genre.g_code WHERE tbl_books.b_title LIKE '%자바%' ORDER BY tbl_books.b_title;

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, tbl_genre.g_code, tbl_genre.g_name
FROM tbl_books LEFT JOIN tbl_genre ON tbl_books.b_genre = tbl_genre.g_code WHERE tbl_genre.g_name = '장편소설'; -- 참조 테이블을 조건으로 할 수도 있다

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, tbl_genre.g_code, tbl_genre.g_name
FROM tbl_books LEFT JOIN tbl_genre ON tbl_books.b_genre = tbl_genre.g_code;

-- 장르가 장편소설인 도서정보를 장르소설로 장르 명칭을 변경하고 싶다
-- 테이블이 각각 books와 genre로 나뉘어져 있고 두 테이블을 JOIN해서 사용하는 중이기 때문에 tbl_genre 테이블의 g_name 컬럼 값을 변경한다
SELECT * FROM tbl_genre;
UPDATE tbl_genre SET g_name = '장르소설' WHERE g_code = '003';

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, tbl_genre.g_code, tbl_genre.g_name
FROM tbl_books LEFT JOIN tbl_genre ON tbl_books.b_genre = tbl_genre.g_code;

/*
tbl_books를 조회했더니 장르가 장편소설인 장르 데이터가 3개. tbl_books 테이블에 장르를 이름으로 설정을 하면 update 문을 실행해야 한다
UPDATE tbl_books SET b_genre = '장르소설' WHERE b_genre = '장편소설'; 최소 2개 이상의 레코드가 변경될 것이다
DB에서 하나의 테이블에서 2개 이상의 레코드가 변경되는 실행은 가급적 지양해야 데이터의 무결성을 유지할 수 있다
UPDATE, DELETE 등을 수행할 땐 한개의 레코드만 변경되도록 PK를 조건으로 설정해서 명령을 수행해야 한다
이런 이유로 테이블을 분리하고 두 테이블을 JOIN해서 출력하는 과정을 수행한다

1개의 테이블에 존재하는 데이터를 2개 이상의 테이블로 분리하고 JOIN을 수행할 수 있도록 구조를 변경하는 과정을 DB 제 2 정규화(2NF)라고 한다
*/