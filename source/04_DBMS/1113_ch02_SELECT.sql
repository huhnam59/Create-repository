--[II] SELECT문 - 조회

-- 1. SELECT 문장 작성법
SELECT * FORM TAB; --현계정(SCOTT)이 가지고 있는 테이블 정보(실행:CTRL+ENTER)
SELECT * FROM DEFT; --DEPT 테이블의 모든 열, 모든 행
SELECT * FROM SAALGRADE; --SALGRADE 테이블이 모든 열, 모든 행
SELECT * FROM EMP; -- EMP 테이블이 모든 열, 모든 행

-- 2. 특정 열만 출력
DESC EMP;
   -- EMP 테이블의 구조
SELECT EMPNO, ENAME,SAL, JOB FROM EMP; -- EMP테이블의 SELECT절의 모든 지정된 열만 출력
SELECT EMPNO AS "사 번", ENMME AS "이 름", SAL AS "급여", JOB AS "직책"
      FROM EMP;  -- 열 이름에 별칭을 두는 경우 EX. 열이름 AS 별칭
SELECT EMPNO  "사 번", ENMME  "이 름", SAL  "급 여", JOB 
      FROM EMP;  -- 열 이름에 별칭을 두는 경우 EX. 열이름 "별칭", 열이름
SELECT EMPNO  "사 번", ENMME  이름, SAL  급여, JOB
      FROM EMP;  -- 별칭에 SPCE가 없는 경우는 따옴표 생략 가능
--3. 특정 행 출력 : WHERE(조건절) -- 비교연산자 : 같다(=), 다르다(!=, ^=, <>).  >..
SELECT EMPNO 사번, ENAME 이름, SAL 급여 FROM EMP WHERE SAL!=3000;
SELECT EMPNO 사번, ENAME 이름, SAL 급여 FROM EMP WHERE SAL^=3000;
SELECT EMPNO 사번, ENAME 이름, SAL 급여 FROM EMP WHERE SAL<>3000;

     -- 비교연산자는 숫자, 문자, 날짜형 모두 가능
     -- ex1. 사원이름이 'A', 'B', 'C'로 시작하는 사원의 모든 열(필드)
     -- A<AA<AAA<AAAA<...<B<BB<...<C 
     SELECT * FROM EMP WHERE ENAME < 'D';
     -- ex2. 81년도 이전에 입사한 사원의 모든 열(필드)
     SELECT * FROM EMP WHERE HIREDATE < '81/01/01';
     -- 부서번호(DEPTNO)R 10번인 사원의 모든 필드
     SELECT * from emp where deptno=10;
     -- SQL문은 대소문자 구별없음. 데이터는 대소문자 구별
     -- ex4. 이름(ENAME)이 SCOTT인 직원의 모든 데이터(필드)
     SELECT * from emp where ename ='SCOTT';
-- 4. WHER절(조건절)에 논리연산자 : AND OR NOT
     -- ex1. 급여(SAL)가 2000이상 3000이하인 직원의 모든 필드
     SELECT * FROM EMP WHERE 2000<=SAL AND SAL<=3000;
     -- ex2. 82년도 입사한 직원의 모든 필드
     SELECT * FROM EMP WHERE HIREDATE='82/01/01' AND HIREDATE<='82/12/31';
     
     -- 날짜 표기법 셋팅 (현재:RR/MM/DD)
     ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY';
     SELECT * FROM EMP 
         WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') >='1982/01/01' 
            AND TO_CHAR(HIREDATE, 'RR/MM/DD') <='1982/12/31';
    -- ex3. 부서번호가 10이 아닌 직원의 모든 필드
    SELECT * FROM EMP WHERE DEPTNO !=10;
    SELECT * FROM EMP WHERE NOT DEPTNO !=10;
    
    
-- 5. 산술연산자 (SELECT절, WHERE절, ORDER BY절)
SELECT EMPNO, ENAME, SAL "예전월급", SAL*1.1 "현재월급" FROM EMP;
   --ex1. 연봉이 10,000이상인 직원의 ENAME(이름), SAL(월급), 연봉(SAL*12)-연봉순
   SELECT ENAME, SAL, SAL*12  ANNUALSAL   --(3) 
       FROM EMP               --(1)
       WHERE SAL*12>10000     --(2) 별칭 사용 불가
       ORDER BY SAL*12;       --(4)
   --산술연산의 결과는 NULL을 포함하면 결과도 NULL
   --NVL(NULL일 수도 있는 필드명, 대체값)을 이용 : 필드명과 대체값은 타입이 일치
   --ex2. 연봉이 20000이상인 직원의 이름, 월급, 상여, 연봉(SAL*12+COMM)
   SELECT ENAME, SAL, COMM, SAL*12+NVL(COMM,0) 연봉 FROM EMP;
   -- ex3. 모든 사원의 ENAME, MGR(상사사번)을 출력-상사사번이 없으며 'CEO'
   SELECT ENAME, NVL(TO_CHAR(MGR), 'CEO') MGR FROM EMP;
   DESC EMP;
   
