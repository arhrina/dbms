-- user2
SELECT * FROM tbl_address;

UPDATE tbl_address SET age = 33 WHERE id = 5;

UPDATE tbl_address SET age = 0 WHERE id = 4;

SELECT * FROM tbl_address;

SELECT * FROM tbl_address WHERE age IS NULL;

SELECT * FROM tbl_address WHERE age IS NOT NULL;

-- 데이터를 대량으로 추가 한 후 중요 칼럼에 데이터를 누락시키지 않았나 체크할 때 NOT NULL, NULL 조건을 사용하여 확인

UPDATE tbl_address SET chain = '' WHERE id = 3;
SELECT * FROM tbl_address;

-- ORACLE에서는 ''(아무런 문자열이 없는 문자열)는 NULL과 같은 것으로 취급

UPDATE tbl_address SET chain = ' ' WHERE id = 3;
SELECT * FROM tbl_address;

-- ' '(스페이스로 띄어쓰기, WHITE SPACE)는 데이터로 취급

SELECT * FROM tbl_address WHERE addr IS NULL;
SELECT * FROM tbl_address WHERE addr IS NOT NULL;

UPDATE tbl_address SET chain = '001' WHERE id = 1;
UPDATE tbl_address SET chain = '001' WHERE id = 2;
UPDATE tbl_address SET chain = '002' WHERE id = 3;
UPDATE tbl_address SET chain = '003' WHERE id = 4;
UPDATE tbl_address SET chain = '003' WHERE id = 5;

SELECT * FROM tbl_address/* WHERE chain IS NOT NULL*/;
-- 레코드를 확인했더니 CHAIN은 알수없는 숫자값들로 저장되어 있다
-- 001은 가족, 002는 친구, 003은 이웃이라고 하니 SELECT 시 001이면 가족, 002면 친구, 003이면 이웃이란 문자로 보여지게 만들기
-- DB마다 조금씩 다르다. 이 명령은 오라클 전용 명령

SELECT id, name, addr, chain,
DECODE(chain, '001', '가족') FROM tbl_address; -- DECODE는 오라클 전용 명령. DECODE(column, 조건값, true일 경우, 아닐 경우). 다른 DB는 If(), IIF()

SELECT id, name, addr, chain,
DECODE(chain, '001', '가족', DECODE(chain, '002', '친구',  DECODE(chain, '003', '이웃'))) AS 관계  FROM tbl_address;
    
SELECT id, name, addr, chain,
DECODE(chain, '001', '가족', '002', '친구','003', '이웃') AS 관계 FROM tbl_address;
    
-- 관계항목에 NULL이 존재한다는 것은 CHAIN에 001, 002, 003이 아니거나(값이 잘못입력) 조건식이 잘못된 경우

SELECT id, name, addr, chain,
DECODE(chain, '001', '가족', '002', '친구','003', '이웃') AS 관계 FROM tbl_address WHERE DECODE(chain, '001', '가족', '002', '친구','003', '이웃') IS NULL;
-- 결과값이 있다면, chain에 잘못된 값이 입력되어 있는 것으로 간주할 수 있다

INSERT INTO tbl_address (id, name, tel, chain) VALUES (6, '장보고', '010-777-7777', '101');
SELECT id, name, addr, chain,
DECODE(chain, '001', '가족', '002', '친구','003', '이웃') AS 관계 FROM tbl_address WHERE DECODE(chain, '001', '가족', '002', '친구','003', '이웃') IS NULL;
-- 테스트케이스의 chain 값이 101, SELECT 수행시 1개가 조회됨 => chain이 null이 아닌 상태에서의(빈 값은 아닌 상태) 데이터가 잘못되었음을 보여준다
-- SELECT는 이러한 방식으로 원치 않는 잘못된 값이 입력됐는지 검증하는 SQL문으로 쓰이기도 한다

SELECT * FROM tbl_address; -- 아무 조건 없이 tbl_address TABLE의 데이터들을 조회
/* projection을 *로 표현하면 모든 column을 조회. 원하는 순서대로 보여진다는 보장은 없다. projection을 칼럼들의 나열로 순서를 지정해주면 원하는 순서로 볼 수 있다
모든 column이 필요없다면 보고자하는 칼럼만 나열하면 된다
*/
SELECT id, name, tel, addr, chain, birth, age FROM tbl_address;
SELECT id, name, tel FROM tbl_address;

-- 데이터에 원하는 조건을 부여하여 필요한 데이터들만을 조회할 수 있다. SELECT [projection] FROM [table] WHERE [조건]
SELECT * FROM tbl_address WHERE name = '홍길동';
SELECT * FROM tbl_address WHERE name = '이몽룡';

INSERT INTO tbl_address(id, name, tel)
VALUES(10, '조덕배', '010-222-2222');

INSERT INTO tbl_address(id, name, tel)
VALUES(9, '조용필', '010-333-2222');

-- DBMS는 INSERT의 순서를 보장하지 못한다

INSERT INTO tbl_address(id, name, tel)
VALUES(8, '양희은', '011-333-2222');
SELECT * FROM tbl_address;

-- ORDER BY절을 추가해 레코드를 조회할 때 특정칼럼을 기준으로 정렬을 수행하여 보이기
SELECT * FROM tbl_address ORDER BY name ASC; -- 오름차순 ASC. ASCENDING. 생략시 default는 오름차순.
SELECT * FROM tbl_address ORDER BY id DESC; -- 내림차순 DESC. DESCENDING
SELECT * FROM tbl_address ORDER BY name, id; -- DEFAULT는 오름차순. name기준 한번 오름차순 정렬 후 id로 오름차순 정렬
SELECT * FROM tbl_address ORDER BY name, id DESC; -- 이름은 오름차순으로 먼저 정렬하고, 먼저 정렬한 레코드에 동일한 값이 있다면 해당 레코드들만 id로 내림차순 정렬
-- PK는 중복값이 나올 수 없으므로 order by에 첫 정렬을 pk로 하면 그 뒤에 칼럼들은 성능만을 떨어뜨리는 쓸모없는 코드이다

COMMIT;