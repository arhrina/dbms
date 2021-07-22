-- 관리자 화면

-- 개념 schema. DBMS 차원에서 바라본 스키마. 논리적인 개념으로 table 등과 같은 저장소 object를 모아놓은 그룹
-- Oracle에선 user가 개념스키마 역할을 수행


-- tablespace 생성. 이름 user3_db. datafile /bizwork/oracle/data/user3.dbf
-- 초기크기 10MB, 자동확장 1KB

CREATE TABLESPACE user3_db DATAFILE '/bizwork/oracle/data/user3.dbf' SIZE 10M AUTOEXTEND ON NEXT 1K;

-- 새로운 user 생성(개념스키마 생성). id : user3, pswd : 1234, default tablespace : user3_db

CREATE USER user3 IDENTIFIED BY 1234 DEFAULT TABLESPACE user3_db;

-- 생성한 사용자에 DB접근 권한을 부여. DBA권한
GRANT DBA TO user3;