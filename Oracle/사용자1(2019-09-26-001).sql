-- 여기는 USER1 화면입니다
-- TABLE 생성 연습

CREATE TABLE tbl_addr(
-- 이름, 주소, 전화번호, 나이, 관계
name VARCHAR2(10), -- String
addr VARCHAR2(125), -- String
tel VARCHAR2(20), -- String
age int, -- int
chain VARCHAR2(20) -- String
);

SELECT * FROM tbl_addr;

-- 1개의 데이터를 tbl_addr에 추가
INSERT INTO tbl_addr (name, addr, tel, age, chain)
VALUES ('홍길동', '서울시', '010-111-1111', 33, '친구');
-- 세미콜론을 찍기 전까지는 하나의 명령으로 인식한다
-- DATA를 삽입하는 DML INSERT

-- tbl_addr에 있는 데이터를 모두 보여라
SELECT * FROM tbl_addr;

-- tbl_addr 테이블의 addr column에 저장된 값을 광주광역시로 변경
UPDATE tbl_addr
SET addr = '광주광역시';

SELECT * FROM tbl_addr;

DELETE FROM tbl_addr;

SELECT * FROM tbl_addr;