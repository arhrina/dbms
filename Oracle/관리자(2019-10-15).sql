-- Administrator

/*
TABLE SPACE 생성
이름 : grade_db
데이터파일 : C:/bizwork/oracle/data/grade.dbf
초기사이즈 : 10MB
자동증가 : 10KB
*/

CREATE TABLESPACE grade_db DATAFILE '/bizwork/oracle/data/grade.dbf' SIZE 10M AUTOEXTEND ON NEXT 10K;

/*
USER 생성. 스키마 생성. 테이블 관리 주체
ID : grade
pass : grade
권한 : DBA
DEFAULT TABLESPACE : grade_db
*/

CREATE USER grade IDENTIFIED BY grade DEFAULT TABLESPACE grade_db;

GRANT DBA TO grade;

-- 사용자 비밀번호 변경
ALTER USER grade IDENTIFIED BY grade;

SELECT * FROM ALL_USERS WHERE username = 'GRADE'; -- pw는 알수 없음. 해시로 솔트되어 저장