-- 주석(Remark)문은 --로 시작한다
-- 모든 명령문이 끝나는 곳에 ;을 붙여야한다
-- 오라클의 모든 키워드는 대소문자를 구분하지 않고 인식한다
-- KEYWORD는 모두 대문자로
-- keyword가 아닌건 소문자로

-- 문자열이나 특별한 경우는 대소문자를 구별하는 경우도 있다
-- 이 때는 대소문자 구분을 공지한다

SELECT 30 + 40 FROM dual;
select 30 * 40 from dual;

SELECT 30 + 40, 30 * 40, 40 / 2, 50 - 10 FROM dual;

SELECT '대한민국' FROM dual;
SELECT '대한' || '민국' FROM dual;
SELECT '대한', '민국', '만세', 'KOREA' FROM dual;
-- ,는 데이터를 조회할 때(SELECT할 때) TABLE로 보여줄 때 column으로 구분하여 보여준다
-- 문자열은 작은 따옴표(Single Quote)으로 묶어준다. 문자열을 연결할 때는 ' || ' 로 한다

SELECT * FROM dual;
-- 조회할 때 SELECT * FROM ~~명령문을 사용하면 모든 것을 보여달라는 의미다

SELECT * FROM v$database;