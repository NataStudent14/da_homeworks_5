task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

sample:
1 1
2 1
1 2
2 2
1 3
2 3


create view pages_all_products as
select code, model, speed, ram, hd, price, screen, 
case when num % 2 = 0 
then num/2
else num/2+1
end as page_num, 
case when total % 2 = 0 
then total/2
else total/2+1
end as num_of_pages
from 
(
select *, row_number() over(order by model desc) as num,
count(*) over() as total 
from Laptop
) a;
select *
from pages_all_products


--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������, ���, ������� (%)

create view distribution_by_type as
(select maker, type, count(*) * 100.0 / (select count(*) from product) as percent
from product
group by maker, type)
select * 
from distribution_by_type


--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������. ������ https://plotly.com/python/histograms/

import distribution_by_type as dbt
df = px.data.tips()
fig = px.pie(df, values='percent', names='maker')
fig.show()

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����

create table ships_two_words as
select *
from ships
where name like '% %'


--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

select *
from ships
where class is null 
and name like 'S%'


--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������). ������� model

select pr.model
from product p
join printer pr
on p.model = pr.model
where 
maker = 'A'
and price >
(
select avg(price) from product p
join printer pr
on p.model = pr.model
where maker = 'C'
) 
union all
select model
from 
(
select p.model, row_number() over(partition by p.type order by price desc) as R
from product p
join printer pr
on p.model = pr.model
) RR
where R <= 3
