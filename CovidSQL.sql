--Exploratory Data Analysis--

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


-- Queries to use for Tableau Visualization

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
