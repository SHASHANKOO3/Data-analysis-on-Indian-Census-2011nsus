select * from Data1;

select * from Data2;

-- Creating blank table same as Data1

SELECT * INTO NewTable FROM Data1 WHERE 1=2;

Select * from NewTable

-- count the number of rows into our dataset

select COUNT(*) from Data1
select COUNT(*) from Data2

-- dataset for 'Chhattisgarh' ,'Maharashtra'

SELECT * from Data1 where State in ('Chhattisgarh' ,'Maharashtra')

-- population of India

SELECT SUM(Population) as Population from Data2

-- avg growth of state 

Select State, AVG(Growth)*100 avg_growth from Data1 group by State

-- avg sex ratio of state

SELECT State, ROUND(avg(sex_ratio),0) avg_sex_ratio from data1 group by State order by avg_sex_ratio desc

-- avg literacy rate of state having literay more than 90
 
SELECT State, ROUND(AVG(Literacy),0) avg_literacy_ratio from Data1 
GROUP BY State HAVING ROUND(AVG(Literacy),0)>90 order by avg_literacy_ratio desc

-- top 3 state showing highest growth ratio

Select TOP 3 State, ROUND(Growth,2) Growth from Data1 order by Growth Desc;



--bottom 3 state showing lowest sex ratio

Select TOP 3 State, Sex_Ratio from Data1 ORDER BY Sex_Ratio Asc


-- top and bottom 3 states in literacy state


(Select D.State, D.Literacy from
(Select Top 3 State, Literacy from Data1 ORDER BY Literacy DESC) D

UNION
SELECT C.State, C.Literacy from
(Select Top 3 State, Literacy from Data1 ORDER BY Literacy ASC) C)


-- states starting with letter a OR ending with b

select distinct state from Data1 where lower(state) like 'a%' or lower(state) like 'b%'

-- states starting with letter a AND ending with letter m

select distinct state from Data1 where lower(state) like 'a%' and lower(state) like '%m'


-- joining both table

Select * from Data1 D1 INNER JOIN Data2 D2 ON D1.District = D2.District

--total males and females

-- population = female + male
-- sex ratio = males/female
-- female = population - male
-- female = sex_ratio * male
-- sex_ratio * male = population - male
-- population = sex_ratio*male + male
-- population = male(sex_ratio + 1)
-- male = population/(sex_ratio + 1) -- 1
-- female = population - male
-- female = population - population/(sex_ratio + 1)
-- female = population(1-1/sex_ratio+1)
-- female = population(sex_ratio/sex_ratio + 1) --2

select c.state as State, sum(c.population) as Population, sum(c.male)as Total_Male, sum(c.female) as Total_Female
from
(select b.State, b.District, b.population, round(b.population/(b.sex_ratioo+1),0) as male, 
round((b.population*b.sex_ratioo)/(b.sex_ratioo +1),0) as female
from
(Select D1.Sex_Ratio/1000 as sex_ratioo, D2.District, D2.Population, D2.State 
from Data1 D1, Data2 D2 where D1.District = D2.District) b)c group by c.State


-- total literacy rate

-- Total_Literate/Population = literacy rate
-- literate + non-literate = population
-- Total_literate = literacy rate * population     --1
-- non_literate = (1-total_literate) * population  --2


Select c.state as State, sum(c.population) as Population, sum(c.Literate) as Literate, 
sum(c.Non_Literate) as Non_Literate
from
(Select b.state, b.District, b.population, ROUND((b.Literacy_rate * b.population),0) as Literate, 
ROUND(((1-b.Literacy_rate) * b.population),0) as Non_Literate
from
(Select D1.Literacy/100 as Literacy_rate, D2.District, D2.Population, D2.State 
from Data1 D1, Data2 D2 where D1.District = D2.District) b)c
group by c.State



