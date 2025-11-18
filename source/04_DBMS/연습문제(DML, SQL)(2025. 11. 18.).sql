-- =============================================
-- [실행 순서] 1→2→3→4단계를 순차적으로 실행한 후, 5단계 문제 풀이 실행
-- =============================================

-- =============================================
-- 1단계: 데이터베이스 생성 (처음 한 번만 실행)
-- =============================================
CREATE DATABASE IF NOT EXISTS exam_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- =============================================
-- 2단계: 데이터베이스 선택 (반드시 실행!)
-- =============================================
USE exam_db;

-- =============================================
-- 3단계: 테이블 생성 (한 번만 실행)
-- =============================================
DROP TABLE IF EXISTS personal;
DROP TABLE IF EXISTS division;

CREATE TABLE division(
    dno INT PRIMARY KEY,
    dname VARCHAR(20) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    position VARCHAR(20)
);

CREATE TABLE personal(
    pno INT PRIMARY KEY,
    pname VARCHAR(20) NOT NULL,
    job VARCHAR(20) NOT NULL,
    manager INT,
    startdate DATE,
    pay INT,
    bonus INT,
    dno INT,
    FOREIGN KEY(dno) REFERENCES division(dno)
);

-- =============================================
-- 4단계: 테스트 데이터 삽입 (한 번만 실행)
-- =============================================
INSERT INTO division VALUES 
(10, '인사부', '02-1234-5678', '1층'),
(20, '영업부', '02-2345-6789', '2층'),
(30, '기술부', '02-3456-7890', '3층');

INSERT INTO personal VALUES 
(1001, 'kim', '사원', 1005, '2023-01-15', 2500, 500, 10),
(1002, 'park', '과장', 1005, '2022-03-20', 4000, NULL, 20),
(1003, 'steve', '대리', 1005, '2022-07-01', 3000, 300, 10),
(1004, 'sam', '부장', NULL, '2021-05-10', 5000, 1000, 30),
(1005, 'choi', '이사', NULL, '2020-01-01', 6000, 1500, 20);

-- =============================================
-- 5단계: 문제 풀이 (아래 각 문제를 선택해서 실행)
-- =============================================

-- 1. 사번, 이름, 급여를 출력
SELECT pno, pname, pay FROM personal;

-- 2. 급여가 2000~5000 사이 모든 직원의 모든 필드
SELECT * FROM personal WHERE pay BETWEEN 2000 AND 5000;

-- 3. 부서번호가 10또는 20인 사원의 사번, 이름, 부서번호
SELECT pno, pname, dno FROM personal WHERE dno IN (10, 20);

-- 4. 보너스가 null인 사원의 사번, 이름, 급여 (급여 큰 순 정렬)
SELECT pno, pname, pay FROM personal WHERE bonus IS NULL ORDER BY pay DESC;

-- 5. 사번, 이름, 부서번호, 급여. 부서코드 순 정렬, 같으면 급여 큰순
SELECT pno, pname, dno, pay FROM personal ORDER BY dno ASC, pay DESC;

-- 6. 사번, 이름, 부서명 (부서 없는 사원도 출력)
SELECT p.pno, p.pname, d.dname 
FROM personal p 
LEFT JOIN division d ON p.dno = d.dno;

-- 7. 사번, 이름, 상사이름 (상사 없는 사원도 출력)
SELECT p.pno, p.pname, m.pname AS manager_name 
FROM personal p 
LEFT JOIN personal m ON p.manager = m.pno;

-- 8. 사번, 이름, 상사이름(상사가 없는 경우 ★CEO★ 출력)
SELECT p.pno, p.pname, IFNULL(m.pname, '★CEO★') AS manager_name 
FROM personal p 
LEFT JOIN personal m ON p.manager = m.pno;

-- 8-1. 사번, 이름, 상사사번(상사가 없으면 'ceo'로 출력)
SELECT pno, pname, IFNULL(manager, 'ceo') AS manager FROM personal;

-- 8-2. 사번, 이름, 상사이름, 부서명(상사가 없는 사람도 출력)
SELECT p.pno, p.pname, IFNULL(m.pname, '★CEO★') AS manager_name, d.dname 
FROM personal p 
LEFT JOIN personal m ON p.manager = m.pno 
LEFT JOIN division d ON p.dno = d.dno;

-- 9. 이름이 's'로 시작하는 사원 이름 (대소문자 구분)
SELECT pname FROM personal WHERE pname LIKE BINARY 's%';

-- 10. 사번, 이름, 급여, 부서명, 상사이름 (모든 사원 출력)
SELECT p.pno, p.pname, p.pay, d.dname, m.pname AS manager_name 
FROM personal p 
LEFT JOIN division d ON p.dno = d.dno 
LEFT JOIN personal m ON p.manager = m.pno;