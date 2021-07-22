use emsDB;
CREATE TABLE tbl_friend(
f_id BIGINT primary key AUTO_INCREMENT,
f_name VARCHAR(20),
f_tel VARCHAR(11),
f_addr VARCHAR(100),
f_hobby VARCHAR(20),
f_relat VARCHAR(20)
);

INSERT INTO tbl_friend(
f_name,
f_tel,
f_addr
)

VALUES(
'홍길동',
'01034111111',
'광주광역시'
);

select * from tbl_friend;