-- 6. 연결연산자 (||) : 필드내용이나 문자를 연결
SELECT ENAME || '은(는)' ||JOB FROM EMP;

--7. 중복제거(DISTINCT)
SELECT DISTINCT JOB FROM EMP;
SELECT DISTINCT DEPTNO JOB FROM EMP;
 
--8. SQL 연산자(BETWEEN, IN, LIKE, IS NULL)
--(1) BETEEN A AND B : A부터 B까지 (A, B포함, A<=B)
    --ex. SAL이 1500이상 3000이하
    SELECT * FROM EMP WHERE SAL>=1500 AND SAL<=3000;
    SELECT * FROM EMP WHERE SAL BETWEEN 1500 AND 3000;
    SELECT * FROM EMP WHERE SAL BETWEEN 3000 AND 1500; -- X
    -- ex-1. SAL이 1500미만 3000초과(ex1의 반대)
    SELECT * FROM EMO WHERE SAL NOT  BETWEEN  1500 AND 3000;
    SELECT * FROM EMO WHERE SAL <1500 OR SAL>3000;
    -- ex2. 82년도 봄(3월~5월)에 입사한 직원의 모든 필드
    SELEDCT * FROM EMP
        WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') BETWEEN '81/03/01' AND '81/05/31'
    --(2) 필드명 IN(값1, 값2, ..값N)
    -- 부서코드가 10번이거나 30번이거ㅓ나 40번 사람의 모든 정보
    SELECT * FROM EMP WHERE DEPTNO=10 OR DEPTNO=30 OR DEPTNO=40;
    SELECT * FROM EMP WHERE DEPTNO IN (10, 30, 40);
    --ex2. 직책(JOB)이 'MANAGER'이거나 'ANALYST'인 사원의  모든 정보
    SELET * FROM EMP WHERE JOB  IN ('MANAGER', 'ANALUST');
    --ex1-1. ex1의 반대(부서번호가 10번도 아니고 30도 아니고 40도 아닌 사람)
    SELECT * FROM EMP WHERE DEPTNO NOT IN(10, 30, 40);
    
-- (3) 필드명 LIKE '패턴': %(0글자이상), _(한글자)를 포함하는 패턴
     -- ex. 이름이 M으로 시작하는 사원의 모든 정보
    SELECT * FROM EMP WHERE ENAME LIKE 'M%';
    -- ex. 이름이 S로 끝나는 사원의 모든 정보
    SELECT * FROM EMP WHERE ENAME LIKE '%S';
    -- ex. 이름에 N이 들어가는 사원의 모든 정보
    SELECT * FROM EMP WHERE ENAME LIKE '%N%';
    -- ex. 이름에 N이 들어가고 JOB에 S가 들어가는 사원
    SELECT * FROM EMP WHERE ENAME LIKE '%N%' AND JOB LIKE '%S%';
    -- ex. SAL이 5로 끝나는 사원 
    SELECT * FROM EMP WHERE SAL LIKE '%5';S
   
   --ex. 82년도에 입사한 사원
   SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '82/%';
   SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR')=82;
   
   --ex. 1월에 입사한 사원
   SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '_/01/_';
   SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'MM')='01';
   --ex. 이름에 %가 들어간 사원
   SELECT * FROM EMP WHERE ENAME LIKE '%%%';
   DESC EMP;
       -- 이름에 %가 들어간 데이터 INSERT 
       INSERT INTO EMP VALUES (9999,'홍%동', NULL, NULL, NULL,9000, 9000,40);
       
       SELECT * FROM EMP;
       ROLLBACK;  --DML(데이터조작어: 추가, 수정, 삭제, 검색)를 취소
  -- (4) 필드명 IS NULL: 필드명이 NULL인지니를 검색할 때
    -- ex.  COMM(상여)이 없는 사원
    SELECT * FROM EMP WHERE COMM IS NULL OR COMM=0;
    -- ex. COMM(상여)를 받는 사원(COMM!=0 AND COMM이 NULL이 아님)
    SELECT * FROM EMP WHERE COMM IS NOT NULL AND COMM!=0;
--9. 정렬(오름차순, 내림차순): ORDER BY 절
SELECT * FROM EMP ORDER BY SAL; --오름차순
SELECT * FROM EMP ORDER BY SAL DESC; -- 내림차순
     -- ex. 급여 내림차순, 급여같으면 입사일 내림차순
     SELECT * FROM EMP ORDER BY SAL DESC, HIREDATE DESC;
     --ex, 급여가 2000초과하는 사원을 출력, 이름 abc순(오름차순)
     SELECT * FROM EMP WHERE SAL>2000 ORDER BY ENAME DESC;

    
    
    
    
    
