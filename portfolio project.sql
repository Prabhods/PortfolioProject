SELECT *
FROM [Portfolio Project] ..['covid-deaths]
where continent is not null
ORDER BY 3,4;

--SELECT *
--FROM [Portfolio Project] ..['covid-vaccination]
--ORDER BY 3,4; 

--SELECTING DATA THAT ARE GONNA BE USED

SELECT  location , date , total_cases , new_cases , total_deaths
,population
FROM [Portfolio Project] ..['covid-deaths]
ORDER BY 1,2;

-- WE ARE LOOKING AT TOTAL CASES VS TOTAL DEATH 
-- SHOWS THE CHANCE OF DYING IF CONTRACTED WITH THE VIRUS IN OUR COUNTRTY

SELECT  location , date , total_cases  , total_deaths
,(total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM [Portfolio Project] ..['covid-deaths]
WHERE location LIKE '%INDIA%'
ORDER BY 1,2;

-- looking at TOTAL CASES VS POPULATION 
-- SHOWS WHAT PERCENTAGE OF PEOPLE GOT COVID

SELECT  location , date , total_cases  , population
,(total_cases/population)*100 AS PERCENTAGEOFPOPULATION 
FROM [Portfolio Project] ..['covid-deaths]
WHERE location LIKE '%INDIA%'
ORDER BY 1,2; 

-- COUNTRIES WITH HIGESH INFECTION RATE 


SELECT  location ,population,MAX (total_cases) AS HIGHESTINVESTIONCOUNT  ,
MAX((total_cases/population))*100 AS PERCENTAGEOFPOPULATION
FROM [Portfolio Project] ..['covid-deaths]
--WHERE location LIKE '%INDIA%'
GROUP BY location , population
ORDER BY PERCENTAGEOFPOPULATION DESC;

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT  continent  ,MAX (CAST(total_deaths as int)) AS TOTALDEATHCOUNT  
FROM [Portfolio Project] ..['covid-deaths]
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY  TOTALDEATHCOUNT DESC;


-- SHOWING CONTINENTS WITH DEATH COUNT PER POPULATION 


SELECT  continent  ,MAX (CAST(total_deaths as int)) AS TOTALDEATHCOUNT  
FROM [Portfolio Project] ..['covid-deaths]
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY  TOTALDEATHCOUNT DESC;


-- GLOBAL NUMBER 


Select date,  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..['covid-deaths]
where continent is not null 
Group By date
order by 1,2; 







-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



SELECT dea.continent
,dea.location
,dea.date
,dea.population
,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations))OVER (Partition by dea.location, DEA.DATE) AS ROLLINGPEOPLEVACCINATE
--,(ROLLINGPEOPLEVACCINATE/population)*100
FROM [Portfolio Project]..['covid-deaths]dea
JOIN [Portfolio Project]..['covid-vaccination]vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE DEA.continent IS NOT NULL
order by 2,3;



-- USINFG CTE 

SELECT *
FROM [Portfolio Project] ..['covid-deaths]
where continent is not null
ORDER BY 3,4;

--SELECT *
--FROM [Portfolio Project] ..['covid-vaccination]
--ORDER BY 3,4; 

--SELECTING DATA THAT ARE GONNA BE USED

SELECT  location , date , total_cases , new_cases , total_deaths
,population
FROM [Portfolio Project] ..['covid-deaths]
ORDER BY 1,2;

-- WE ARE LOOKING AT TOTAL CASES VS TOTAL DEATH 
-- SHOWS THE CHANCE OF DYING IF CONTRACTED WITH THE VIRUS IN OUR COUNTRTY

SELECT  location , date , total_cases  , total_deaths
,(total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM [Portfolio Project] ..['covid-deaths]
WHERE location LIKE '%INDIA%'
ORDER BY 1,2;

-- looking at TOTAL CASES VS POPULATION 
-- SHOWS WHAT PERCENTAGE OF PEOPLE GOT COVID

SELECT  location , date , total_cases  , population
,(total_cases/population)*100 AS PERCENTAGEOFPOPULATION 
FROM [Portfolio Project] ..['covid-deaths]
WHERE location LIKE '%INDIA%'
ORDER BY 1,2; 

-- COUNTRIES WITH HIGESH INFECTION RATE 

SELECT  location ,population,MAX (total_cases) AS HIGHESTINVESTIONCOUNT  ,
MAX((total_cases/population))*100 AS PERCENTAGEOFPOPULATION
FROM [Portfolio Project] ..['covid-deaths]
--WHERE location LIKE '%INDIA%'
GROUP BY location , population
ORDER BY PERCENTAGEOFPOPULATION DESC;

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT  continent  ,MAX (CAST(total_deaths as int)) AS TOTALDEATHCOUNT  
FROM [Portfolio Project] ..['covid-deaths]
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY  TOTALDEATHCOUNT DESC;

-- SHOWING CONTINENTS WITH DEATH COUNT PER POPULATION 

SELECT  continent  ,MAX (CAST(total_deaths as int)) AS TOTALDEATHCOUNT  
FROM [Portfolio Project] ..['covid-deaths]
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY  TOTALDEATHCOUNT DESC;

-- GLOBAL NUMBER 

Select date,  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..['covid-deaths]
where continent is not null 
Group By date
order by 1,2; 

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent
,dea.location
,dea.date
,dea.population
,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations))OVER (Partition by dea.location, DEA.DATE) AS ROLLINGPEOPLEVACCINATE
--,(ROLLINGPEOPLEVACCINATE/population)*100
FROM [Portfolio Project]..['covid-deaths]dea
JOIN [Portfolio Project]..['covid-vaccination]vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE DEA.continent IS NOT NULL
order by 2,3;

-- USINFG CTE 

WITH POPVSVAC(CONTINENT,LOCATION,DATE,POPULATION, NEW_VACCINATEIONS,RollingPeopleVaccinated)
AS
(
SELECT dea.continent
,dea.location
,dea.date
,dea.population
,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations))OVER (Partition by dea.location, DEA.DATE) AS ROLLINGPEOPLEVACCINATE
--,(ROLLINGPEOPLEVACCINATE/population)*100
FROM [Portfolio Project]..['covid-deaths]dea
JOIN [Portfolio Project]..['covid-vaccination]vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE DEA.continent IS NOT NULL
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
FROM POPVSVAC

--TEMP TABLE 

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..['covid-deaths] dea
Join [Portfolio Project]..['covid-vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

```








