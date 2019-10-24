-- ����� IOLIST ȭ���Դϴ�
-- �ŷ�ó���� ��2����ȭ ����

-- ���Ը��������� �ŷ�ó������ �ŷ�ó��� ��ǥ�� �ΰ��� Į���� �ִ�.
-- �ŷ�ó���� ������ ��ǥ�� �ٸ� �ŷ�ó�� ������ �ֱ� ������

-- ���Ը��⿡�� �ŷ�ó ���� ����
SELECT io_dname, io_dceo
FROM tbl_iolist
GROUP BY io_dname, io_dceo
ORDER BY io_dname ;

-- �ŷ�ó ���̺� ����
-- �ŷ�ó ���̺��� ���

-- �ŷ����� ����, ��ǥ�ڸ��� �ٸ� �����͸� UNIQE �����غ���
-- �Է��Ҷ� �ŷ���� ��ǥ�ڸ��� ���� ���� �����ʹ� INSERT���� �ʵ��� ����
CREATE TABLE tbl_dept (
    d_code	VARCHAR2(5)		PRIMARY KEY,
    d_name	nVARCHAR2(50)	NOT NULL,	
    d_ceo	nVARCHAR2(50)	NOT NULL,	
    d_tel	VARCHAR2(20),		
    d_addr	nVARCHAR2(125),		
    d_man	nVARCHAR2(50),
    CONSTRAINT UQ_name_ceo UNIQUE (d_name, d_ceo)
);
-- ���̺� �����Ŀ� �߰��� ���
ALTER TABLE tbl_dept 
ADD CONSTRAINT UQ_name_ceo 
UNIQUE (d_name, d_ceo) ;

SELECT COUNT(*)
FROM tbl_dept ;

-- �ŷ�ó���̺� �����ϰ� 
-- ���̺� �����͸� �ѹ� ��ȸ
-- �ŷ�ó���� ���� CEO�� �ٸ� �ŷ�ó�� �ִ� Ȯ��
-- ���� �ŷ�ó���� �ִ��� Ȯ��
-- �Ʒ� ������� COUNT�� 2�̻��� ������
SELECT d_name,COUNT(*), COUNT(d_name)
FROM tbl_dept
GROUP BY d_name
HAVING COUNT(*) > 1;

-- iolist�� dept ���̺��� EQ JOIN dept �����Ͱ� �� ����� ������ ����
SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name AND io_dceo = d_ceo ;

-- iolist �ŷ�ó �ڵ� Į�� ����
ALTER TABLE tbl_iolist ADD io_dcode VARCHAR2(5);

UPDATE tbl_iolist
SET io_dcode =
(
    SELECT d_code
    FROM tbl_dept
    WHERE io_dname = d_name AND io_dceo = d_ceo
);    

-- UPDATE �� ����
SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dcode = d_code ;

SELECT * FROM tbl_iolist ;

-- iolist���� io_dname, io_dceo Į�� ����
ALTER TABLE tbl_iolist DROP COLUMN io_dname ;
ALTER TABLE tbl_iolist DROP COLUMN io_dceo ;

SELECT * FROM tbl_iolist ;

/*
iolist�� ��2����ȭ�� �����ؼ� ��ǰ���� �ŷ�ó������ TABLE �и��ϼ�
iolist�� �ܰ�(io_price) Į���� �������� �ʰ� ������ �ϰ� �ִ� ����
iolist�� ����, ����ܰ��� ������ ��ǰ�� ���� ����Ǵ� ������ �����ɼ� �ִ�.
    ���ؼ��� ���� �Ҷ��� ������� ���� �Ҷ� �о�� ���� �Ҷ���
    �ܰ��� �޸� ����ȴ�.
    ���شܰ�(100��) : 1000, �������(1000��) : 900, �о��ܱ�(5000��) 700 
    iolist���� �������� ����ܰ��� ��ϵǾ
    �������� ���ذ����� ��´� : ������ ��곻��
    
    ȸ��� ���, ���ͱ��� ����Ҷ���
    ���Ը����� ������ �ܰ��� ����ϰԵǸ� ����� ����� ������� �ʿ��ϴ�.
    �׷��� ȸ��� ����� �Ҷ� ����� ǥ�شܰ��� product�� ������ �ΰ� ����Ѵ�.

*/
SELECT *
FROM tbl_iolist IO
    LEFT JOIN tbl_product P
        ON IO.io_pcode = P.p_code
    LEFT JOIN tbl_dept D
        ON IO.io_dcode = D.d_code
ORDER BY IO.io_date, IO.io_pcode ;        

CREATE VIEW VIEW_IOLIST
AS 
(
    SELECT 
        IO_SEQ AS SEQ,
        IO_DATE AS IODATE, -- date Ű���� ������!!!
        IO_INOUT AS INOUT,
        IO_DCODE AS DCODE,D_NAME AS DNAME,D_CEO AS DCEO,D_TEL AS DTEL,
        IO_PCODE AS PCODE,P_NAME AS PNAME,
        IO_QTY AS QTY,
        P_IPRICE AS IPRICE,P_OPRICE AS OPRICE,IO_PRICE AS PRICE,
        IO_AMT AS AMT
    FROM tbl_iolist IO
        LEFT JOIN tbl_product P
            ON IO.io_pcode = P.p_code
        LEFT JOIN tbl_dept D
            ON IO.io_dcode = D.d_code
);

