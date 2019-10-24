-- SQL 명령들을 사용해서 DBMS 학습을 진행
-- 오라클 11g의 명령세트를 학습
-- 현재 최신 오라클은 19c, 18c인데
-- 현업에서 사용하는 오라클 DBMS SW들이 아직 하위버전을 사용하고 있으므로 11위주의 명령세트(체계)를 학습

-- 마이그레이션(Migration)
-- 버전업, 업그레이드
-- 하위버전에서 사용하던 데이터베이스(물리적 storage에 저장된 데이터)를 상위버전이나 다른회의 DBMS에서 사용할 수 있도록 변환, 변경, 이전하는 것들

-- 오라클 DBMS SW(오라클DB, 오라클)를 이용해서 DB관리 명령어를 연습하기 위해서
-- 연습용 데이터 저장공간을 생성한다
-- 오라클에서는 Storage에 생성한 물리적 저장공간을 tablespace라고 부른다
-- 기타 MySQL, MSSQL 등의 DBMS SW들은 물리적 저장공간을 database라고 한다

-- DDL 명령어를 사용해서 tablespace를 생성
-- DDL은 DBA(DataBase Administrator, 데이터베이스 관리자)

-- DDL 명령에서 "생성한다" = CREATE
-- 물리SCHEMA를 생성한다란 의미
CREATE TABLESPACE; -- TABLESPACE 생성
CREATE USER; -- 새로운 접속사용자를 생성
CREATE TABLE; -- 구체적인 데이터를 저장할 공간을 생성


-- DDL 명령에서 "삭제, 제거" = DROP
-- DDL 명령에서 "변경(수정이란 표현을 쓰지 않는다)한다" = ALTER


-- C:\BizWork\oracle\data
-- C:/BizWork/oracle/data
CREATE TABLESPACE user_1DB
DATAFILE 'C:/BizWork/oracle/data/user_1.dbf'
SIZE 100M; -- 초반에 DB는 자주, 많이 데이터를 추가하게 되므로 사전에 초기용량으로 100MB 공간을 확보
-- user_1DB라는 이름으로 C:/BizWork/oracle/data/user_1.dbf 파일을 물리적 저장소로 만들어서 쓸 것이고 초기사이즈는 100MB크기이다

DROP TABLESPACE user_1DB
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;


-- user_1DB라는 이름으로 tablespace를 만들어라
-- 물리적 저장공간은 C:/BizWork/oracle/data/user1.dbf
-- dbf는 databasefile의 약자
-- 초기에 100MB 공간을 할당하라
-- 100MB 공간을 쓰다가 모자라지면 자동으로 100KB씩 늘려가며 데이터를 저장하라
CREATE TABLESPACE user_1DB
DATAFILE 'C:/BizWork/oracle/data/user_1.dbf'
SIZE 100M AUTOEXTEND ON NEXT 100K;


-- 현재 이 화면에서 명령을 수행하는 사용자는 SYS DBA 권한을 가진 사람
-- SYSDBA 권한은 System DB등을 삭제하거나 변경할 수 있기 때문에 실습환경에서는 가급적 꼭 필요한 명령 외엔 사용하지 않는 것이 좋다

-- 실습을 위해 새로운 사용자를 생성한다
-- 관리자가 user1 사용자를 등록하고 임시로 비밀번호를 1234로 설정
CREATE USER user1 IDENTIFIED BY 1234
-- 앞으로 user1으로 접속하여 데이터를 추가하면 user_1DB TABLESPACE에 저장한다
DEFAULT TABLESPACE user_1DB;

-- 현재 설치된 오라클에 생성되어 있는 사용자들을 모두 보여라. 정상적으로 유저 정보가 추가되었는지 확인
SELECT * FROM ALL_USERS;

-- DML의 SELECT 명령은 데이터를 생성, 수정, 삭제한 후에 정상적으로 수행되었는지 확인하는 용도로도 사용된다

-- 오라클에서는 관리자가 새로운 사용자를 생성하면 아무런 권한도 없는 상태로 추가된다. id/password를 입력해도 접속 자체가 되지 않는다
-- 관리자는 새로 생성한 사용자에게 DBMS에 접속할 수 있는 권한을 부여해야 한다. 이러한 권한과 관련된 명령어 셋은 DCL이라고 한다


-- 권한 부여 : GRANT
-- 권한 박탈 : REVOKE
-- 새로 생성한 user1에 권한을 부여
-- CREATE SESSION(접속설정, 접속생성) 권한을 user1에 부여

GRANT CREATE SESSION TO user1;

-- USER1에게는 CREATE SESSION 권한만을 부여했기 때문에 여러 명령들을 사용하는게 불가능하다
-- 오라클은 보안정책으로 새로 생성된 사용자가 어떤 명령을 수행하려면 사용할 수 있는 명령들을 일일이 부여해야한다

-- 이러한 정책 때문에 오라클 DBMS를 학습하는데 초기에 어려움이 있으므로 권한 정책을 학습하기에 앞서 표준 SQL 등을 학습하기가 용이하도록
-- 일반사용자에게 DBA 권한을 부여하여 사용한다

-- 오라클의 DBA 권한
-- SYSDBA에 비해 제한적으로 부여된 권한으로 일부 DDL, DML, 일부 DCL 명령을 사용할 수 있는 권한을 갖는다
GRANT DBA TO user1;

-- 권한 회수
REVOKE DBA FROM user1;