SELECT * FROM tbl_books;

/*
PRIMARY KEY
DBMS 객체(개체)무결성을 보장(유지)하기 위해 사용하는 중요한 요소

개체(객체)무결성
1.어떤 데이터를 조회했을 때 나타나는 데이터는 필요로 했던 데이터라는 보장
2.PK를 WHERE 조건으로 SELECT를 했을 때 나타나는 데이터는 1개의 레코드이며 이 데이터는 원하는 데이터라는 보장
3.PK는 1개의 컬럼을 지정하는 것이 원칙이지만 실제 상황에서 1개의 컬럼만으로 PK를 지정하지 못하는 경우가 있다.
두개 이상의 복수 컬럼을 묶어서 PK로 지정하는 경우도 있다
    ex) 거래처정보
    거래처명+대표+전화번호 => 3개의 컬럼을 PK로 지정하는 경우
    
4.복수의 컬럼을 PK로 지정하는 경우, UPDATE, DELETE를 수행할 때 PK를 WHERE 조건으로 명령을 수행할 때 복잡한 SQL을 구성해야하는 경우가 생긴다
    ex) DELETE FROM [거래처정보] WHERE 거래처명 = '거래처명' AND 대표 = '대표' AND 전화번호 = '전화번호'
    
5.가급적 1개의 컬럼만을 PK로 지정하는 것이 좋고, PK로 지정할 컬럼을 선택할 수 없는 경우엔 실제 존재하지 않는 새로운 컬럼을 추가하고
그 컬럼을 PK로 설정하는 것이 좋다
    ex) '코드', 'ID' 과 같은 컬럼을 추가해서 PK로 사용
    
6.'코드'는 최초 데이터를 추가하기 위해 일정한 조건으로 만들어서 사용하는 경우가 많으므로 특별한 문제가 발생하진 않는다
'ID'는 실제 데이터와 관계없이 '일련번호', 'Serial Number' 형식으로 지정하는 경우가 많다. 보편적인 DBMS에서는 최대 자릿수를 가지는 숫자 컬럼으로 지정하고
AUTO INCREMENT라는 옵션을 지정하여 INSERT를 수행할 때마다 자동으로 새로운 수를 생성하도록 할 수 있다

ORACLE 11 이하에서는 AUTO INCREMENT란 옵션이 없으므로 여러가지 방법으로 대체하여 사용한다
SEQUENCE object를 생성하고 SEQUENCE에 NEXTVAL 값을 활용하여 데이터를 추가할 때 'ID'에 새로운 값이 만들어져 저장되도록 사용한다

오라클의 시퀀스는 한번 생성하면 상태를 영구히 보관하고 있다가 NEXTVAL을 호출하면 (현재상태 + INCREMENT BY로 지정한 값)을 수행하여 새로운 값을 생성한다
시퀀스는 개념스키마인 사용자에 저장되어 사용한다
*/

-- 오라클에서 RANDOM, SEQUENCE 외에 PK값을 생성. GUID(Global Unique IDentified). 32바이트의 중복되지 않는 KEY값 생성
-- GUID를 저장할 컬럼의 데이터 형식을 RAW(무한한 크기제한이 없는 binary형) 값으로 지정하거나 nVARCHAR2(125) 이상으로 지정해서 사용한다
SELECT SYS_GUID() FROM DUAL;

INSERT INTO tbl_books(b_code, b_name)
VALUES(SYS_GUID(), 'GUID 연습');

/*
index
자주 select를 수행하는 컬럼이 있을 경우 해당 컬럼을 인덱스라는 오브젝트로 생성해두면 select시 인덱스를 먼저 조회하고 인덱스로부터 해당 데이터가 저장된 레코드의
주소를 통해 테이블로 접근하여 select를 수행속도를 높이는 기법

테이블 생성시 PK로 지정한 컬럼은 기본적으로 인덱스로 설정된다

SELECT시엔 인덱스로 성능에 이득을 볼 수 있지만 반대로 INSERT, UPDATE, DELETE 명령시엔 손해를 볼 수 있다
초기에 다수의 데이터를 INSERT할 때는 가급적이면 INDEX를 추후에 설정하는 것이 효율적이며,
PK로 설정된 컬럼을 기준으로 정렬된 데이터를 INSERT 하는 것이 효율적이다

너무 다수의 index를 설정하면 index object가 문제를 일으킬 수 있다
최소한의 index만을 사용
*/
CREATE INDEX IDX_NAME ON tbl_books(b_name);
SELECT * FROM tbl_books WHERE b_name = '자바';

-- DBMS 업무중에 b_name과 b_writer를 조건으로 하는 SELECT문을 자주 수행한다면 2개의 컬럼으로 인덱스를 생성하여 활용할 수 있다
SELECT * FROM tbl_books WHERE b_name = '자바' AND b_writer = '홍길동';
CREATE INDEX IDX_NAME_WRITER ON tbl_books(b_name, b_writer);
DROP INDEX IDX_NAME_WRITER;

DROP INDEX IDX_NAME;
-- TABLE 생성시 UNIQUE 제약조건을 설정한 것과 같이 작동된다. 기존에 저장된 데이터가 UNIQUE 상태가 아니면 INDEX는 생성되지 않는다
CREATE UNIQUE INDEX IDX_NAME ON tbl_books(b_name);

-- INDEX가 손상 => DROP 후 CREATE
-- 상용DBMS에선 INDEX가 손상되면 DBMS 자체적으로 rebuild하는 기능이 포함되어 있다