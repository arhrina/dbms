/* MySQL의 실행화면
 MySQL과 Oracle의 차이점
 
 MySQL				Oracle
 Database			TABLESPACE
 
 */
 USE mySQL;
 -- mySQL의 system catalog
 -- mySQL Database를 사용하겠음. mySQL에 포함된 Table을 사용하겠다
 SHOW TABLES;
 -- mySQL DB에 있는 TABLE의 전체목록 보기
 CREATE DATABASE myDB;
 -- TABLESPACE 생성처럼 데이터를 저장할 공간 설정
 USE myDB; -- myDB를 사용하겠음
 SHOW TABLES;
 -- 보통 auto_increment는 int형 pk에 설정.
 -- 정수형으로 1부터 일련번호를 자동으로 증가시켜준다
 -- mySQL의 정수형 데이터는 최대 11자리까지 저장할 수 있다. 1000억부터는 오류
 
 CREATE TABLE tbl_test(
 id int PRIMARY KEY auto_increment,
 name nVARCHAR(50) NOT NULL,
 tel VARCHAR(20),
 addr nVARCHAR(125)
 );
 DESC tbl_test;
 INSERT INTO tbl_test(id, name)
 VALUES(0, '홍길동');
 SELECT * FROM tbl_test;
 SELECT * FROM tbl_test
 WHERE name = '홍길동';
 
 SELECT * FROM tbl_test
 WHERE id BETWEEN 5 AND 10;
 
 SELECT * FROM tbl_test
 WHERE name LIKE '홍%';
 
 SELECT * FROM tbl_test
 WHERE name LIKE '홍*';
 
 -- 단순 연산시 ORACLE과의 차이점은 FROM dual을 필요로 하지 않는다는 점이다
 SELECT 30 + 40;
 SELECT '대한' + '민국';
 SELECT '대한' & '민국';