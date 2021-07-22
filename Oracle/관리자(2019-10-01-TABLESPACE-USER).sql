-- 여기는 관리자 화면입니다
-- TableSpace 생성, 새로운 사용자 생성
-- 관리자 계정으로 접속된 상태에서 TableSpace, User 등을 등록(생성). DDL(Data Definition Language)를 사용한다


-- Windows에서는 파일경로를 \로 표기하는데 다른운영체제는 /를 사용하므로 호환성을 위해 /로 설계한다. 윈도우도 /를 사용할 수 있다
-- Windows에서 ROOT는 C:, D: 등으로 표기하는데 다른 os에서는 /로 표기한다. 가장 앞에 있는 루트폴더를 생략하고 표기할 수 있다


-- user2_DB란 이름으로 테이블스페이스를 생성하고 실제 데이터 저장공간을 지정해주며 초기용량은 10MB, 확장시 10KB씩으로 설정
-- 다른 DBMS에서는 TABLESPACE 키워드 대신 DATABASE라는 키워드를 사용하기도 한다
CREATE TABLESPACE user2_DB
DATAFILE '/BizWork/oracle/data.user2_dbf'
SIZE 10M AUTOEXTEND ON NEXT 10K;

-- 생성한 user2_DB TableSpace에 데이터를 관리(조작)할 사용자 계정을 생성

-- user2라는 아이디로 새로운 사용자를 생성하고 임시비밀번호를 1234로 설정,
-- user2가 TABLE을 생성하고 데이터를 저장할 때 user2_DB TABLESPACE를 사용하도록 지정
-- DEFAULT TABLESPACE를 지정하지 않으면 user2 사용자가 Table을 생성하고 데이터를 저장할 때 해당 데이터들은 오라클DBMS의
-- 시스템영역에 저장한다. 작은 규모의 PJ에서는 큰 문제가 없지만 실무에서는 잘못될 가능성이 높다
CREATE USER user2 IDENTIFIED BY 1234 DEFAULT TABLESPACE user2_DB;

/* 
오라클에서는 사용자계정을 등록하면 아무런 활동을 할 수 없는 상태로 추가된다. DCL 명령을 통해 사용자에게 권한을 부여해야 활동이
가능하다. 11gXE 환경에서는 외부접속으로 인한 보안 문제가 크지 않으므로 편의성을 위해 DBA 권한을 사용자에게 부여하여 실습한다
*/

GRANT DBA TO user2;
-- user2에게 DBA권한을 부여
-- DBA는 시스템에 관련된 정보를 조회할 수 있는 등급이다. 또한 자신의 영역에 테이블같은 DB OBJECT들을
-- 생성, 삭제, 변경 등이 가능하다
-- DML 명령을 활용하여 데이터를 조작할 수 있으며, 일부 DCL 명령을 사용할 수 있다