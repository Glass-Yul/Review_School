-- Quiz 6. 조인과 집합연산
--------------------------------------------------------------------------------
-- Quiz 6.1 모든 사원의 이름과 직무명을 조회하시오.
--      직무명, 사원이름 순서로 조회
--   직무명     사원이름
--  Accountant	Chen John
--------------------------------------------------------------------------------
select J.job_title 직무명, E.first_name||' '||E.last_name 사원이름
from employees E, jobs J ;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.2 직무별 직무를 맡고있는 사원수를 조회하시오.
--      직무명 순서로 조회
-- 조회형태
--   직무명     사원수
--  Accountant	5
--------------------------------------------------------------------------------
select J.job_title 직무명, count(*) 사원수
from employees E join jobs J on E.job_id = J.job_id
group by J.job_title;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.3 직무별 직무를 맡고있는 사원수가 10명이상인 직무의 사원수를 조회하시오.
--      직무명 순서로 조회
-- 조회형태
--   직무명     사원수
--  Accountant	5
--------------------------------------------------------------------------------
select J.job_title 직무명, count(*) 사원수
from employees E join jobs J on E.job_id = J.job_id
group by J.job_title having count(*) >= 10;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.4 모든 사원의 사번, 사원명, 부서명, 직무명을 조회하시오.
--         부서명, 직무명, 사원번호 순서로 조회
-- 조회형태
--   부서명     직무명    사원번호  사원명
--  Finance	Accountant	  111	Sciarra Ismael
--------------------------------------------------------------------------------
select D.department_name 부서명, J.job_title 직무명, E.employee_id 사원번호, E.first_name||' '||E.last_name 사원명
from (employees E join DEPARTMENTS D on E.department_id = D.department_id)
    join jobs J on E.job_id = J.job_id
order by 부서명, 직무명, 사원번호;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.5 사번 101, 176번인 사원의 직무이력을 조회하시오.
-- 조회항목 : 사번, 사원명, 부서명, 직무명, 시작일자, 종료일자
-- 조회형태
--  사번     사원명          부서명         직무명            시작일자    종료일자
--  101	Kochhar Neena	Accounting	Accounting Manager	2001-10-28	2005-03-15
--------------------------------------------------------------------------------
select E.employee_id 사원번호, E.first_name||' '||E.last_name 사원명, D.department_name 부서명, J.job_title 직무명,
to_char(JH.start_date,'YYYY-MM-DD') 시작일자, to_char(JH.end_date,'YYYY-MM-DD') 종료일자
from ((employees E join DEPARTMENTS D on E.department_id = D.department_id)
    join job_history JH on E.employee_id = JH.employee_id) join jobs J on J.job_id=JH.job_id;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.6 각 부서별 사원수와 연봉합계를 조회하시오.
--          조회순서은 연봉합계가 높은 순서로 조회하시오.
-- 조회항목 : 부서명, 사원수, 연봉합계
-- 조회형태
--  부서명   사원수      연봉합계
--  Sales	  34	  $304,500
--------------------------------------------------------------------------------
select DEPARTMENT_NAME 부서명, count(*) 사원수, to_char(sum(salary),'$999,999') 연봉합계
from DEPARTMENTS D join employees E on D.department_id = E.department_id
group by DEPARTMENT_NAME
order by 부서명, 사원수, 연봉합계;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.7 각 부서별 직무별 사원수와 연봉합계를 조회하시오.
--          조회순서은 부서별 연봉합계가 높은 순서로 조회하시오.
-- 조회항목 : 부서명, 직무명, 사원수, 연봉합계
-- 조회형태
--  부서명           직무명          사원수      연봉합계
-- Accounting	Accounting Manager	1	      $12,008
-- Accounting	Public Accountant	1	       $8,300
--------------------------------------------------------------------------------
select DEPARTMENT_NAME 부서명, job_title 직무명, count(*) 사원수, to_char(sum(salary),'$999,999') 연봉합계
from (DEPARTMENTS D join employees E on D.department_id = E.department_id)
        join jobs J on J.job_id=E.job_id
