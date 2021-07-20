-- 여기는 USER1 사용자화면
-- DBA 역할중에서 데이터 저장소의 기초인 Table을 만든다

-- 테이블에서 column(세로줄)과 row(가로줄)이 있는데 컴퓨터공학적 용어로 각각 field, record라고 부른다

-- 학생정보를 저장할 tbl_student Table 생성

-- tbl_student란 이름으로 table(물리적 저장소)를 생성한다
-- 이름명명규칙 : java에서 변수, 클래스, 메소드 등의 이름을 명명하는 것과 같다. 단, 오라클은 대소문자를 구별하지 않는다
-- 디자인패턴으로 테이블을 만들 때 테이블 이름 앞에 접두사로 tbl_를 붙인다
CREATE TABLE tbl_student(
    -- 칼럼(Column) : 필드변수와 같은 개념. 콤마(,)로 구분하여 나열한다
    -- 변수들의 데이터 타입은 변수명 뒤에 지정한다. 데이터 타입에 괄호를 사용하여 최대 저장할 크기를 선언시에 byte 단위로 지정한다
    st_num CHAR(5), -- 고정길이문자열 저장 칼럼. 저장할 데이터가 항상 일정한 길이를 갖고 있는 경우 사용. size는 최대 2000byte까지 지정
    -- 오라클에서 CHAR에 순수 숫자로만 되어있는 데이터를 저장할 경우에는 이슈가 발생할 수 있다
    -- A0001 형식은 문자열로 인식하지만 0001 형식의 경우 문자열로 저장되지만 java를 통해 DB에 접속할 경우 숫자로 인식해버리는 이슈가 있다
    -- 그러므로 오라클에선 아주 특별한 경우가 아니면 VARCHAR2로 사용한다
    
    -- nVARCHAR2(대소문자 구분은 의미 없다)는 유니코드, 다국어를 지원한다. 한글데이터가 입력될 가능성이 있는 칼럼은 nVARCHAR2형식으로 사용해야한다
    -- 한글 데이터를 안쓰면 VARCHAR2를 사용하지만 nVARCHAR2를 써도 상관없다
    st_name nVARCHAR2(20),
    st_addr nVARCHAR2(125),
    
    -- VARCHAR2는 가변길이문자열을 저장한다. 최대 4000byte까지. 만약 저장하는 데이터의 길이가 일정하지 않을 경우 데이터 길이만큼 Column이 변환되어 파일에 저장된다
    -- nVARCHAR는 BYTE가 아닌 CHARACTER로 저장된다
    st_tel VARCHAR2(20),
    
    -- 숫자를 저장하는 칼럼. 표준SQL에는 INT, FLOAT, LONG, DOUBLE 등의 키워드가 있으며 오라클에서도 표준SQL의 타입들을 사용할 수 있다
    -- 하지만 오라클의 내부에서는 NUMBER로 변환되므로 NUMBER를 사용한다
    
    -- st_grade INT, INT를 사용하면 NUMBER(38)로 변환된다
    st_grade NUMBER(1), 
    st_dept nVARCHAR2(10),
    st_age NUMBER(3)
);

-- 데이터 추가
INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '익산시');

INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '남원시');


-- 데이터 조회
SELECT * FROM tbl_student;

DROP TABLE tbl_student; -- table을 통째로 삭제하는 명령어. 사용에 항상 주의할 것

-- DROP한 테이블은 이름만으로 재사용이 불가능하므로 다시 만드려면 내용물까지 다 쳐줘야한다

-- 시나리오
-- tbl_student에 많은 학생의 데이터를 추가하다가 학번이 0100인 학생의 데이터가 두번 입력되었고 이후에 테이블에서 0100 학번으로 학생데이터를 조회했더니
-- 2개가 조회가 되었다. 이런 상황에서 두개의 데이터 중 어떤 것이 0100 학생의 데이터인지 알기 어려워진다
-- 여러 데이터를 검증해야만 어떤 데이터가 사용할 수 있는 데이터인지 확인할 수 있는데 소요되는 자원이 많으므로
-- 이런 문제가 발생하지 않도록 미리 조치를 취해야한다. DB에서는 이러한 조치로 '제약조건' 설정을 지원한다

-- 제약조건 : 학번이 동일한 데이터가 2개 이상은 존재하지 않아야한다
-- 이러한 조건을 'UNIQUE 제약조건'이라고 한다
CREATE TABLE tbl_student(
    st_num CHAR(5) UNIQUE,
    st_name nVARCHAR2(20),
    st_addr nVARCHAR2(125),
    st_tel nVARCHAR2(20),
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age NUMBER(3)
);

-- 다시 생성된 tbl_student에 데이터 추가
INSERT INTO tbl_student(st_num, st_name, st_tel)
VALUES('00001', '성춘향', '남원시');

