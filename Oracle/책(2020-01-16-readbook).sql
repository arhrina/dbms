/*
EQ join을 해서 독서록과 도서정보를 연계
tbl_read_book과 tbl_books 테이블이 FK로 참조관계가 설정되어 있으므로
EQ join을 사용할 수 있다. 참조무결성이 되어있지 않으면 left join을 사용해야함
*/

SELECT
RB_SEQ,
RB_BCODE,
B_NAME AS RB_BNAME,
RB_DATE,
RB_STIME,
RB_RTIME,
RB_SUBJECT,
RB_TEXT,
RB_STAR
FROM tbl_read_book R, tbl_books B WHERE R.rb_bcode = b.b_code;