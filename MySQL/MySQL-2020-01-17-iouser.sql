create user 'iouser'@'localhost' identified by '1234'; -- 유저를 생성할 때 뒤에 주소를 등록하는 방법과 id만 등록하는 방법 2가지가 있다
grant all privileges on *.* TO 'iouser'@'localhost';

create user 'iouser'@'%' identified by '1234'; -- 유저를 생성할 때 뒤에 주소를 등록하는 방법과 id만 등록하는 방법 2가지가 있다
grant all privileges on *.* TO 'iouser'@'%';


-- mysql에서는 사용자를 등록할 때 접속경로를 설정하도록 되어있다
-- @lohcalhost가 붙은 iouser는 localhost에서만 접속할 수 있다
-- 본인 컴퓨터, 현재 접속하는 서버에서만 접근이 가능
-- @%가 붙은 iouser는 모든 곳에서 원격으로 접속할 수 있다

create user 'iouser'@'192.168.%' identified by '1234';
-- ip가 192.168.*.*에서만 접속허가
grant all privileges on *.* TO 'iouser'@'192.168.%';
-- 권한부여

-- 2020-01-21
-- 새로운 사용자 등록 및 권한등록
create user 'ems'@'localhost' identified by 'ems';
grant all privileges on *.* TO 'ems'@'localhost';

create user 'ems'@'%' identified by 'ems';
grant all privileges on *.* TO 'ems'@'%';

-- schema DB 생성
CREATE DATABASE emsDB;

-- table을 STS에서 만들어서 워크벤치에서 확인
use emsDB;
DROP TABLE tbl_ems;
SHOW TABLES;