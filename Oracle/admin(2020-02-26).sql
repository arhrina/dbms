-- 관리자페이지

-- 테이블 스페이스 생성
CREATE TABLESPACE bbs_final_ts
DATAFILE 'c:/bizwork/oracle/data/bbs_final.dbf'
SIZE 100K AUTOEXTEND ON NEXT 1K;

-- 사용자 생성, 테이블 스페이스 등록
CREATE USER bbsfinal IDENTIFIED BY 1234
DEFAULT TABLESPACE bbs_final_ts;

-- DBA 권한 부여. 권한 박탈은 REVOKE
GRANT DBA TO bbsfinal;