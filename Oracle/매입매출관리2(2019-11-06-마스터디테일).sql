-- Master Detail Table 관계설정
CREATE TABLE tbl_master(
m_seq NUMBER PRIMARY KEY,
m_subject nVARCHAR2(1000) NOT NULL
);

-- DEFAULT. INSERT 수행시 값을 지정하지 않으면 NULL이 아니라 해당하는 기본값을 넣어라
CREATE TABLE tbl_detail(
d_seq NUMBER PRIMARY KEY,
d_m_seq NUMBER NOT NULL,
d_subject nVARCHAR2(1000) NOT NULL,
d_ok VARCHAR2(1) DEFAULT 'N'
);

CREATE SEQUENCE SEQ_MASTER
START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE SEQ_DETAIL
START WITH 1 INCREMENT BY 1;

ALTER TABLE tbl_detail
ADD CONSTRAINT FK_MD
FOREIGN KEY (d_m_seq)
REFERENCES tbl_master(m_seq);

INSERT INTO tbl_master(m_seq, m_subject)
VALUES(SEQ_MASTER.NEXTVAL, '다음 OSI 7계층 중 가장 하위 계층으로 올바른 것은?');

SELECT * FROM tbl_master;

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, '전송계층'); -- 여러사람이 접근하는 웹상에선 SEQ_MASTER.CURRVAL이 현재값이라고 장담할 수 없다

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, '세션계층');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject, d_ok)
VALUES(SEQ_DETAIL.NEXTVAL, 1, '물리계층', 'Y');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, 1, '네트워크계층계층');

SELECT * FROM tbl_master, tbl_detail
WHERE m_seq = d_m_seq;
-- table 2개를 제1정규화 방식으로 보기
-- 반드시 master table의 seq를 가져와야한다

commit;

INSERT INTO tbl_master(m_seq, m_subject)
VALUES(SEQ_MASTER.NEXTVAL, '다음 중 사용자의 데이터가 저장되는 메모리는?');
INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, 'ROM'); -- 여러사람이 접근하는 웹상에선 SEQ_MASTER.CURRVAL이 현재값이라고 장담할 수 없다

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject, d_ok)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, 'RAM', 'Y');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, 'Cache');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, 'Register');
commit;