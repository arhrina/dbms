CREATE TABLE tbl_todoList (

    td_seq	NUMBER		PRIMARY KEY,
    td_date	VARCHAR2(10)	NOT NULL,	
    td_time	VARCHAR2(8)	NOT NULL,	
    td_subject	nVARCHAR2(125)	NOT NULL,	
    td_text	nVARCHAR2(1000)	,	
    
    -- insert�� �����Ҷ� ���� �߰����� ������ �⺻������ Į���� ä����
    -- DEFAULT �׸��� �����Ǹ� ����Ŭ������ NOT NULL�� ������ �ȴ�
    td_flag	VARCHAR2(1)	DEFAULT '1'	,
    td_complete	VARCHAR2(1)	DEFAULT 'N'	,
    td_alarm	VARCHAR2(1)	DEFAULT 'N'	

);

CREATE SEQUENCE seq_todo 
START WITH 1 INCREMENT BY 1;

INSERT INTO tbl_todolist(td_seq, td_date, td_time,td_subject)
VALUES(0,'2019-12-31','10:00:00','����ȸ');

SELECT * FROM tbl_todolist;




