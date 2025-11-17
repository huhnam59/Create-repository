-- =============================================
-- 1. 기존 테이블 삭제 (존재하는 경우, 의존성 고려)
-- =============================================
DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS MAJOR;


-- =============================================
-- 2. MAJOR 테이블 생성
-- =============================================
CREATE TABLE MAJOR (
    mCODE   INT PRIMARY KEY,
    mNAME   VARCHAR(50) NOT NULL,
    mOFFICE VARCHAR(50)
);


-- =============================================
-- 3. STUDENT 테이블 생성 (점수 제약조건 포함)
-- =============================================
CREATE TABLE STUDENT (
    SNO    INT PRIMARY KEY,
    SNAME  VARCHAR(50) NOT NULL,
    SSCORE INT CHECK (SSCORE >= 0 AND SSCORE <= 100),  -- 점수는 0~100점 사이
    mCODE  INT,
    FOREIGN KEY (mCODE) REFERENCES MAJOR(mCODE)  -- 전공코드 외래키
);


-- =============================================
-- 4. MAJOR 테이블 데이터 입력
-- =============================================
INSERT INTO MAJOR (mCODE, mNAME, mOFFICE) VALUES
(1, 'A101호', 'A101실'),
(2, 'A102호', 'A102실');


-- =============================================
-- 5. STUDENT 테이블 데이터 입력
-- =============================================
INSERT INTO STUDENT (SNO, SNAME, SSCORE, mCODE) VALUES
(101, '99',   1, 1),  -- 학번 101, 이름 '99', 점수 1, 전공코드 1
(102, '100',  2, 2);  -- 학번 102, 이름 '100', 점수 2, 전공코드 2


-- =============================================
-- 6. 최종 조회 SQL (실행화면 결과)
--    - 학생정보와 전공정보를 조인하여 출력
--    - 출력순서: 학번(SNO) 오름차순
-- =============================================
SELECT 
    s.SNO,
    s.SNAME,
    s.SSCORE,
    m.mOFFICE
FROM STUDENT s
     INNER JOIN MAJOR m ON s.mCODE = m.mCODE
ORDER BY s.SNO;