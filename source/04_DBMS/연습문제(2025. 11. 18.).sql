-- =============================================
-- 1. 기존 객체 삭제 (존재하는 경우)
-- =============================================

-- 기존 MEMBER 테이블 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MEMBER CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('MEMBER 테이블이 존재하지 않습니다.');
END;
/

-- 기존 MEMBER_LEVEL 테이블 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE MEMBER_LEVEL CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('MEMBER_LEVEL 테이블이 존재하지 않습니다.');
END;
/

-- 기존 시퀀스 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE MEMBER_MNO_SQ';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('MEMBER_MNO_SQ 시퀀스가 존재하지 않습니다.');
END;
/

-- =============================================
-- 2. MEMBER_LEVEL 테이블 생성
-- =============================================
CREATE TABLE MEMBER_LEVEL (
    LEVELNO   NUMBER(1)      PRIMARY KEY,
    LEVELNAME VARCHAR2(20)   NOT NULL
);

-- =============================================
-- 3. MEMBER 테이블 생성
-- =============================================
CREATE TABLE MEMBER (
    mNO       NUMBER(4)      PRIMARY KEY,
    mNAME     VARCHAR2(20)   NOT NULL,
    mPW       VARCHAR2(8)    NOT NULL,
    mEMAIL    VARCHAR2(30)   UNIQUE,
    mPOINT    NUMBER(9)      CHECK (mPOINT >= 0),
    mRDATE    DATE           DEFAULT SYSDATE,
    LEVELNO   NUMBER(1),
    CONSTRAINT MEMBER_LEVELNO_FK 
        FOREIGN KEY (LEVELNO) 
        REFERENCES MEMBER_LEVEL(LEVELNO)
);

-- =============================================
-- 4. 제약조건 추가 (mPW 길이 체크)
-- =============================================
ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_MPW_CHK 
    CHECK (LENGTH(mPW) BETWEEN 1 AND 8);

-- =============================================
-- 5. 시퀀스 생성
-- =============================================
CREATE SEQUENCE MEMBER_MNO_SQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- =============================================
-- 6. 자동 증가 트리거 생성
-- =============================================
CREATE OR REPLACE TRIGGER MEMBER_MNO_TRG
BEFORE INSERT ON MEMBER
FOR EACH ROW
BEGIN
    IF :NEW.mNO IS NULL THEN
        :NEW.mNO := MEMBER_MNO_SQ.NEXTVAL;
    END IF;
END;
/

-- =============================================
-- 7. MEMBER_LEVEL 데이터 입력 (수정된 레벨명)
-- =============================================
-- 기존: 0-Black, 1-Bronze, 2-Silver
-- 수정: 0-블랙리스트, 1-일반고객, 2-실버고객
INSERT INTO MEMBER_LEVEL VALUES (0, '블랙리스트');
INSERT INTO MEMBER_LEVEL VALUES (1, '일반고객');
INSERT INTO MEMBER_LEVEL VALUES (2, '실버고객');

COMMIT;

-- =============================================
-- 8. MEMBER 데이터 입력 (수정된 회원명)
-- =============================================
-- 1번 회원: 홍길동
INSERT INTO MEMBER (mNAME, mPW, mEMAIL, mPOINT, mRDATE, LEVELNO) 
VALUES ('홍길동', 'aa1234', 'hong@hong.com', 0, TO_DATE('25/11/18', 'YY/MM/DD'), 1);

-- 2번 회원: 신길동
INSERT INTO MEMBER (mNAME, mPW, mEMAIL, mPOINT, mRDATE, LEVELNO) 
VALUES ('신길동', 'bb5678', 'sin@sin.com', 1000, TO_DATE('22/04/01', 'YY/MM/DD'), 2);

COMMIT;

-- =============================================
-- 9. 데이터 확인 (수정된 출력)
-- =============================================
SELECT 
    m.mNO,
    m.mNAME,
    TO_CHAR(m.mRDATE, 'YYYY-MM-DD') AS MRDate,
    m.mEMAIL,
    m.mPOINT AS point,
    l.LEVELNAME AS levelname
FROM MEMBER m
LEFT JOIN MEMBER_LEVEL l ON m.LEVELNO = l.LEVELNO
ORDER BY m.mNO;