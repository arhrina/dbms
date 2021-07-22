/* FK 외래키, 참조무결성
2개 이상의 테이블을 EQ JOIN했을 때 연관되어있는 정보들 가운데 원하는 모든 데이터가 보여진다 란 조건
FK 설정되는 테이블은 1:N의 관계로 설정

테이블을 외래키로 지정하여 참조무결성관계를 설정할 때, 테이블을 생성할 때 MySQL의 경우 ENGINE 옵션을 추가해주는 것이 좋다
character set을 통일시켜주어야한다. 5점대 MYSQL 버전은 기본값이 InnoDB이다

외래키설정을 하기 위해서는 해당하는 컬럼들은 타입, 크기가 동일해야한다

1:N의 관계일 때, 1에 해당하는 테이블의 컬럼은 반드시 PK로 선언해야한다
N에 해당하는 테이블의 컬럼은 가급적 NOT NULL로 선언한다
*/
USE myDB;
DESC tbl_score2;
/*
s_id	int(11)	NO	PRI
s_std	varchar(5)	NO	
s_subject	varchar(5)	YES	MUL
s_score	int(3)	NO	
s_rem	varchar(50)	YES	
*/
-- s_subject와 sb_code와 연관. MUL Key => 1:N 관계로 연관

CREATE TABLE tbl_score2(
s_id	int(11)	PRIMARY KEY,
s_std	varchar(5)	NOT NULL	,
s_subject	varchar(5)	NOT NULL,
s_score	int(3)	NOT NULL,
s_rem	varchar(50)	
) ENGINE = InnoDB character set = 'UTF-8'; -- 필요에 따라 character set은 다를 수 있지만 외래키와 설정되는 테이블들은 같아야한다

DESC tbl_subject;
/*
sb_code	varchar(5)	NO	PRI
sb_name	varchar(20)	NO	
sb_pro	varchar(20)	YES	
*/

-- N의 테이블을 ALTER
-- 1의 테이블은 REFERENCE 설정
ALTER TABLE tbl_score2
ADD CONSTRAINT FK_01
FOREIGN KEY (s_subject)
REFERENCES tbl_subject(sb_code);

ALTER TABLE tbl_score2
DROP FOREIGN KEY FK_SCORE_SUBJECT;
-- Oracle은 DROP CONSTRAINT FK_SCORE_SUBJECT;

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS; -- MySQL DB사전(스키마)에서 제약조건들을 확인
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_name = 'tbl_score2';

-- tbl_score2와 tbl_subject를 외래키로 설정(참조무결성 관계, Relationship 설정)tbl_score2
-- N테이블에 있으면 1테이블에 반드시 있고, 1테이블에 있으면 N테이블엔 있을 수도 있으며, 1테이블에 없으면 N테이블에 절대 존재할 수 없다
-- N테이블에 데이터가 있으면 1테이블은 수정, 삭제가 불가능하다. 1테이블이 있더라도 N테이블은 수정, 삭제가 자유롭다
-- 초기 대량데이터를 넣을 때 FK를 설정하지 않고 입력한 뒤에 추가로 FK를 설정하는 것이 좋다

INSERT INTO tbl_score2(s_std, s_subject, s_score)
VALUES('S0001', 'B0100', 100);
-- tbl_subject에 아직 등록되지 않은 B0100으로 데이터 삽입 시도
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`mydb`.`tbl_score2`, CONSTRAINT `FK_01` FOREIGN KEY (`s_subject`) REFERENCES `tbl_subject` (`sb_code`))
-- 아직 tbl_subject 테이블에 sb_code가 B0100이 없는 상태에서 입력을 시도하니 foreign key 조건에 fail되어 cannot add

-- tbl_subject에 sb_code B0100을 입력해야 위 입력이 가능해진다
INSERT INTO tbl_subject(sb_code, sb_name)
VALUES('B0100', '화학');
SELECT * FROM tbl_subject;
INSERT INTO tbl_score2(s_std, s_subject, s_score)
VALUES('S0001', 'B0100', 100); -- 이제 가능해진다
-- 등록하고 나니 sb_code가 B0100이 아니라 B0005를 입력했어야했다면
UPDATE tbl_subject
SET sb_code = 'B0005'
WHERE sb_code = 'B0100';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`mydb`.`tbl_score2`, CONSTRAINT `FK_01` FOREIGN KEY (`s_subject`) REFERENCES `tbl_subject` (`sb_code`))
-- 이미 N테이블에 해당하는 FK를 사용하여 입력이 되어있어 제약조건 때문에 실행이 불가능하다
-- N테이블에 FK를 참조하는 데이터가 없다면 변경, 삭제가 가능하다

-- subject table의 sb_code값 변경을 허용하여 sb_code를 변경하면 서로 참조하여 연결된 테이블들의 해당 컬럼(s_subject)을 자동으로 업데이트하는 방법
ALTER TABLE tbl_score2
DROP FOREIGN KEY FK_01;

ALTER TABLE tbl_score2
ADD CONSTRAINT FK_01
FOREIGN KEY (s_subject)
REFERENCES tbl_subject(sb_code)
ON UPDATE CASCADE
ON DELETE CASCADE;
-- 기존의 FK를 삭제하고, 다시 FK를 연결하면서 연관된 컬럼도 같이 업데이트 되도록 키워드 ON UPDATE CASCADE를 추가. 삭제시에도 같이 삭제되는 키워드 ON DELETE CASCADE
-- ON UPDATE CASCADE와 DELETE CASCADE는 DB 설계 당시 어떻게 정책을 수립하느냐에 따라 결정해서 사용한다

UPDATE tbl_subject
SET sb_code = 'B0005'
WHERE sb_code = 'B0100'; -- tbl_subject의 sb_code만 교체했지만 참조하고 있는 tbl_score2의 s_subject가 B0100인 것도 자동으로 교체된다
SELECT * FROM tbl_score2;
SELECT * FROM tbl_subject;