group by DEPARTMENT_NAME, job_title
order by 부서명, 연봉합계 desc;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.8 20년이상 근속자의 사원ID, 사원명, 부서명, 직무명, 근속년수와 연봉을 조회하시오.
--          조회순서은 근속년수가 높은 순서로 조회하시오.
--          근속년수 : 현재날짜에서 입자일자 사이의 월수에서 12로 나눈후 정수 첫번째자리에서 반올림
--                     round(months_between(sysdate, hire_date)/12, 0)  
-- 조회항목 : 사원ID, 사원명, 부서명, 직무명, 근속년수, 연봉
-- 조회형태
--  사원ID, 사원명, 부서명, 직무명, 근속년수와 연봉
--  Sales	  34	  $304,500
--------------------------------------------------------------------------------
select E.employee_id 사원ID, E.first_name||' '||E.last_name 사원명,D.DEPARTMENT_NAME 부서명, J.job_title 직무명,
round(months_between(sysdate,hire_date)/12,0) 근속년수, to_char(E.salary,'$999,999') 연봉  
from (DEPARTMENTS D join employees E on D.department_id = E.department_id)
        join jobs J on J.job_id = E.job_id
where round(months_between(sysdate,hire_date)/12,0) >= 20
order by 근속년수 desc;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.9 각 부서별 부서명, 사원수, 근속년수평균, 평균연봉을 조회하시오.
--          조회순서은 근속년수평균이 높은 순서로 조회하시오.
--          근속년수 : 현재날짜에서 입자일자 사이의 월수에서 12로 나눈후 정수 첫번째자리에서 반올림
-- 조회항목 : 부서명, 사원수, 평균연봉
-- 조회형태
--      부서명     사원수   근속년수평균      평균연봉
--  Accounting	    38	    20  	      $10,154
--------------------------------------------------------------------------------
select D.department_name 부서명, count(*) 사원수, 
round(avg(months_between(sysdate,hire_date)/12),0) 근속년수_평균, to_char(avg(E.salary),'$999,999') 평균연봉
from employees E join departments D on E.department_id = E.department_id
group by D.department_name
order by 근속년수_평균 desc;
--------------------------------------------------------------------------------
--------------???????????????????????????????????????????? 아짜증나
--------------------------------------------------------------------------------
-- Quiz 6.10 미국(United States of America) 소속인 부서에 근무하는 사원수와 연봉합계를 조회하시오.
--           조회순서은 연봉합계가 높은 순서로 조회하시오.
-- 조회항목 : 국가명, 부서명, 사원수, 연봉합계
-- 조회형태
--  국가명                     부서명   사원수      연봉합계
--  United States of America  Sales	    34	     $304,500
--------------------------------------------------------------------------------
select c.country_name 국가명,d.department_name 부서명,count(*) 사원수,to_char(sum(E.salary),'$999,999') 연봉합계
from ((employees e join departments d on e.DEPARTMENT_ID = d.DEPARTMENT_ID)
    join locations l on d.location_id = l.location_id)
    join COUNTRIES c on l.country_id = c.country_id
where c.country_name = 'United States of America'
group by c.country_name, d.department_name
order by 연봉합계 desc;
--------------------------------------------------------------------------------
-- ????????????????????????????????????
--------------------------------------------------------------------------------
-- Quiz 6.11 국가별 부서별 근무하는 사원수와 연봉합계를 조회하시오.
--           조회순서은 국가별 연봉합계가 높은 순서로 조회하시오.
-- 조회항목 : 국가명, 부서명, 사원수, 연봉합계
-- 조회형태
--  국가명              부서명        사원수          연봉합계
--   Canada	        Marketing           2	      $19,000
--   Germany      Public Relations  	1	      $10,000
--------------------------------------------------------------------------------
select c.COUNTRY_NAME 국가명, d.DEPARTMENT_NAME 부서명, count(*) 사원수, 
to_char(sum(e.salary), '$999,999') 연봉합계
from (( DEPARTMENTS d join employees e on d.department_id = e.department_id)
    join LOCATIONS l on d.location_id = l.location_id)
    join COUNTRIES c on l.country_id = c.country_id
