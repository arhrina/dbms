-- root 계정의 비밀번호를 분실했을 때, 기존 등록된 다른 id로 로그인해서 수행
-- 단, 다른 id의 grant all 권한이 있어야한다

-- mysql 설치 후 새로운 사용자를 등록하고 grant all 하여 미리 생성해두면 root를 분실해도 가능하다

ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY '1234';



-- UTF-8
use emsdb;
drop table tbl_bbs;

CREATE TABLE tbl_bbs(
BBS_ID	BIGINT	AUTO_INCREMENT	PRIMARY KEY,
BBS_P_ID	BIGINT	DEFAULT 0	,
BBS_WRITER	VARCHAR(50)	NOT NULL	,
BBS_DATE	VARCHAR(10)		,
BBS_TIME	VARCHAR(10)		,
BBS_SUBJECT	VARCHAR(125)		,
BBS_CONTENT	VARCHAR(1000)		,
BBS_COUNT	INT	DEFAULT 0	
) char set utf8mb4; -- 8.0 이전버전, 특히 5.7 이하에서 한글을 사용하기 위해 utf-8 mb4를 지정. 8에서는 기본지정
-- varchar type의 칼럼에 문자열을 저장하면 영문, 숫자 등은 1개를 1byte, 기타 다국어는 1~4byte까지 가변되어 저장

INSERT INTO tbl_bbs(bbs_writer) values('대한민국');
INSERT INTO tbl_bbs(bbs_writer) values('12345678');

-- mysql에서는 현재 db schema가 어떤 encoding인지 확인하기위한 코드
SHOW SESSION VARIABLES LIKE 'collation_connection';

-- mysql 5.x 이하에서는 UTF8과 latin1 방식으로 설정되어 많은 문제를 일으켰었다
-- mysql 5.x 이하의 UTF8은 3byte 방식 가변저장방식으로 emoji와 같은 특수문자는 인식하지 못했다

SELECT * FROM tbl_bbs;



-- 스프링 프레임워크 BBS 만들 때 필요한 테이블 추가

CREATE TABLE tbl_menu(
MENU_ID	VARCHAR(3)	NOT NULL	PRIMARY KEY,
MENU_P_ID	VARCHAR(3)		,
MENU_TITLE	VARCHAR(10)	NOT NULL	,
MENU_HREF	VARCHAR(125)		
);

INSERT INTO `emsdb`.`tbl_menu`
VALUES ('M01', '', 'Home', '/');

INSERT INTO `emsdb`.`tbl_menu`
VALUES ('M02', '', '관리자', '#');
INSERT INTO `emsdb`.`tbl_menu`
VALUES ('M03', 'M02', '로그인', '#');
INSERT INTO `emsdb`.`tbl_menu`
VALUES ('M04', 'M02', '회원가입', '#');
INSERT INTO `emsdb`.`tbl_menu`
VALUES ('M05', 'M02', '게시판정리', '#');

SELECT * FROM tbl_menu;

UPDATE tbl_menu
SET menu_p_id=null
WHERE menu_id IN ('M01', 'M02');