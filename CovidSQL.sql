--Total Cases vs Total Deaths (Mortality Rate)
Select Location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as MortalityRate
From DataAnalysis..CovidDeaths
Order by 1,2

--Countries With Highest Infection Rate
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PopulationInfectedPercentage
From DataAnalysis..CovidDeaths
Group by population, location
Order by PopulationInfectedPercentage desc

--Highest Death Count by Country
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From DataAnalysis..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Total Cases Globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From DataAnalysis..CovidDeaths
Where continent is not null
Order by 1,2

--Total Population vs Vaccination, Globally
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingNumberofPeopleVaccinated
From DataAnalysis..CovidDeaths dea
Join DataAnalysis..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by RollingNumberofPeopleVaccinated desc

--CTE

With PopvsVac (Continent, Location, Date, Population,  New_Vaccinations, RollingNumberofPeopleVaccinated)
as (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))
OVER (Partition by dea.location order by dea.location, dea.date) as RollingNumberofPeopleVaccinated
From DataAnalysis..CovidDeaths dea
Join DataAnalysis..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingNumberofPeopleVaccinated/Population)*100
From PopvsVac

--Data Visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingNumberofPeopleVaccinated
From DataAnalysis..CovidDeaths dea
Join DataAnalysis..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Create view PercentPopulationInfected2 as 
Select dea.continent, dea.location, dea.date, dea.population, dea.total_cases, 
SUM(dea.total_cases) OVER (Partition by dea.population order by dea.location, dea.date) as PercentPopulationInfected2
From DataAnalysis..CovidDeaths dea
where dea.continent is not null

Create view MortalityRate as
Select continent, location, date, total_cases, total_deaths,
SUM(CONVERT(int, total_deaths)) OVER (Partition by total_cases order by location, date) as MortalityRate
From DataAnalysis..CovidDeaths
where continent is not null


-- Queries specifically for use with Tableau

--#1. Overall Death Percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as
DeathPercentage
From DataAnalysis..CovidDeaths
Where continent is not null
Order by 1,2

--#2. Overall Death Count

Select location, SUM(Cast(new_deaths as int)) as TotalDeathCount
From DataAnalysis..CovidDeaths
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--#3. Percent of Population Infected

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From DataAnalysis..CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc

--4. Percent Population Infected by Date

Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From DataAnalysis..CovidDeaths
Group by location, population, date
order by PercentPopulationInfected desc
