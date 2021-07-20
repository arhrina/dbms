-- USER2 화면
-- UPDATE, DELETE DML

/*
새로운 사용자가 사용할 Table 생성, 주소록 테이블을 생성

이름, 전화번호, 주소, 관계, 기타, 나이, 생년월일 등
name, tel, addr, chain, rem, age, birth
한글, 숫자, 한글, 한글, 한글, 숫자, 숫자문자열(날짜는 issue 존재)

반드시 값이 있어야되는 것들에 NOT NULL 제약조건
*/

CREATE TABLE tbl_address(
    name nVARCHAR2(20) NOT NULL,
    tel VARCHAR2(20) NOT NULL,
    addr nVARCHAR2(125),
    chain nVARCHAR2(10),
    rem nVARCHAR2(125),
    birth VARCHAR2(10), -- 2019-10-01
    age NUMBER(3)
);

INSERT INTO tbl_address(name, tel)
VALUES('홍길동', '서울특별시');

INSERT INTO tbl_address(name, tel)
VALUES('이몽룡', '익산시');

INSERT INTO tbl_address(name, tel)
VALUES('성춘향', '남원시');

INSERT INTO tbl_address(name, tel)
VALUES('장길산', '부산광역시');

INSERT INTO tbl_address(name, tel)
VALUES('임꺽정', '함경남도');

COMMIT; -- 현재 트랜잭션(처리)가 완료되었음을 DBMS에 고지

SELECT * FROM tbl_address;

-- UPDATE : 이미 Table에 Insert되어있는 레코드의 일부(전부) Column에 있는 값을 바꾸는 것

UPDATE tbl_address SET addr = '서울특별시';
-- 모든 레코드의 addr 값을 서울특별시로 세팅. 위험한 명령

SELECT * FROM tbl_address;

ROLLBACK;
-- 데이터의 추가, 삭제, 변경을 최종커밋 전으로 되돌리는 DCL
SELECT * FROM tbl_address;

-- UPDATE를 기본형(UPDATE [table] SET column = 값;)으로 하게 되면 모든 데이터가 변경되버린다. 절대 기본형으로 수행하지 말자

UPDATE tbl_address SET addr = '서울특별시' WHERE name = '홍길동';
-- tbl address table에 저장된 데이터 중 name이 '홍길동'인 레코드만 addr값을 서울특별시로 변경
SELECT * FROM tbl_address;

UPDATE tbl_address SET addr = '익산시' WHERE name = '성춘향';
UPDATE tbl_address SET addr = '남원시' WHERE name = '이몽룡';

COMMIT;
SELECT * FROM tbl_address;


-- UPDATE하고나니 잘못된 레코드에 업데이트한 것을 발견하여 서로를 변경하려고 한다
UPDATE tbl_address SET addr = '익산시' WHERE name = '이몽룡';
UPDATE tbl_address SET addr = '남원시' WHERE name = '성춘향';

INSERT INTO tbl_address(name, tel)
VALUES('홍길동', '서울특별시');

SELECT * FROM tbl_address;

-- 1번 홍길동의 ADDR을 광주광역시로
UPDATE tbl_address SET addr = '광주광역시' WHERE name = '홍길동' AND addr = '서울특별시';

-- tbl_address TABLE을 생성해서 테스트해보니 name, tel의 값이 같은 경우 하나의 데이터만 변경하려고 했을 때 무결성 조건이 훼손되어 불가능하다
-- 추가된 데이터가 name column과 tel column의 값만을 가지고 있는데 두개의 값이 같은 레코드들이 추가되면 각각을 핸들링할 수 없게 된다
-- 설계상의 실수로 인하여 개체무결성이 훼손되어 있다. 개체무결성을 보장하기 위해 PK를 생성해야 하므로 테이블을 재설계한다
DROP TABLE tbl_address;
-- 설계상 중복되지 않는 Column을 찾을 수 없으므로 별도로 PK로 사용할 Column을 추가해 개체 무결성을 보장해야한다
CREATE TABLE tbl_address(
    id NUMBER PRIMARY KEY,
    name nVARCHAR2(20) NOT NULL,
    tel VARCHAR2(20) NOT NULL,
    addr nVARCHAR2(125),
    chain nVARCHAR2(10),
    rem nVARCHAR2(125),
    birth VARCHAR2(10), -- 2019-10-01
    age NUMBER(3)
);

