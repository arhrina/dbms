-- 여기는 USER1 사용자 화면
SELECT 30 + 40 FROM dual;
-- 현재 부여된 권한이 무엇인지 확인
SELECT * FROM DBA_ROLE_PRIVS;
SELECT * FROM DBA_TAB_PRIVS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;

-- USER1에게는 CREATE SESSION 권한만을 부여했기 때문에 여러 명령들을 사용하는게 불가능하다
-- 오라클은 보안정책으로 새로 생성된 사용자가 어떤 명령을 수행하려면 사용할 수 있는 명령들을 일일이 부여해야한다

-- 이러한 정책 때문에 오라클 DBMS를 학습하는데 초기에 어려움이 있으므로 권한 정책을 학습하기에 앞서 표준 SQL 등을 학습하기가 용이하도록
-- 일반사용자에게 DBA 권한을 부여하여 사용한다

-- 오라클의 DBA 권한
-- SYSDBA에 비해 제한적으로 부여된 권한으로 일부 DDL, DML, 일부 DCL 명령을 사용할 수 있는 권한을 갖는다
GRANT DBA TO user1;

