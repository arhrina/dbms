-- iolist2

CREATE TABLE tbl_iolist(
io_seq	NUMBER		PRIMARY KEY,
io_date	VARCHAR2(10)	NOT NULL	,
io_pname	nVARCHAR2(25)	NOT NULL	,
io_dname	nVARCHAR2(25)	NOT NULL	,
io_dceo	nVARCHAR2(25)	NOT NULL	,
io_input	nVARCHAR2(2)	NOT NULL	,
io_qty	NUMBER	NOT NULL	,
io_price	NUMBER		,
io_total	NUMBER		
);

DESC tbl_iolist;