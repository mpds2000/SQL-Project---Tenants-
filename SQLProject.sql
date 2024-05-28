-- Name: Shreya 
-- Batch: IIT Kanpur Advanced Certification in Data Analytics -
-- SQL Project 
create database tenant
use Tenants;

--Question_1:
select top 1 p.profile_id as Profile_ID, DATEDIFF(day,MIN(t.move_in_date),MAX(t.move_out_date)) as No_of_days,
concat(p.first_name,' ',p.last_name) as Full_Name,p.phone as Contact
from tenants.dbo.profiles p
INNER JOIN
tenants.dbo.tenancy_history t on p.profile_id = t.profile_id
group by
p.profile_id, p.first_name, p.last_name, p.phone
order by No_of_days DESC;

--Question_2:
select * from tenants.dbo.Profiles
select * from tenants.dbo.Tenancy_History

select concat(p.first_name,' ',p.last_name) as Full_Name, p.email_id as Email, p.phone as Contact
from tenants.dbo.profiles as p 
inner join 
tenants.dbo.Tenancy_History as t on p.profile_id = t.profile_id
where p.marital_status = 'Y'and 
p.profile_id in (
select profile_id from Tenants.dbo.Tenancy_History
where rent > 9000
)

--Question_3:
alter table tenants.dbo.referral add referrer_id int not null;

select distinct p.profile_id,concat(p.first_name,' ',p.last_name) as Full_name,p.phone as contact,
p.email_id as Email,p.city as City,t.house_id as House_id,t.move_in_date as Move_in_Date,
t.move_out_date as Move_out_Date,t.rent as Rent,count(r.profile_id) OVER(partition by r.profile_id) 
as Total_No_Referrals,e.latest_employer as Latest_Employer,e.occupational_category as 
Occupational_Category from tenants.dbo.tenancy_history t 
inner join tenants.dbo.profiles p on t.profile_id = p.profile_id
inner join tenants.dbo.employment_details e on e.profile_id = p.profile_id
left join tenants.dbo.referral r on  p.profile_id = r.profile_id
where p.city in('Bangalore','Pune') AND
((t.move_in_date between'2015-01-01'and'2016-01-31')or
(t.move_out_date between'2015-01-01'and'2016-01-31')or
(t.move_in_date >='2015-01-01'and t.move_out_date <= '2016-01-31'))
ORDER BY rent DESC;

--Question_4: 
select concat(p.first_name,' ',p.last_name) as Full_Name, p.email_id as Email_Id, p.phone as Contact,
p.referral_code as Referral_Code,COUNT(r.profile_id) AS Referral_Count,
COUNT(r.profile_id) AS Referral_Count,
    SUM(
	CASE 
	WHEN r.referral_valid = 1 THEN r.referrer_bonus_amount 
	ELSE 0 
	END) AS Total_Bonus_Amount
from Tenants.dbo.Profiles p
inner join tenants.dbo.referral r on p.profile_id = r.profile_id
group by p.profile_id, p.first_name, p.last_name, p.email_id, p.phone, p.referral_code
having count(r.profile_id) > 1

select * from tenants.dbo.Referral;

--Question_5:
select distinct Addresses.city,sum(tenancy_history.rent) over(partition by addresses.city) as Rent_Generated,
sum(tenancy_history.rent) over() as Total_Rent
from Tenancy_History
inner join Addresses on Addresses.house_id = Tenancy_History.house_id

--Question_6:
create view vw_tenant as
select profile_id,tenancy_history.move_in_date,houses.house_type,
houses.beds_vacant,addresses.description,addresses.city
from tenancy_history 
inner join houses on tenancy_history.house_id = houses.house_id
inner join addresses on addresses.house_id = houses.house_id
where move_in_date >= '2015-04-30' AND move_out_date is null
AND beds_vacant > 0

select * from vw_tenant;
drop view vw_tenant

--Question_7:
select distinct referral.Ref_ID,Referral.profile_id,count(Referral.profile_id) over 
(partition by referral.profile_id) as TotalReferrals,
DATEADD(MM,1,referral.valid_till) as Extended_Date
from Referral
where referral.profile_id in(select referral.profile_id
from Referral
group by referral.profile_id
having count(referral.profile_id) > 2)

--Question_8:
SELECT 
    profiles.profile_id, 
    concat(first_name,' ',last_name) AS Full_Name, 
    profiles.phone AS Contact,
    Case
	    When Tenancy_History.rent > 10000 Then 'Grade A'
		When Tenancy_History.rent between 7500 and 10000 Then 'Grade B'
		Else 'Grade C'
	End as Customer_Segment
from profiles 
inner join Tenancy_History on profiles.profile_id = Tenancy_History.profile_id

--Question_9:
select concat(first_name,' ',last_name) as Full_Name,phone as Contact,
City as City,houses.bhk_type as House_details
from Tenants.dbo.Profiles
inner join Tenants.dbo.Tenancy_History on profiles.profile_id = Tenancy_History.profile_id
inner join Tenants.dbo.houses on houses.house_id = Tenancy_History.house_id
left join Tenants.dbo.referral on referral.profile_id = profiles.profile_id
where referral.profile_id is null 

--Question_10:
select top 1 Houses.house_id,bhk_type,house_type,furnishing_type,bed_count,beds_vacant,Addresses.name,
addresses.city,addresses.description,addresses.pincode,(bed_count-beds_vacant) as Total_Occupancy
from tenants.dbo.Houses
inner join tenants.dbo.Addresses on Addresses.house_id = houses.house_id
order by (bed_count-beds_vacant) desc

select Houses.house_id,bhk_type,house_type,furnishing_type,bed_count,beds_vacant,Addresses.name,
addresses.city,addresses.description,addresses.pincode,(bed_count-beds_vacant) as Total_Occupancy
from tenants.dbo.Houses
inner join tenants.dbo.Addresses on Addresses.house_id = houses.house_id
where (bed_count-beds_vacant) = 3
order by (bed_count-beds_vacant) desc
 





