-- 많은 양의 데이터를 입력하는 과정에서 실수로 10001 학생을 추가해야하는데 00001을 추가하게 된다
INSERT INTO tbl_student(st_num, st_name, st_tel)
VALUES('00001', '이몽룡', '서울시');

-- ORA-00001: unique constraint (USER1.SYS_C007004) violated. 유니크 제약조건을 건드리게 되면 발생하는 오류. 해당 INSERT는 실행되지 않는다

DROP TABLE tbl_student;

-- 데이터를 추가하는 과정에서 학번은 중복금지 제약조건을 설정하여 중복된 값이 추가되지 못하도록 하였다
-- 많은 양의 데이터를 추가하다보면 실수로 학생이름, 전화번호 등을 입력하지 않고 추가한 데이터들이 존재할 수 있다
-- 추후에 tbl_student table의 데이터를 사용하여 업무를 수행하려고 할 때 이러한 데이터가 존재한다면 문제를 일으킬 수 있다
-- NULL값이 들어가버리면(값이 존재하지 않으면) 무의미해지는 자료가 있다면 NOT NULL 제약조건을 붙여서 반드시 자료가 입력되게 해야한다
CREATE TABLE tbl_student(
    st_num CHAR(5) UNIQUE NOT NULL,
    st_name nVARCHAR2(20) NOT NULL,
    st_addr nVARCHAR2(125),
    st_tel nVARCHAR2(20) NOT NULL,
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age NUMBER(3)
);

-- 데이터 추가시 전화번호가 없는 데이터를 입력하려고 수행하면 오류가 발생한다
INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '남원시');

-- ORA-01400:cannot insert NULL into ("USER1"."TBL_STUDENT"."ST_TEL")
-- 오류메시지는 USER1 사용자가 만든 tbl_student 테이블의 st_tel값이 없이로는 INSERT할 수 없다
-- NULL이면 안되는(값이 없으면 안되는) 제약조건에 걸렸기 때문에 insert NULL 오류가 발생한다

INSERT INTO tbl_student(st_num, st_name, st_tel)
VALUES('20111', '이몽룡', '010-111-1234');

-- tbl_student 테이블은 학생정보를 보관하는 매우 중요한 table이다. 이 테이블에서 어떤 학생의 데이터를 조회하고자 할 때, 학생이름, 전화번호 등으로 조회를 할 수 있다
-- 조회하는 값의 데이터가 2개 이상일 수 있다(이름으로 조회시 동명이인). 2개 이상의 데이터가 보인다면 데이터를 살펴봐야하는 불편함이 있다
-- 값을 조회했을 때 유일하게 1개의 데이터만을 추출되도록 설정을 해야한다. 이런 설정을 한 column을 기본키(Primary Key, PK)라고 한다

-- tbl_student table에서 st_num 값으로 조회를 하면 없거나 유일한 1개의 레코드만 나올 것이다. 왜냐하면 UNIQUE이며 not null이기 때문
-- tbl_num에 PK라는 조건을 설정한다. Primary Key로 설정한 칼럼은 UNIQUE와 NOT NULL을 만족하며 KEY로서 조회할 때 빨리 조회할 수 있도록 DBMS가 별도관리한다
-- PK를 설정하면 UNIQUE와 NOT NULL은 중복되므로 생략한다

DROP TABLE tbl_student;
CREATE TABLE tbl_student(
    st_num CHAR(5) PRIMARY KEY,
    st_name nVARCHAR2(20) NOT NULL,
    st_addr nVARCHAR2(125),
    st_tel nVARCHAR2(20) NOT NULL,
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age NUMBER(3)
);

-- st_num은 PK로 설정되어 있으므로 st_num값으로 조회를 하면 반드시 하나의 레코드만 조회된다

DESCRIBE tbl_student; -- console에 table의 구조를 보여준다
DESC tbl_student;


-- USER1 사용자가 생성한 테이블이 어떤 것들인가?
SELECT * FROM dba_tables
WHERE OWNER = 'USER1';

-- tbl_student에 데이터 추가하기
-- INSERT INTO [table]([column], [column], [column]...)
-- VALUES([value, [value], ....)

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept)
VALUES ('00001', '홍길동', '010-111-1234', '서울시', 33, '컴공과');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept)
VALUES ('00002', '성춘향', '010-222-1234', '남원시', 33, '컴공과');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept)
VALUES ('00003', '이몽룡', '010-333-1234', '익산시', 33, '컴공과');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept)
VALUES ('00004', '장보고', '010-444-1234', '해남군', 33, '컴공과');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept)
VALUES ('00005', '장보고', '010-555-1234', '함경도', 33, '컴공과');

SELECT * FROM tbl_student;