use portfolio_project;

SELECT * FROM portfolio_project.covid_deaths_data
WHERE continent IS NOT NULL AND continent <> '';

-- loading the data 

CREATE TABLE covid_deaths_data (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date_str VARCHAR(10),  -- Temporary column to hold the date as a string
    date DATE,
    population BIGINT,
    total_cases INT,
    new_cases INT,
    new_cases_smoothed FLOAT,
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    icu_patients INT,
    icu_patients_per_million FLOAT,
    hosp_patients INT,
    hosp_patients_per_million FLOAT,
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million FLOAT,
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million FLOAT,
    total_tests INT
);




CREATE TABLE covid_vaccinations (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date_str VARCHAR(10),  -- Temporary column to hold the date as a string
    date DATE,
    new_tests INT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(50),
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    total_boosters BIGINT,
    new_vaccinations INT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    total_boosters_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    new_people_vaccinated_smoothed FLOAT,
    new_people_vaccinated_smoothed_per_hundred FLOAT,
    stringency_index FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT,
    excess_mortality_cumulative_absolute FLOAT,
    excess_mortality_cumulative FLOAT,
    excess_mortality FLOAT,
    excess_mortality_cumulative_per_million FLOAT
);



set global local_infile=1;

Set secure_file_priv = NULL;

SHOW VARIABLES LIKE 'secure_file_priv';


LOAD DATA LOW_PRIORITY LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\covid deaths data.csv'
INTO TABLE `covid_deaths_data`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(iso_code, continent, location, @date_str, population, total_cases, new_cases, new_cases_smoothed,
 total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million,
 new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million,
 reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million,
 weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, total_tests)
SET date = STR_TO_DATE(@date_str, '%d-%m-%Y');



LOAD DATA LOW_PRIORITY LOCAL INFILE 'H:\\Data Analyst projects\\covid_vacinations.csv' 
INTO TABLE `covid_vaccinations`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(iso_code, continent, location, @date_str, new_tests, total_tests_per_thousand, new_tests_per_thousand,
 new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units,
 total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters, new_vaccinations,
 new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred,
 people_fully_vaccinated_per_hundred, total_boosters_per_hundred, new_vaccinations_smoothed_per_million,
 new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred, stringency_index, population_density,
 median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence,
 female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy,
 human_development_index, excess_mortality_cumulative_absolute, excess_mortality_cumulative, excess_mortality,
 excess_mortality_cumulative_per_million)
SET date = STR_TO_DATE(@date_str, '%d-%m-%Y');





-- selecting the data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolio_project.covid_deaths_data
WHERE continent IS NOT NULL AND continent <> ''
order by 1,2;

-- total cases vs total deaths 
-- likelyhood of dying if we contact with covid
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_percentages
FROM portfolio_project.covid_deaths_data
where location like '%states%' and continent IS NOT NULL AND continent <> ''
order by 1,2;

-- looling at total cases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 as Cases_percentages
FROM portfolio_project.covid_deaths_data
where location like '%states%' and continent IS NOT NULL AND continent <> ''
order by 1,2;

-- looking at highest percentage of cases compared to population
SELECT location, max(total_cases)  as Highest_Cases, population, max(total_cases/population)*100 as Cases_percentages
FROM portfolio_project.covid_deaths_data
WHERE continent IS NOT NULL AND continent <> ''
group by location, population
order by Cases_percentages desc;

-- countries with highest amouns of death count per population

SELECT location, max(total_deaths)  as Highest_Deaths
FROM portfolio_project.covid_deaths_data
WHERE continent IS NOT NULL AND continent <> ''
group by location
order by Highest_Deaths desc;

-- lets do it by continent 
SELECT continent, max(total_deaths)  as Highest_Deaths
FROM portfolio_project.covid_deaths_data
WHERE continent is not null and continent <>''
group by continent
order by Highest_Deaths desc;

-- showing contients with highest death count 
SELECT continent, max(total_deaths)  as Highest_Deaths
FROM portfolio_project.covid_deaths_data
WHERE continent is not null and continent <>''
group by continent
order by Highest_Deaths desc;


-- global numbers 
SELECT  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as Deaths_percentages
FROM portfolio_project.covid_deaths_data
-- group by date
order by 1,2;

-- looking total population vs total vaccination 

with population_vs_vaccination(Continent, location, death, population, new_vaccination, total_vaccination) 
as ( select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(vaccine.new_vaccinations) over (partition by death.location order by death.location, death.date) as total_vaccinations
from portfolio_project.covid_deaths_data death
join portfolio_project.covid_vaccinations vaccine 
on death.location = vaccine.location and death.date = vaccine.date
where death.continent <> ''
-- order by 1,2,3
)

select * from population_vs_vaccination;

-- Temp table

drop table if exists PercentagePopulationVaccinate;

CREATE TEMPORARY TABLE PercentagePopulationVaccinate ( 
	Continent VARCHAR(255),
	Location VARCHAR(255),
	Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RoallingPeopleVaccinate bigint
    
);


insert into PercentagePopulationVaccinate
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(vaccine.new_vaccinations) over (partition by death.location order by death.location, death.date) as RoallingPeopleVaccinate
from portfolio_project.covid_deaths_data death
join portfolio_project.covid_vaccinations vaccine 
on death.location = vaccine.location and death.date = vaccine.date
where death.continent <> '';
-- order by 1,2,3;

select *,(RoallingPeopleVaccinate/Population)*100 from PercentagePopulationVaccinate;

-- creating view for later visuilations 
 
create view PercentagePopulationVaccinate as
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(vaccine.new_vaccinations) over (partition by death.location order by death.location, death.date) as RoallingPeopleVaccinate
from portfolio_project.covid_deaths_data death
join portfolio_project.covid_vaccinations vaccine 
on death.location = vaccine.location and death.date = vaccine.date
where death.continent <> '';

SELECT * FROM portfolio_project.percentagepopulationvaccinate;


