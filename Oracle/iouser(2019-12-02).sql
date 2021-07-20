DESC tbl_memo;

ALTER TABLE tbl_memo ADD M_CAT nVARCHAR2(50);

CREATE SEQUENCE seq_memo START WITH 100 INCREMENT BY 1;
INSERT INTO tbl_memo(m_seq, m_subject, m_auth, m_date, m_time) VALUES(seq_memo.NEXTVAL, '과제', 'leeheehyun', '2019-12-02', '15:00:00');
INSERT INTO tbl_memo(m_seq, m_subject, m_auth, m_date, m_time) VALUES(seq_memo.NEXTVAL, '영화보기', 'leeheehyun', '2019-12-02', '15:00:00');

COMMIT;