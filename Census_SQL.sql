-- Selecting all data from Data1 and Data2

SELECT * FROM Data1;
SELECT * FROM Data2;

-- Creating blank table same as Data1

CREATE TABLE NewTable AS SELECT * FROM Data1 WHERE 1=2;

-- Count the number of rows into our dataset

SELECT COUNT(*) FROM Data1;
SELECT COUNT(*) FROM Data2;

-- Dataset for 'Chhattisgarh', 'Maharashtra'

SELECT * FROM Data1 WHERE State IN ('Chhattisgarh', 'Maharashtra');

-- Population of India

SELECT SUM(Population) AS Population FROM Data2;

-- Avg growth of state

SELECT State, AVG(Growth) * 100 AS avg_growth FROM Data1 GROUP BY State;

-- Avg sex ratio of state

SELECT State, ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio FROM Data1 GROUP BY State ORDER BY avg_sex_ratio DESC;

-- Avg literacy rate of state having literacy more than 90

SELECT State, ROUND(AVG(Literacy), 0) AS avg_literacy_ratio FROM Data1 
GROUP BY State HAVING ROUND(AVG(Literacy), 0) > 90 ORDER BY avg_literacy_ratio DESC;

-- Top 3 states showing highest growth ratio

SELECT State, ROUND(Growth, 2) AS Growth FROM Data1 ORDER BY Growth DESC FETCH FIRST 3 ROWS ONLY;

-- Bottom 3 states showing lowest sex ratio

SELECT State, Sex_Ratio FROM Data1 ORDER BY Sex_Ratio ASC FETCH FIRST 3 ROWS ONLY;

-- Top and bottom 3 states in literacy rate

SELECT State, Literacy FROM (
    SELECT State, Literacy FROM Data1 ORDER BY Literacy DESC FETCH FIRST 3 ROWS ONLY
) 
UNION
SELECT State, Literacy FROM (
    SELECT State, Literacy FROM Data1 ORDER BY Literacy ASC FETCH FIRST 3 ROWS ONLY
);

-- States starting with letter 'a' OR ending with 'b'

SELECT DISTINCT State FROM Data1 WHERE LOWER(State) LIKE 'a%' OR LOWER(State) LIKE '%b';

-- States starting with letter 'a' AND ending with letter 'm'

SELECT DISTINCT State FROM Data1 WHERE LOWER(State) LIKE 'a%' AND LOWER(State) LIKE '%m';

-- Joining both tables

SELECT * FROM Data1 D1 INNER JOIN Data2 D2 ON D1.District = D2.District;

-- Total males and females

SELECT c.State AS State, SUM(c.Population) AS Population, SUM(c.Male) AS Total_Male, SUM(c.Female) AS Total_Female
FROM (
    SELECT b.State, b.District, b.Population, ROUND(b.Population / (b.Sex_Ratio + 1), 0) AS Male, 
    ROUND((b.Population * b.Sex_Ratio) / (b.Sex_Ratio + 1), 0) AS Female
    FROM (
        SELECT D1.Sex_Ratio / 1000 AS Sex_Ratio, D2.District, D2.Population, D2.State 
        FROM Data1 D1 JOIN Data2 D2 ON D1.District = D2.District
    ) b
) c 
GROUP BY c.State;

-- Total literacy rate

SELECT c.State AS State, SUM(c.Population) AS Population, SUM(c.Literate) AS Literate, 
SUM(c.Non_Literate) AS Non_Literate
FROM (
    SELECT b.State, b.District, b.Population, ROUND((b.Literacy_Rate * b.Population), 0) AS Literate, 
    ROUND(((1 - b.Literacy_Rate) * b.Population), 0) AS Non_Literate
    FROM (
        SELECT D1.Literacy / 100 AS Literacy_Rate, D2.District, D2.Population, D2.State 
        FROM Data1 D1 JOIN Data2 D2 ON D1.District = D2.District
    ) b
) c 
GROUP BY c.State;
