-- 여기는 USER1 화면입니다
-- TABLE 생성
-- TABLE은 JAVA의 VO와 같은 개념의 데이터 저장소
-- VO에 담긴 데이터들을 후에 추출해서 사용하기 위한 영구저장소

-- tbl_test : 저장소의 이름. 테이블 명. 데이터들의 각 요소(Column, 자바의 필드변수)를 생성시에 같이 선언한다
-- Column명 변수type(글자수) 제약조건 순으로 문법을 사용한다
CREATE TABLE tbl_test(
    num nVARCHAR2(20) NOT NULL UNIQUE PRIMARY KEY,
    name nVARCHAR2(50) NOT NULL,
    age NUMBER(3) NOT NULL
);

-- 테이블을 영구적으로 물리저장소로부터 삭제하는 명령어. 데이터가 모두 손실되므로 신중하게 수행해야한다
DROP TABLE tbl_test;