INSERT INTO tbl_address(id, name, tel)
VALUES (1, '홍길동', '서울특별시');

INSERT INTO tbl_address(id, name, tel)
VALUES (2, '홍길동', '서울특별시');

INSERT INTO tbl_address(id, name, tel)
VALUES (3, '홍길동', '서울특별시');

INSERT INTO tbl_address(id, name, tel)
VALUES (4, '이몽룡', '남원시');

INSERT INTO tbl_address(id, name, tel)
VALUES (5, '성춘향', '익산시');

SELECT * FROM tbl_address;
UPDATE tbl_address SET addr = '서울특별시' WHERE id = 1 AND name = '홍길동';
UPDATE tbl_address SET addr = '광주광역시' WHERE id = 2 AND name = '홍길동';
UPDATE tbl_address SET addr = '부산광역시' WHERE id = 3 AND name = '홍길동';
SELECT * FROM tbl_address;

COMMIT;

DELETE FROM tbl_address; -- UPDATE문과 마찬가지로 절대 기본형으로 실행하지 않기. 다 날려버린다
SELECT * FROM tbl_address;
ROLLBACK;

-- 삭제 전 삭제할 데이터가 존재하는지를 확인
SELECT * FROM tbl_address WHERE name = '성춘향';
DELETE FROM tbl_address WHERE name = '성춘향'; -- 하나뿐이니 이렇게 실행해도 된다

SELECT * FROM tbl_address WHERE name = '홍길동'; -- 다수의 데이터가 존재하므로 다른 값을 참조하여 날려야한다
DELETE FROM tbl_address WHERE name = '홍길동'; -- 다수의 데이터가 다 날아간다

SELECT * FROM tbl_address WHERE name = '홍길동' AND addr = '서울특별시';
DELETE FROM tbl_address WHERE name = '홍길동' AND addr = '서울특별시'; -- 하나만이 날아가지만 개체무결성을 보장하진 않는다

-- 조회하여 PK값을 확인하고 PK값을 참조하여 날려버리는 것이 개체무결성을 보장한다
DELETE FROM tbl_address WHERE id = 1;

-- UPDATE, DELETE는 특별한 경우가 아니라면 다수의 레코드에 적용되므로 명령을 수행할 때 개체무결성을 보장하기 위해 PK를 WHERE 조건으로 하자

-- DBMS를 운영하는 과정에서 재난(실수로 데이터 변경, 삭제, 천재지변)이 발생했을 때 데이터를 복구할 수 있는 준비를 해야한다
-- 백업. 업무 종료후 데이터를 다른 저장소, 매체에 복사하여 보관
-- 복구. 백업해둔 데이터를 사용중인 시스템에 설치하여 사용할 수 있도록 하는 것. 백업 시점에 따라 완전복구는 불가능할 수 있으며 시간이 오래 걸린다
-- 로그기록 복구. insert, update, delete 등이 수행될 때 명령을 파일로 기록해두고 문제 발생시 로그를 역추적하여 복구. 저널링 복구라고도 부른다
-- 다중화. 완전동일한 시스템을 만들어놓고 동시에 운영하면서 CUD가 수행될 때 모두에서 실행되고 수행에 오류가 발생하면 해당 연결을 종료하고 정상작동하는 시스템으로 절환하여 운영을 계속한다

-- 데이터센터(데이터 웨어하우스)
-- 대량의 데이터베이스를 운영하는 서버시스템들을 모아서 통합관리하는 곳