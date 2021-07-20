DESC tbl_books;

UPDATE tbl_books
SET b_price = ROUND(DBMS_RANDOM.VALUE(10000, 50000)); -- tbl_books의 모든 b_price를 10000~50000의 임위의 값으로 업데이트하기
SELECT * FROM tbl_books;

COMMIT;