group by c.COUNTRY_NAME,d.DEPARTMENT_NAME
order by 연봉합계 desc;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.12 모든 사원에 대하여 사원의 이름과 직속상사의 이름, 부서명, 부서장 이름을 조회하시오.
--           부서가 없는 직원은 제외  (Outer join)
-- 조회형태
--  사번    사원명       직속상사ID 직속상사이름       부서명     부서장ID   부서장이름
--  100	Steven King		                 	    Executive	100	    Steven King
--  101	Neena Kochhar	  100	  Steven King	Executive	100	    Steven King 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 직속상사 이름이랑 부서장 이름이 왜 같음??
--------------------------------------------------------------------------------
-- Quiz 6.13    모든나라의 지사명을 조회하시오 (나라명이 모두 조회되도록 Outer Join)
--              지사가 없는 경우는 'NOT EXISTS OFFICE'
-- 조회형태
--  국가명           지사명
--   Canada	        Toronto
--   Canada	        Whitehorse
--   Zambia	        NOT EXISTS OFFICE
--------------------------------------------------------------------------------
select c.country_name 국가명, NVL(l.city,'NOT EXISTS OFFICE') 지사명
from countries c left join LOCATIONS l on l.country_id=c.country_id;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.14 모든 부서장이상인 관리자 명단을 조회하시오.(UNION 사용)
--      관리자구분 :      사장(employees Table의 manager_id is null)
--                      부서장(depatments Table의 manager_id)
--  사번    사원명           관리자구분
--  100	Steven King	        사장
--  103	Alexander Hunold	부서장 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.15 모든 사원의 업무이력 변경정보 및 변경에 따른 부서정보를 사번이 빠른 순서대로
--           조회하시오. (Union all 이용)
-- 조회항목 : 부서명, 직무명 , 직무구분(현재또는과거직무)
-- 조회형태
--   사번       부서명            직무명
--  101	    Accounting	Public Accountant
--  101	    Executive	Administration Vice President
--  101	    Accounting	Accounting Manager
------------------------------------------------------------------------------

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Quiz 6.16 사번 101번인 사원의 현재직무와 과거 직무를 모두 조회하시오. (Union이용)
-- 조회항목 : 부서명, 직무명 , 직무구분(현재또는과거직무)
-- 조회형태
--   부서명            직무명                     직무구분
--  Accounting	Accounting Manager	            과거
--  Accounting	Public Accountant	            과거
--  Executive	Administration Vice President	현재
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.17 모든 부서중 미국에 없는 부서명을 조회하시오. (Minus이용)
-- 조회항목 : 부서명, 직무명 , 직무구분(현재또는과거직무)
-- 조회형태
--   부서ID            부서명                     
--    20	          Marketing
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.18 근속년수가 20년이상이면서 지금까지 맡았던 
--           직무가 2개 이상인 직원의 이름을 조회하시오. (INTERSECT)
-- 조회항목 : 부서명, 직무명 , 직무구분(현재또는과거직무)
-- 조회형태
--   사원ID        사원명                     
--    102	    De Haan Lex
--    114	    Raphaely Den
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quiz 6.19  월별로 입사한 사원수를 조회하시오. (decode 이용)
-- 조회항목 : 월별 인원수
-- 조회형태
-- Month1 Month2 Month3 Month4 Month5 Month6 Month7 Month8 Month9 Month10 Month11  Month12
--  14	    13	    17	  7	    6	    11	    7	    9	    5	    6	    5	    7  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
select * from COUNTRIES;--국가
select * from DEPARTMENTS;--부서
select * from EMPLOYEES;--직원
select * from JOBS;--직업
select * from JOB_HISTORY;--작업_히스토리
select * from LOCATIONS;--위치
select * from REGIONS;--지역
--------------------------------------------------------------------------------
-- Quiz 6.20  전체직원을 대상으로
--            근속년수가  10년 미만이면 상여급 1.2%,
--                      10년이상 15년 미만이면  1.5%
--                      15년이상 20년미만이면 2.0% 
--                      20년이상이면 2.5%를 인상 적용하시오(case문 이용)
-- 조회항목 : 사번, 사원명, 부서명, 직무명, 연봉, 근속연수, 인상상여금적용비율
-- 조회순서 : 부서명, 사번
-- 조회형태
--  사번  사원명              부서명        직무명          연봉  근속연수 인상상여금적용비율
--  199	Douglas  Grant	    Shipping	Shipping Clerk	2600	15	    2
--  178	Kimberely Grant	    Sales       Representative	7000	15	    2.15
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
select * from COUNTRIES;--국가
select * from DEPARTMENTS;--부서
select * from EMPLOYEES;--직원
select * from JOBS;--직업
select * from JOB_HISTORY;--작업_히스토리
select * from LOCATIONS;--위치
select * from REGIONS;--지역