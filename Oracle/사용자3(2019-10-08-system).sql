-- user3
-- 오라클 전용 SYSTEM 쿼리
SELECT * FROM v$database; --  현재 사용중인 DBMS 엔진의 전역 명칭, 정보를 확인

SELECT * FROM TAB; -- 현재 사용자가 접근가능한 권한을 가진 테이블 목록

SELECT * FROM ALL_TABLES; -- DBA 이상의 사용자가 확인할 수 있는 전체 테이블 목록

DESC tbl_books; -- tbl_books의 테이블 구조
DESCRIBE tbl_books; -- 다른 대부분의 DBMS에서 테이블의 구조를 확인하는 명령

SELECT * FROM user_tables; -- TAB과 유사. 사용자 권한에 따라 TAB과 다른 결과를 보여주기도 한다