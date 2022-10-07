--����_1006_1. purprd �����ͷ� ���� �Ʒ� ������ �����ϼ���.
--2�Ⱓ ���űݾ��� ���� ������ �и��Ͽ� ����, ���޻纰�� ���ž��� ǥ���ϴ� AMT_14, AMT_15 ���̺� 2���� ����(��³���: ����ȣ, ���޻�,SUM(���űݾ�))
--AMT14�� AMT15 2�� ���̺��� ����ȣ�� ���޻縦 �������� FULL OUTER JOIN �����Ͽ� ������ AMT_YEAR_FOJ ���̺� ����
--14��� 15���� ���űݾ� ���̸� ǥ���ϴ� ���� �÷��� �߰��Ͽ� ���(��, ����ȣ, ���޻纰 �� ���űݾ� �� ������ ���еǾ�� ��)

select * from purprd;
create table AMT_14 
    as select custno, asso, sum(puramt) puramt_sum from purprd where purdate between 20140101 and 20141231 group by custno, asso order by custno, asso;
    
create table AMT_15
    as select custno, asso, sum(puramt) puramt_sum from purprd where purdate between 20150101 and 20151231 group by custno, asso order by custno, asso;    
    
select * from amt_15;

create table AMT_YEAR_FOJ
as
    select NVL(a.custno,b.custno) as custno, NVL(a.asso,b.asso) as asso, NVL(a.puramt_sum,0) AMT14, NVL(b.puramt_sum,0) AMT15
    From AMT_14 a FULL OUTER JOIN AMT_15 b On a.custno=b.custno and a.asso=b.asso
    order by NVL(a.custno,b.custno);



alter table AMT_YEAR_FOJ drop COLUMN YOY;
alter table AMT_YEAR_FOJ ADD YOY number default 0;

select * from AMT_YEAR_FOJ;

update AMT_YEAR_FOJ set yoy=1 where amt15 > amt14;

select * from amt_year_foj where amt15 = amt14;
--select * from purprd where custno='01657' and asso='B';

select yoy, sum(cnt) from
(select asso, yoy, count(*) cnt from  AMT_YEAR_FOJ group by yoy, asso order by asso)
group by yoy;

select custno, count(*) from  AMT_YEAR_FOJ where amt14=0 group by custno order by custno;

select count(*) from (select custno, count(*) from  AMT_YEAR_FOJ
group by custno);

==================================================================================================
-- �⺰ ���Ű��� �� (14 => 15)

--select gender, age, substr(area,1,1) area, count(*)

select gender, substr(age,1,1)||'0��' age, sum(cnt) as cnt, sum(acnt) as acnt
from (
    select x.gender, x.age, count(*) cnt, (select count(*) from demo d where d.gender=x.gender and d.age=x.age) acnt
    from
        (select a.* from 
            demo a,
            (select custno, yoy from (
                select custno, case when amt14 < amt15 then 1 else 0 end yoy from (
                    select custno, sum(amt14) amt14, sum(amt15) amt15 from  AMT_YEAR_FOJ group by custno
            )) where yoy=0) b
        where a.custno=b.custno) x
    --group by gender, age, substr(area,1,1);
    group by x.gender, x.age
    --order by x.age, x.gender;
) 
group by gender, substr(age,1,1)
order by gender, substr(age,1,1);

���� ���� ȸ���� ��ȸ����
F	10��	5	11
F	20��	283	792
F	30��	1494	3454
F	40��	2894	6461
F	50��	1889	4126
F	60��	476	1054
M	10��	4	6
M	20��	64	176
M	30��	450	994
M	40��	601	1298
M	50��	356	762
M	60��	116	249
==================================================================================================


select bcode,mcl from prodcl where asso='A' group by bcode,mcl;

select * from prodcl where asso='A' and bcode=9;

select * from prodcl where asso='A' and mcl='�غ���/�ð�';

select * from prodcl where asso='B' and mcl='���';




select bcode,count(*) from prodcl where asso='B' group by bcode;


select mcl,count(*) from prodcl where asso='B' group by mcl;


select mcl,count(*) from prodcl where asso='C' group by mcl;


select mcl,count(*) from prodcl where asso='D' and bcode=7 group by mcl;


select * from prodcl where asso='D' and bcode=8;
--A: ��ȭ�� => ������ => 

select count(*) from demo; --���ο� 19383

select count(*) from (select custno from channel group by custno); --6766 (�¶��� �����) 1ȸ�̻�

select count(*) from member; --7456 (����� �����ο�)

select count(*) from demo; -- 19383 (ȸ���ο�)

select count(*) from demo where custno not in (select custno from member);

select count(*) from member where custno not in (select custno from channel); -- 3708 ����ʸ� �����ο�

select count(*) from demo where custno not in (select custno from member) and custno not in (select custno from channel group by custno); -- 19383 (ȸ���ο�)

-- 3,058�� (����� + �¶���)

-- 9,193�� (����ȸ��)

select age, count(*) from demo where custno not in (select custno from member) and custno not in (select custno from channel group by custno) group by age;
select age, count(*) from demo group by age;

ASSO ���� ���ŰǼ�
A	0	8916
A	1	10239
B	0	8480
B	1	10095
C	0	8262
C	1	8848
D	0	948
D	1	2843


 select count(*) from (SELECT custno, count(*) FROM PURPRD GROUP BY custno);

