Select * from dbo.CovidDeaths$

--Select the data we are going to use 

Select Location,date,total_cases,new_cases,total_deaths,population
from dbo.CovidDeaths$
order by 1,2;

--Looking  at total cases compare to total Deaths

Select Location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPersantage
from dbo.CovidDeaths$
Where location like '%states%'
order by 1,2;

--Looking at total cases compare to Population (what perstange of people got covid)

Select Location,date,population,total_cases,
(total_cases/Population)*100 as PersantagePopulation
from dbo.CovidDeaths$
Where location like '%States%' 
order by 1,2;

--looking at population with higest Infection rate compare to poputation 

Select Location,population,MAX(total_cases) as HigestInfectionCount,
(MAX(total_cases)/Population)*100 as PersantagePopulationInfected
from dbo.CovidDeaths$
--Where location like '%States%' --To look to the spacific country 
group by population,location
order by PersantagePopulationInfected DESC;

--Looking countries with higest deaths count

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from dbo.CovidDeaths$
Where continent is not null
Group by location
order by TotalDeathCount DESC;

--Let,s Break things down by continent
--Showing the continent with the higest death count

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from dbo.CovidDeaths$
Where continent is not null
Group by continent
order by TotalDeathCount DESC;

 
--Looking into Global Number 

Select Sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPersantge
from dbo.CovidDeaths$
Where continent is not null
Order by 1,2;

--Looking at Total population got vaccinations

Select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
Sum(Convert(int,cv.new_vaccinations)) 
over(Partition by cd.location order by cd.location, cd.date) as RollingPopleVaccinated

from dbo.CovidDeaths$ as cd
join dbo.CovidVaccinations$ as cv 
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
order by 2,3;
 

 -- USING CTE
with Popvsvac (Continent,location,date,population,new_vaccinations,RollingPopleVaccinated)
as
(
Select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
Sum(Convert(int,cv.new_vaccinations)) 
over(Partition by cd.location order by cd.location,
cd.date) as RollingPopleVaccinated
from dbo.CovidDeaths$ as cd
join dbo.CovidVaccinations$ as cv 
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
--order by 2,3
 )
select *,(RollingPopleVaccinated/population)*100
from Popvsvac


-- Temp Table 
Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(255),
Poputation numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into	#PercentPopulationVaccinated
Select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
Sum(Convert(int,cv.new_vaccinations)) 
over(Partition by cd.location order by cd.location,
cd.date) as RollingPopleVaccinated
from dbo.CovidDeaths$ as cd
join dbo.CovidVaccinations$ as cv 
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
select *,(RollingPeopleVaccinated/Poputation)*100
from #PercentPopulationVaccinated;

--Creting View to store data for later visualition.

Create View PercentPopulationVaccinated as
Select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
Sum(Convert(int,cv.new_vaccinations)) 
over(Partition by cd.location order by cd.location,
cd.date) as RollingPopleVaccinated
from dbo.CovidDeaths$ as cd
join dbo.CovidVaccinations$ as cv 
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null


Select * from PercentPopulationVaccinated













