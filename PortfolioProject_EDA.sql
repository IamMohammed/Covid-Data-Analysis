SELECT *
FROM PortfolioProject..CovidDeaths$
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4

--data we're going to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM  PortfolioProject..CovidDeaths$
ORDER BY 1,2

--total cases v/s total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths*100/total_cases) AS Death_Percentage
FROM  PortfolioProject..CovidDeaths$
WHERE location like '%India%'
ORDER BY 1,2

--total cases v/s population
SELECT location, date, total_cases, population, (total_cases*100/population) AS Case_Percentage
FROM  PortfolioProject..CovidDeaths$
WHERE location like '%India%'
ORDER BY 1,2

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM  PortfolioProject..CovidDeaths$
--Where location like '%India%'
Group by Location, Population
order by PercentPopulationInfected desc

--Countries with Highest Death Rates w.r.t Population
SELECT location, population, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Total_Death_Count desc

--EXPLORING DATA BY CONTINENT
--highest death count per population
SELECT location, population,  MAX(CAST(total_deaths AS INT)) AS Total_Death_Count
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NULL
GROUP BY location, population
ORDER BY Total_Death_Count DESC

--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Vaccinated_till_date
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--AND dea.location LIKE '%India%'
ORDER BY 2,3

--Using CTE
WITH CTE_PopVac (Continent, Location, Date, Population, New_vaccinations, Vaccinated_till_date) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Vaccinated_till_date
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--AND dea.location LIKE '%India%'
--ORDER BY 2,3
)
SELECT *, (Vaccinated_till_date*100)/Population AS Vaccine_percentage
FROM CTE_PopVac

--Creating view for visualization
Create View xPercentPopulationVaccinatedx as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null










 
