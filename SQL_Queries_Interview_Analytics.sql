create database interview_analytics;
use interview_analytics;

-- List of KPI cards

-- 1. Count of Total Customer's 
select 
	count(distinct Customer_name) as 'Tol Customers'
from 
	panel_dataset;
    

-- 2. Count of Total Candidate's 
select 
	count(candidate_name) as 'Tol Candidates'
from 
	panel_dataset;


-- 3. Count of Total Panel's 
select
	count(distinct panel_email) as 'Tol Panels'
from 
	panel_dataset;


-- 4. Count of Total Interview's 
select
	count(*) as 'Tol Interviews'
from panel_dataset;


-- 5. Total Panel payout
select
	concat(round(
    sum(panel_payout)/1000000,2),'M') as 'Tol Payout'
from 
	panel_dataset;


-- 6. Avg Payout per Interview

select 
round(avg(panel_payout),2) as 'Avg Payout/Intrw'
from panel_dataset;


-- 7. Avg Payout by Panel

select 
	concat(round(
	(sum(panel_payout)/count(distinct panel_email))/1000,2),'K') as 'Avg Payout/panel'
from 
	panel_dataset;

-- List of KPI Visuals

-- 1. Top 5 Interviews by Customer
-- 1st Method

with Ranked_Interviews as 
	(
select 
	customer_name as Customer,
	count(*) as 'Interview Count',
	dense_rank() over(order by count(*) desc) as 'Rnk'
from 
	panel_dataset
group by 
	customer_name
	)
select *
from Ranked_Interviews
where Rnk<6;

-- 2nd Method

select 
	Customer, `Interview Count`
from
 (select 
	customer_name as Customer,
	count(*) as 'Interview Count',
	dense_rank() over(order by count(*) desc) as 'Rnk'
from 
	panel_dataset
group by 
	customer_name) as Ranked_Interviews
where Rnk<=5;


-- 2. Bottom 5 Interviews by Customer

with Ranked_Interviews as 
	(
select 
	customer_name as Customer,
	count(*) as `Interview Count`,
    dense_rank() over(order by count(*) asc) as Rnk
from 
	panel_dataset
group by 
	Customer_Name
	)

select Customer, `Interview Count`
from Ranked_Interviews
where Rnk<6;


-- 3. Top 5 payouts by customer

-- 1st Method

with Ranked_Payout as 
	(
select 
	customer_name as Customer,
	concat(round(sum(panel_payout)/1000000,2),'M') as 'Tol Payout',
    dense_rank() over(order by concat(round(sum(panel_payout)/1000000,2),'M') desc) as Rnk
from 
	panel_dataset
group by 
	customer_name
    )
select Customer, `Tol Payout`
from Ranked_Payout
where Rnk<6;

-- 2nd Method

select Customer, `Tol Payout`
from 
	(
select 
	customer_name as Customer,
	concat(round(sum(panel_payout)/1000000,2),'M') as 'Tol Payout',
    dense_rank() over(order by concat(round(sum(panel_payout)/1000000,2),'M') desc) as Rnk
from 
	panel_dataset
group by 
	customer_name
	) as Ranked_Payout
where Rnk<6;

-- 4. Top 5 interviews by role

with Ranked_Role as
	(
select 
	Primary_Skill as Role,
    count(*) as Interview_Count,
    dense_rank() over(order by count(*) desc) as Rnk
from 
	panel_dataset
group by
	Primary_Skill
		)
select Role, Interview_Count
from Ranked_Role
where Rnk<6;

-- 5. Total interviews by year

select 
	year(str_to_date(schd_date,'%d-%b-%y')) as Year,
	count(*) as Count
from 
	panel_dataset
group by year(str_to_date(schd_date,'%d-%b-%y'))
order by 
	Year;
	

-- 6. Total payout by year

select 
	year(str_to_date(schd_date,'%d-%b-%y')) as Year,
    concat(round(sum(panel_payout)/1000000,2),' M') as Tol_Payout
from
	panel_dataset
group by
	year(str_to_date(schd_date,'%d-%b-%y'))
order by 
	Year;
    

-- 7. Top 5 interviews count by panel

with Ranked_Panel as 
	(
select 
	Panel_Name,
    count(*) as  Count,
    dense_rank() over(order by count(*) desc) as Rnk
from 
	panel_dataset
group by Panel_Name
	)
select Panel_Name, Count
from Ranked_Panel
where Rnk < 6;


-- 8. Top 5 payouts by panel

with Ranked_Payout as 
	(
select 
	Panel_Name,
    concat(round(sum(panel_payout)/1000000,2),'M') as Payout,
    dense_rank() over(order by concat(round(sum(panel_payout)/1000000,2),'M') desc) as Rnk
from 
	panel_dataset
group by Panel_Name
	)
select Panel_Name, Payout
from Ranked_Payout
where Rnk < 6;

-- 9. Count of Final Status

select 
	Final_Status, 
    count(*) as Count
from 
	panel_dataset
group by 
	Final_Status
order by count desc;

-- 10. Total payout by role

select
	Primary_Skill as Role,
    concat(round(sum(panel_payout)/1000000,2),' M') as Payout
from 
	panel_dataset
group by
	Primary_Skill
order by Payout desc;










