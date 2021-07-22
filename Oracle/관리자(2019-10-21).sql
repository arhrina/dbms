-- Administrator 화면
/*
TABLESPACE 생성

이름 : USER4_DB
DATAFILE : '/bizwork/oracle/data/user4.dbf'
초기용량 : 10MB
자동확장 : 10KB
*/

CREATE TABLESPACE user4_db DATAFILE '/bizwork/oracle/data/user4.dbf' SIZE 10M AUTOEXTEND ON NEXT 10K;

/*
사용자
ID : user4
PW : user4
DEFAULT TABLESPACE : user4_db
권한 : DBA
*/

CREATE USER user4 IDENTIFIED BY user4 DEFAULT TABLESPACE user4_db;
GRANT DBA TO user4;

-- CREATE하면서 DEFAUlT TABLESPACE를 지정하지 않으면 SYSTEM(admin, 오라클 DBMS가 사용하는 영역)의 TABLESPACE를 사용한다
-- 작은 규모의 프로젝트에선 큰 문제가 없지만 SYSTEM 영역을 사용하는 것은 보안, 관리에서 좋은 방법이 아니다

-- DEFAULT TABLESPACE를 나중에 추가하는 방법
-- 사용자와 관련하여 정보, 값들을 수정한다
ALTER USER user4 DEFAULT TABLESPACE user4_db;

-- 사용자를 생성하고, TABLE 등을 생성한 후에 DEFAULT TABLESPACE를 변경하면 DBMS에서 TABLE을 DEFAULT TABLE로 옮겨준다
-- 데이터가 많으면 문제를 일으키는 경우도 있다. 사용중인 경우에는 가급적 변경하지 않는 것이 좋다

ALTER USER user4 IDENTIFIED BY user4;

-- 기존 TABLESPACE에 있는 TABLE들을 수동으로 다른 TABLESPACE로 옮기기
-- 현재 사용자의 DEFAULT TABLE SPACE에 있는 테이블을 다른 TABLESPACE로 옮기기
ALTER TABLE tbl_student MOVE TABLESPACE user4_db;


-- DEFAULT를 생성하지 않고 데이터를 저장했을 경우 새로운 TABLESPACE를 생성하고 사용중이던 TABLE을 새로운 TABLESPACE로 옮기고 DEFAULT TABLESPACE를 변경


-- TABLESPACE를 통째로 백업하고 다른곳에 옮겨서 사용할 수 있도록 하는 방법. ORACLE 10 이상에서 동작