SELECT * FROM view_iolist ;

-- ���԰� ���� �����ؼ� 
SELECT DECODE(INOUT,1,'����',2,'����'),
    DCODE,DNAME,DCEO,
    PCODE,PNAME,
    QTY, PRICE, AMT
FROM view_iolist ;

-- �ŷ�ó���� ����, ������ �հ�
-- �������ϴ� view
-- �ŷ�ó���� ����� �ִ� �ŷ������� ��Ƽ�
-- �����հ�, �����հ�� ����ʹ�.
-- 1. DECODE�� ����ؼ� INOUT Į������ �������� ����, ���ⱸ���� ����
-- 2. ���԰� ���� ���е� �׸��� SUM()���� �����ֱ�
-- 3. SUM() ������ ���� DCODE, DNAMEĮ���� GROUP BY ���� ����
SELECT DCODE, DNAME,
        SUM(DECODE(INOUT,1,AMT,0)) AS �����հ�,
        SUM(DECODE(INOUT,2,AMT,0)) AS �����հ�
FROM view_iolist
GROUP BY DCODE, DNAME
ORDER BY DNAME;

-- ������ ���Ը��� �հ�
-- 1. �ŷ����� Į������ ����� ����
--      SUBSTR(Į��,����, ����)
-- 2. DECODE�� ����ؼ� INOUT�� ���� ���Ը��� ����
-- 3. SUM()���� ����
-- 4. ���� ���� ������ GROUP BY�� ����
-- 5. 3�ڸ����� , ��� ���̱�
--      999,999 : ������� ����, ���� ǥ�õǴ� ������ �湮�� ū �ڸ��� ����
-- TO_CHAR() SQLD���� �Ϲ������� ȭ�麸������δ� ����� �ϵ�
-- �ٸ� ���� �����Ǵ� �κп����� ������ ����� ����
-- ���ڸ� ���ڿ�ȭ �Ͽ� ����Ҷ� ������� ������ ����
SELECT SUBSTR(IODATE,0,7) AS ��,
    TO_CHAR(SUM(DECODE(INOUT,1,AMT)),'999,999,999') AS �����հ�,
    TO_CHAR(SUM(DECODE(INOUT,2,AMT)),'999,999,999') AS �����հ�
FROM view_iolist
GROUP BY SUBSTR(IODATE,0,7)
ORDER BY SUBSTR(IODATE,0,7) ;

-- ��ü����Ʈ�� ��� Pivot
SELECT SEQ, IODATE,DNAME,PNAME,
    DECODE(INOUT,1,AMT,0) AS ����,
    DECODE(INOUT,2,AMT,0) AS ����
FROM view_iolist ;

-- 2018�� 1�⵿�� �� �����հ�, �� �����հ�
-- ����� ���� �������� ���̰� ��� ���� ���
-- BETWEEN Ű���带 ����Ͽ� ���� �˻��� ����
SELECT 
    SUM(DECODE(INOUT,1,AMT,0)) AS �Ѹ����հ�,
    SUM(DECODE(INOUT,2,AMT,0)) AS �Ѹ����հ�
FROM view_iolist
WHERE IODATE BETWEEN '2018-01-01' AND '2018-12-31' ;

-- LIKE�� ����ؼ� ����� �����Ҽ� ������
-- �����ϴ� �ڵ�� �ƴ�
SELECT 
    SUM(DECODE(INOUT,1,AMT,0)) AS �Ѹ����հ�,
    SUM(DECODE(INOUT,2,AMT,0)) AS �Ѹ����հ�
FROM view_iolist
WHERE IODATE LIKE '2018%' ;

-- ��ǰ������ ����� ���Ը��� �ܰ���
-- iolist�� ����� ���Ը��� �ܰ��� ���̸� �ѹ� ����
SELECT IPRICE, OPRICE, 
        DECODE(INOUT,1,PRICE,0) ����,
        DECODE(INOUT,2,PRICE,0) ����
FROM view_iolist ;

-- ��ǰ������ ���Ը��� ���̺��� 
-- ����ܰ��� ������ ����غ��� SQL
SELECT  
        PCODE, PNAME,
        IPRICE,
        DECODE(INOUT,1,PRICE,0) ����,
        
        DECODE(INOUT,1,IPRICE,0) 
        - DECODE(INOUT,1,PRICE,0) AS ��������,
        
        OPRICE, 
        DECODE(INOUT,2,PRICE,0) ����,
        
        DECODE(INOUT,2,OPRICE,0) 
        - DECODE(INOUT,2,PRICE,0) AS ��������
        
FROM view_iolist ;



-- SEQ �ڵ����� �ڵ