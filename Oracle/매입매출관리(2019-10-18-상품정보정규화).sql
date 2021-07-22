-- IOLIST ����� ȭ��
SELECT * FROM tbl_product ;

-- ��ǰ���� ���̺��� �ǸŰ����� �������� �����ϰ� 0���� ����
-- �ǸŰ��� = ROUND(�ǸŰ��� / 10,0) * 10

-- �� 1���̻���(��ü) �����͸� ������� UPDATE, DELETE�� �����Ҷ���
--      �׻� �����ϰ� �ڵ带 �����ؼ� ��������
UPDATE tbl_product 
SET p_oprice = ROUND(p_oprice / 10,0) * 10 ;

SELECT * FROM tbl_product ;

-- ���Ը������ ��ǰ������ ���̺� JOIN �ϱ� ����
-- 1. ���Ը����忡 ��ǰ�ڵ� Į���� �߰��ϰ�
-- 2. ��ǰ�̸��� ����� ��ǰ�ڵ�� ������Ʈ�ϰ�
-- 3. ��ǰ�̸� Į�� ����

-- 1. ���Ը����忡 ��ǰ�ڵ� Į�� �߰�
ALTER TABLE tbl_iolist ADD io_pcode VARCHAR2(6) ;

-- 2. ���������� ��ǰ�ڵ� Į���� ������Ʈ
--  ���������� ����ؼ�
--  UPDATE ���࿡�� ���ǻ���
--      UPDATE�� �����ϴ� SUBQ�� SELECT Projection����
--      Į���� 1���� ����ؾ� �Ѵ�.
--      SUBQ���� ��Ÿ�� ���ڵ���� �ݵ�� 1���� ��Ÿ���� �Ѵ�.

-- ���Ը������̺� ����Ʈ�� �����ϰ�
-- �� ����� ��ǰ�̸��� SUBQ�� ����
-- SUBQ������ ��ǰ���̺�� ���� ��ǰ�̸��� ��ȸ�Ͽ�
-- ��ġ�ϴ� ���ڵ尡 1�� ��Ÿ����
-- �ش緹�ڵ��� ��ǰ�ڵ� Į���� ���� 
-- ���Ը���Į���� ��ǰ�ڵ� Į���� ������Ʈ �϶�
UPDATE tbl_iolist IO
SET io_pcode =
(
    SELECT p_code
    FROM tbl_product P
        WHERE IO.io_pname = P.p_name 
);

-- ������Ʈ�Ŀ� ����
-- iolist�� product�� EQ JOIN�� �����ؼ�
-- ������ �����Ͱ� ������ Ȯ��
-- �� ���̺� JOIN�� �����ϸ鼭 TABLE alias�� �������� �ʰ�
--      JOIN ���ǵ��� ����ߴ�
--      JOIN�Ǵ� table�鿡 JOIN�������� 
--      ���Ǵ� Į���� �̸��� ���� ���� ��쿡 ������ �ڵ�
SELECT COUNT(*)
FROM tbl_iolist, tbl_product
    WHERE io_pcode = p_code ;

-- ���Ը������̺��� ��ǰ�̸� Į���� ����
ALTER TABLE tbl_iolist DROP COLUMN io_pname ;

/*

 ����Ŭ���� INSERT, UPDATE, DELETE�� ������ ���Ŀ���
 ���� �����Ͱ� COMMIT ���� �ʾƼ�
 ���� ������ ���̺��� ������ ���� ���� �����̴�
 �̶��� ROLLBACK�� �����ؼ� CUD�� ����Ҽ� �ִ�.
 
 ��,
 DDL ���(CREATE, ALTER, DROP)�� �����ϸ�
 �ڵ� COMMIT�� �ȴ�.
 
 �뷮�� INSERT, UPDATE, DELETE�� ������ ��
 ������ ������ �Ϸ�Ǹ� ������ COMMIT�� �����ϰ�
 �������� ��������
 
 ����Ŭ������
 COMMIT�� ROLLBACK�� ������ �����ؼ�
 ������ ROLLBACK�� �Ұ����� �����Ҽ��� �ִ�
 
 */

-- pcode���� JOIN �����ؼ� ����
SELECT COUNT(*)
FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code ;