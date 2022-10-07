--lmembers
SELECT COUNT(*) FROM PURPRD;
SELECT SUM(PURAMT) FROM PURPRD;
SELECT AVG(PURAMT) FROM PURPRD;
SELECT PURDATE FROM purprd, WHERE purdate >= 20141231;
SELECT P.*,d.mcl,d.scl,p.mgroup FROM purprd P, prodcl D 
where p.mgroup=d.mcode and p.bgroup=d.bcode and P.asso = 'A' and d.asso = 'A';

-- ����_1004_8. lmembers �����͸� ������ �Ӽ�(����, ����, ��������) �����հ�(�ݱ⺰), ���ź�(�ݱ⺰)�� ���
--SELECT P.custno, D.gender ����, D.age ����, D.area ��������, P.puramt
--FROM demo D,purprd P 
--where D.custno = P.custno and ;


SELECT D.custno ����ȣ,d.age ����,d.gender ����,d.area ��������,
sum(CASE WHEN P.purdate >= '20150701' then P.puramt end) "�����հ�(2015�ı�)",count(CASE WHEN P.purdate >= '20150701' then P.rno end) "���ź�(2015�ı�)",
round(sum(CASE WHEN P.purdate >= '20150701' then P.puramt end)/count(CASE WHEN P.purdate >= '20150701' then P.rno end)) "2015�ı� ��ձ��űݾ�",

sum(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.puramt end) "�����հ�(2015����)",count(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.rno end) "���ź�(2015����)",
round(sum(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.puramt end)/count(CASE WHEN P.purdate >= '20150101' and P.purdate < '20150701' then P.rno end)) "2015���� ��� ���űݾ�",

sum(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.puramt end) "�����հ�(2014�ı�)",count(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.rno end) "���ź�(2014�ı�)",
round(sum(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.puramt end)/count(CASE WHEN P.purdate >= '20140701' and P.purdate < '20150101' then P.rno end)) "2014�ı� ��� ���űݾ�",

sum(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.puramt end) "�����հ�(2014����)",count(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.rno end) "���ź�(2014����)",
round(sum(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.puramt end)/count(CASE WHEN P.purdate >= '20140101' and P.purdate < '20140701' then P.rno end))"2014���� ��� ���űݾ�"

FROM demo D,purprd P 
where D.custno = P.custno
group by D.custno, D.age, D.gender, D.area order by D.custno;
select sum(cnt), custno from
(select count(rno) cnt, custno from purprd group by rno, custno order by custno)
group by custno
order by custno;

select max(purdate) from purprd;
select min(purdate) from purprd;

--Q. lmembers purprd ���̺�� ���� �ѱ��ž�, 2014 ���ž�, 2015 ���ž� �ѹ��� ���
select sum(puramt) �ѱ��ž�, 
sum(case when purdate <= '20141231' then puramt end) "2014 ���ž�", 
sum(case when purdate > '20141231' then puramt end) "2015 ���ž�"
from purprd;
-- �� ���� ������ ���ⷮ ��Ȳ�� �� ���� ��Ȳ�� ���� ���� �͵� ���� �λ���Ʈ

-- Q. lmembers �����Ϳ��� ���� ���űݾ��� �հ踦 ���� cuspur ���̺��� ������ ��, demo ���̺�� ����ȣ(custno)�� �������� �����Ͽ� ���
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


-- ����_1006_1. purprd �����ͷ� ���� �Ʒ� ������ �����ϼ���.
-- 2�Ⱓ ���űݾ��� ���� ������ �и��Ͽ� ����, ���޻纰�� ���ž��� ǥ���ϴ� amt_14, amt_15���̺� 2���� ����(��³��� : ����ȣ, ���޻�, sum(���űݾ�))
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

-- amt14�� amt15 2�� ���̺��� ����ȣ�� ���޻縦 �������� full outer join �����Ͽ� ������ amt_year_foj ���̺� ����
create table AMT_YEAR_FOJ
as
    select NVL(a.custno,b.custno) as custno, NVL(a.asso,b.asso) as asso, NVL(a.puramt_sum,0) AMT14, NVL(b.puramt_sum,0) AMT15
    From AMT_14 a FULL OUTER JOIN AMT_15 b On a.custno=b.custno and a.asso=b.asso
    order by NVL(a.custno,b.custno);
-- 14��� 15���� ���űݾ� ���̸� ǥ���ϴ� ���� �÷��� �߰��Ͽ� ���(��, ����ȣ, ���޻纰�� ���űݾ� �� ������ ���еǾ�� ��)
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

