--lmembers
SELECT COUNT(*) FROM PURPRD;
SELECT SUM(PURAMT) FROM PURPRD;
SELECT AVG(PURAMT) FROM PURPRD;
SELECT PURDATE FROM purprd, WHERE purdate >= 20141231;
SELECT P.*,d.mcl,d.scl,p.mgroup FROM purprd P, prodcl D 
where p.mgroup=d.mcode and p.bgroup=d.bcode and P.asso = 'A' and d.asso = 'A';

-- 과제_1004_8. lmembers 데이터를 고객별로 속성(성별, 나이, 거주지역) 구매합계(반기별), 구매빈도(반기별)를 출력
--SELECT P.custno, D.gender 성별, D.age 나이, D.area 거주지역, P.puramt
--FROM demo D,purprd P 
--where D.custno = P.custno and ;


SELECT D.custno 고객번호,d.age 나이,d.gender 성별,d.area 거주지역,
sum(CASE WHEN P.purdate >= '20150701' then P.puramt end) "구매합계(2015후기)",count(CASE WHEN P.purdate >= '20150701' then P.rno end) "구매빈도(2015후기)",
round(sum(CASE WHEN P.purdate >= '20150701' then P.puramt end)/count(CASE WHEN P.purdate >= '20150701' then P.rno end)) "2015후기 평균구매금액",

sum(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.puramt end) "구매합계(2015전기)",count(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.rno end) "구매빈도(2015전기)",
round(sum(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.puramt end)/count(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.rno end)) "2015전기 평균 구매금액",

sum(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.puramt end) "구매합계(2014후기)",count(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.rno end) "구매빈도(2014후기)",
round(sum(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.puramt end)/count(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.rno end)) "2014후기 평균 구매금액",

sum(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.puramt end) "구매합계(2014전기)",count(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.rno end) "구매빈도(2014전기)",
round(sum(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.puramt end)/count(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.rno end))"2014전기 평균 구매금액"

FROM demo D,purprd P 
where D.custno = P.custno
group by D.custno, D.age, D.gender, D.area order by D.custno;
select sum(cnt), custno from
(select count(rno) cnt, custno from purprd group by rno, custno order by custno)
group by custno
order by custno;

select max(purdate) from purprd;
select min(purdate) from purprd;

--Q. lmembers purprd 테이블로 부터 총구매액, 2014 구매액, 2015 구매액 한번에 출력
select sum(puramt) 총구매액, 
sum(case when purdate <= '20141231' then puramt end) "2014 구매액", 
sum(case when purdate > '20141231' then puramt end) "2015 구매액"
from purprd;
-- 각 개별 고객들의 매출량 상황을 총 매출 상황과 비교해 보는 것도 좋은 인사이트

-- Q. lmembers 데이터에서 고객별 구매금액의 합계를 구한 cuspur 테이블을 생성한 후, demo 테이블과 고객번호(custno)를 기준으로 결합하여 출력
CREATE TABLE cuspur
AS select custno, sum(puramt) puramt_sum
FROM purprd GROUP BY custno
order by custno;

drop table cuspur;

select * from cuspur;

SELECT D.* , C.puramt_sum
FROM demo D, cuspur C
WHERE D.custno = c.custno
order by D.custno;


-- 과제_1006_1. purprd 데이터로 부터 아래 사항을 수행하세요.
-- 2년간 구매금액을 연간 단위로 분리하여 고객별, 제휴사별로 구매액을 표시하는 amt_14, amt_15테이블 2개를 생성(출력내용 : 고객번호, 제휴사, sum(구매금액))
select * from purprd;
--create table AMT_14 as 
select custno, asso, 
sum(case when purdate between 20140101 and 20140630 then puramt end) puramt_14_1,
sum(case when purdate between 20140701 and 20141231 then puramt end) puramt_14_2,
sum(case when purdate between 20150101 and 20150630 then puramt end) puramt_15_1,
sum(case when purdate between 20150701 and 20151231 then puramt end) puramt_15_2
from purprd group by custno, asso order by custno, asso;



create table AMT_15
    as select custno, asso, 
    sum(case when purdate between 20150101 and 20150630 then puramt end) puramt_sum_1,
    sum(case when purdate between 20150701 and 20151231 then puramt end) puramt_sum_2,
    from purprd group by custno, asso order by custno, asso;   
    
select * from amt_15;

drop table AMT_14;
drop table AMT_15;

-- amt14와 amt15 2개 테이블을 고객번호와 제휴사를 기준으로 full outer join 적용하여 결합한 amt_year_foj 테이블 생성
create table AMT_YEAR_FOJ
as
    select NVL(a.custno,b.custno) as custno, NVL(a.asso,b.asso) as asso, NVL(a.puramt_sum,0) AMT14, NVL(b.puramt_sum,0) AMT15
    From AMT_14 a FULL OUTER JOIN AMT_15 b On a.custno=b.custno and a.asso=b.asso
    order by NVL(a.custno,b.custno);
-- 14년과 15년의 구매금액 차이를 표시하는 증감 컬럼을 추가하여 출력(단, 고객번호, 제휴사별로 구매금액 및 증감이 구분되어야 함)
alter table AMT_YEAR_FOJ drop COLUMN YOY;
alter table AMT_YEAR_FOJ ADD YOY number default 0;

select age, sum(puramt_sum)
from(
select a.custno,d.gender, d.age, sum(a.amt14 - a.amt15) puramt_sum
from AMT_YEAR_FOJ a, demo d 
where a.custno = d.custno and yoy=0
group by a.custno,d.gender, d.age
order by a.custno)
group by age
order by age;

update AMT_YEAR_FOJ set yoy=1 where amt15 > amt14;

