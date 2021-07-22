CREATE TABLE tbl_books(
B_CODE	VARCHAR2(20)		PRIMARY KEY,
B_NAME	nVARCHAR2(125)	NOT NULL	,
B_AUTHER	nVARCHAR2(125)	NOT NULL	,
B_COMP	nVARCHAR2(125)		,
B_YEAR	VARCHAR2(10)		,
B_IPRICE	NUMBER		
-- CONSTRAINT PK_BOOK PRIMARY KEY (b_code) 로 칼럼 뒤에 primary key를 붙이지 않고 pk를 설정할 수도 있다
);

CREATE TABLE tbl_member(
M_ID	VARCHAR2(20)	NOT NULL	PRIMARY KEY,
M_PASSWORD	nVARCHAR2(125)	NOT NULL	,
M_LOGIN_DATE	VARCHAR2(10)		,
M_REM	nVARCHAR2(125)		
);

CREATE TABLE tbl_read_book(
RB_SEQ	NUMBER	NOT NULL	PRIMARY KEY,
RB_BCODE	VARCHAR2(20)	NOT NULL	,
RB_DATE	VARCHAR2(10)	NOT NULL	,
RB_STIME	VARCHAR2(10)		,
RB_RTIME	NUMBER(10,3)		,
RB_SUBJECT	nVARCHAR2(20)		,
RB_TEXT	nVARCHAR2(400)		,
RB_STAR	NUMBER		
);

CREATE SEQUENCE seq_read_book
START WITH 1 INCREMENT BY 1;

ALTER TABLE tbl_read_book -- 연동되는 테이블
ADD CONSTRAINT FK_BOOKS
FOREIGN KEY(rb_bcode) -- PK키와 연동되는 테이블의 칼럼
REFERENCES tbl_books(b_code); -- PK키로 설정된 것. n:1에서 1 쪽의 칼럼

ALTER TABLE tbl_read_book DROP CONSTRAINT FK_BOOKS; -- FK 제거하는 명령어
DROP TABLE tbl_books;

ALTER TABLE tbl_read_book -- 연동되는 테이블
ADD CONSTRAINT FK_BOOKS
FOREIGN KEY(rb_bcode) -- PK키와 연동되는 테이블의 칼럼
REFERENCES tbl_books(b_code) ON DELETE CASCADE; -- PK키로 설정된 것. n:1에서 1 쪽의 칼럼

-- foreign key를 만들 때는 해당하는 참조데이터가 있는 값이 1쪽 테이블 칼럼에도 데이터가 다 있어야된다

CREATE TABLE tbl_books(
B_CODE	VARCHAR2(20)		PRIMARY KEY,
B_NAME	nVARCHAR2(125)	NOT NULL	,
B_AUTHOR	nVARCHAR2(125)	NOT NULL	,
B_COMP	nVARCHAR2(125)		,
B_YEAR	VARCHAR2(10)		,
B_PAGE NUMBER,
B_IPRICE NUMBER		
);

SELECT * FROM tbl_member;
INSERT INTO tbl_read_book(RB_SEQ,
RB_BCODE,
RB_DATE,
RB_STIME,
RB_RTIME,
RB_SUBJECT,
RB_TEXT,
RB_STAR)
VALUES(seq_read_book.nextval, 979-11-625407-7-0, 2020-01-09, 2020-01-09, 2020-01-09, '어렵다', '어렵다어려워', 4.5);

SELECT * FROM tbl_read_book WHERE rb_bcode = 979-11-625407-7-0;