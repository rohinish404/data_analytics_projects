select Location, date, total_cases, new_cases, total_deaths, population
from portfolio_pjs.covidDeaths
where continent is not null
order by 1,2;

-- shows how much percent died among those who got covid
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percentage_deaths
from portfolio_pjs.covidDeaths
where location like "%states%"
order by 1,2;


-- shows how much of the total population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as  cases_percentage
from portfolio_pjs.covidDeaths
where location like "%states%"
order by 1,2;

-- countries with highest infection rate

select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as  PercentPopulationInfected
from portfolio_pjs.covidDeaths
where continent is not null
Group by Location,population
order by PercentPopulationInfected desc;

-- showing countries with highest death count per population

select Location, MAX(total_deaths) as TotalDeathCount
from portfolio_pjs.covidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc;


-- showing continents with the highest death count per population 

select continent, MAX(total_deaths) as TotalDeathCount
from portfolio_pjs.covidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc;

-- global data

select SUM(total_cases) as TotalCases, SUM(total_deaths) as totalDeaths, (SUM(total_deaths)/SUM(total_cases))*100 as DeathPercentage
from portfolio_pjs.covidDeaths
where continent is not null
-- Group by date
order by 1,2;


-- looking at total population vs vaccinations

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100
from portfolio_pjs.covidDeaths dea
join portfolio_pjs.covidVaccinations vac
	On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- using CTE 

with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100
from portfolio_pjs.covidDeaths dea
join portfolio_pjs.covidVaccinations vac
	On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
-- order by 2,3;
)

select *, (RollingPeopleVaccinated/population)*100 as RollingPplVaccinatedPer
from popvsvac;


-- creating temp tables
Drop table if exists portfolio_pjs.PercentPopulationVaccinated;
Create TEMPORARY TABLE portfolio_pjs.PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date varchar(255),
Population float,
new_vaccinations int,
RollingPeopleVaccinated int
);

Insert into portfolio_pjs.PercentPopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100
from portfolio_pjs.covidDeaths dea
join portfolio_pjs.covidVaccinations vac
	On dea.location = vac.location 
    and dea.date = vac.date;
-- where dea.continent is not null
-- order by 2,3;

select *, (RollingPeopleVaccinated/population)*100 as RollingPplVaccinatedPer
from portfolio_pjs.PercentPopulationVaccinated;









