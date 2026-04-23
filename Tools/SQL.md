# Query
## general

## Chilsung

```sql
SELECT mh_ms_dci_shuttle_id, COUNT(*) AS fault_count
FROM mi_mh_ms_dci_shuttle
WHERE event_time between '2026-02-01' AND event_time <  '2026-02-19'
 AND change_field = 'Fault State'
 AND to_value = 'FAULT'
GROUP BY mh_ms_dci_shuttle_id
ORDER BY fault_count DESC;

```

```sql
SELECT
   mh_ms_dci_shuttle_id,
   fault_code,
   COUNT(*) AS alarm_count
FROM mi_mh_ms_dci_shuttle
WHERE event_time >= '2026-01-01'
 AND event_time <  '2026-02-19'
 AND change_field = 'Fault State'
 AND to_value = 'FAULT'
 AND fault_code IS NOT NULL
GROUP BY mh_ms_dci_shuttle_id, fault_code
```
## WOW

### basic
```sql
SELECT * FROM mi_tm WHERE event_time > '2025-11-13' AND tm_id = '584689' ORDER BY event_time
```
### pick rates hourly
```sql
SELECT
  FORMAT(event_time, 'yyyy-MM-dd HH') AS hour_slot,
  
  -- Sum quantities for manual picks (using oel_process_id filter)
  SUM(CASE WHEN oel_process_id LIKE 'vocollect_comms_%' AND to_value = 'PICKED' 
           THEN ISNULL(outer_case_qty, 0) ELSE 0 END) AS total_outer_case_qty,
  SUM(CASE WHEN oel_process_id LIKE 'vocollect_comms_%' AND to_value = 'PICKED' 
           THEN ISNULL(case_qty, 0) ELSE 0 END) AS total_case_qty,
  SUM(CASE WHEN oel_process_id LIKE 'vocollect_comms_%' AND to_value = 'PICKED' 
           THEN ISNULL(outer_case_qty, 0) + ISNULL(case_qty, 0) ELSE 0 END) AS Manual_qty,

  -- Count picks by location groups (manual picks assumed via to_value only)
  SUM(CASE WHEN  location LIKE 'GP%' AND to_value = 'PICKED' 
           THEN ISNULL(outer_case_qty, 0) + ISNULL(case_qty, 0) ELSE 0 END) AS gtp_qty,

  COUNT(CASE WHEN location LIKE 'EP%' AND to_value = 'PICKED' THEN 1 END) AS ep_pick_count

FROM
  mi_pick
WHERE
  event_time BETWEEN '2025-08-16 00:00:00' AND '2025-08-17 23:59:59'
GROUP BY
  FORMAT(event_time, 'yyyy-MM-dd HH')
ORDER BY
  hour_slot;
```
### forecast
```sql
select * from forecast_data where productCode = '172281' and onSaleDate < '2025-02-23'
```
### last data time
```sql
SELECT 
    (SELECT MAX(event_time) FROM [dbo].MI_TM) AS MI_TM_TO_DATE,
    (SELECT MAX(event_time) FROM [dbo].MI_PICK) AS MI_PICK_TO_DATE,
    (SELECT MAX(event_time) FROM [dbo].MI_STOCK) AS MI_STOCK_TO_DATE,
    (SELECT MAX(event_time) FROM [dbo].MI_ORDER) AS MI_ORDER_TO_DATE;
```

### Checking operator log in and log out data
```sql
select event_time, oel_class, change_uid, full_name,device_id  
from mi_user  
where (device_id like 'DEVICE-%') and event_time > '2025-03-06' order by event_time asc;
```

### manual pick qty
```sql
SELECT   
    SUM(outer_case_qty) AS total_outer_case_qty,  
    SUM(case_qty) AS total_case_qty,  
  SUM(outer_case_qty) + SUM(case_qty) AS total

FROM   
    mi_pick  
WHERE   
    event_time BETWEEN '2024-08-29 00:00:45.513' AND '2024-08-30 00:00:00'  
    AND oel_process_id LIKE 'vocollect_comms_%'  
    AND to_value = 'PICKED';
```

### mis server delay
```sql
SELECT TOP 1 *
 FROM mi_pick
 ORDER BY event_time DESC;

SELECT TOP 1
  event_time,
  DATEDIFF(MINUTE, event_time, GETDATE()) AS total_minutes,
  CONCAT(
     DATEDIFF(MINUTE, event_time, GETDATE()) / 60, ' hours ',
     DATEDIFF(MINUTE, event_time, GETDATE()) % 60, ' minutes '
  ) AS time_difference
FROM mi_pick
ORDER BY event_time DESC;

SELECT GETDATE() AS current_datetime;
```

### return order prod is despatched or not
``` sql
SELECT 
    order_id,
    ISNULL(MAX(CASE WHEN pick_state = 'FINISHED' THEN qty END), 0) AS finished_qty
FROM mi_pick
WHERE event_time > '2025-02-06'
  AND order_id IN (
      '3472758', '3473034', '3492294', '3499998', '3500474', '3502615', '3503016',
      '3504254', '3506996', '3507006', '3507673', '3507694', '3508091', '3509091',
      '3509868', '3512071', '3513733', '3515244', '3522463', '3529198', '3536463',
      '3536564', '3537646', '3538362', '3540281', '3540363', '3541041', '3565317'
  )
  AND prod_id = '111471'
GROUP BY order_id;
```
### DU order profile
```sql
select 
/*cast(event_time as date) as Date,
DATEPART(hour,event_time) as hourly,
count(distinct tm_id) as Shippers,
count(distinct CONCAT(du_id,stock_tm_id)) as 'Order Lines', 
ROUND(Cast(count(distinct CONCAT(du_id,stock_tm_id)) as float)/count(distinct tm_id),2) as 'OLs/Shipper', 
sum(case_qty)+SUM(outer_case_qty) as 'Cases', 
ROUND(Cast((sum(case_qty)+SUM(outer_case_qty)) as float)/count(distinct CONCAT(du_id,stock_tm_id)),2) as 'Cases/OL',
ROUND(Cast((sum(case_qty)+SUM(outer_case_qty)) as float)/count(distinct tm_id),2) as 'Cases/Shipper'*/

cast(event_time as date) as date, DU_ID, count(du_id) as 'picks at ergo', count(case when prod_id = '' Then 1 END) as 'featuring this many shippers'
from mi_pick
where event_time between '2025-03-04 00:00:00' and '2025-03-06 00:00:00' and to_value = 'picked'-- and category = 'ERGO'-- and location like '%EP%'
group by cast(event_time as date), DU_ID
order by cast(event_time as date) desc, DU_ID desc
/*
group by cast(event_time as date), DATEPART(hour,event_time) with rollup
order by cast(event_time as date) desc, DATEPART(hour,event_time) desc */
```

```sql
UPDATE forecast_data
SET status = 'L'
```

GTP06 pick task and tm state
```sql
SELECT xps.pick_task_id, xps.pick_task_state, xps.tm_id, xt.tm_state, xt.location, xt.final_destination
FROM x_pick_task xps
  LEFT JOIN x_gtp_pick_stn_loc xgps ON xgps.location =  xps.gtp_pick_stn_location
  LEFT JOIN x_tm xt ON xt.tm_id = xps.tm_id
  WHERE xgps.location = 'GTP06'
  and xps.pick_task_state <> 'PICKED'
ORDER BY xps.pick_task_state DESC
```
### equallity 
```sql
SELECT 
    source_tm_loc,
    COUNT(source_tm_loc) AS source_tm_loc_count
FROM (
    SELECT DISTINCT source_tm_id, source_tm_loc 
    FROM mi_depall_task 
    WHERE source_tm_loc LIKE 'PCDE0%IS%' 
	--WHERE source_tm_loc LIKE 'PCDE1%' 
	  AND event_time > '2025-02-15'
      --AND LEN(source_tm_loc) = 6
) AS distinct_records
GROUP BY source_tm_loc;
```

## basic

#### Joins
```
SELECT EmployeeDemographics.EmployeeID, first_name, last_name, Salary
FROM SQLTutorial.dbo.EmployeeDemographics
Inner Join SQLTutorial.dbo.EmployeeSalary
  ON EmployeeDemographics.EmployeeID == EmployeeSalary.EmployeeID
WHERE FirstName <> 'Michael'
ORDER by Salary DESC
```
![[2024-05-27_12h43_56.png]]

#### Union
```
SELECT EmployeeID, first_name, Age
FROM SQLTutorial.dbo.EmployeeDemographics
UNION
SELECT EmployeeID, JobTitle, Salary
FROM SQLTutorial.dbo.EmployeeSalary
ORDER by EmpliyeeID
```
![[2024-05-27_13h56_18.png]]
#### Case Statements
```
SELECT first_name, last_name, age, 
CASE 
	WHEN age <= 30 THEN 'Young' 
	WHEN age BETWEEN 31 and 50 THEN 'Old'
	WHEN age > 50 TEHN 'On Death`s Door'
END AS Age_Bracket
FROM employee_demographics;
```

 < 5000 = 5%
=> 5000 = 7%
Finance team = 10% bonus
```
SELECT first_name, last_name, salary, 
CASE 
	WHEN salary < 5000 THEN salary * 1.05 
	WHEN salary => 5000 THEN salary * 1.07
END AS New_salary
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_demographics;
```
#### Having Clause
```
SELECT JobTitle, AVG(Salary)
FROM SQLTutorial.dbo.EmployeeDemographics
JOIN SQLTutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVS(Salary) > 45000
ORDER BY AVS(Salary)
```
#### Aliasing
```
SELECT FirstName + ' ' + LastName AS FullName
FROM [SQLTutorial].[dbo].[EmployeeDemographics]
```

### sum
```sql
SELECT 
    SUM(outer_case_qty) AS total_outer_case_qty,
    SUM(case_qty) AS total_case_qty,
	SUM(outer_case_qty) + SUM(case_qty) AS total
FROM 
    mi_pick
WHERE 
    event_time BETWEEN '2024-08-29 00:00:45.513' AND '2024-08-30 00:00:00'
    AND oel_process_id LIKE 'vocollect_comms_%'
    AND to_value = 'PICKED';
```
### Ergopall
```sql
SELECT *
FROM mi_pick
WHERE event_time BETWEEN '2024-08-29 00:00:45.513' AND '2024-08-30 00:00:00'
  AND to_value = 'PICKED'
  AND Location LIKE 'EPS%' 
  --AND tm_id LIKE '100%'
ORDER BY event_time;
```

### Reject reason summary 
```sql
select Coalesce(reject_reason, 'Total') as Reasons, count (tm_id) as visits

from prodwcsmis.dbo.mi_tm 

where /*tm_id like '100%' and*/ location = 'CSORTERQAL2' and event_time > '2024-08-29 00:00:00' and change_field ='location'

group by reject_reason with rollup

order by visits desc
```

### Check long Tour
```sql
SELECT * 
FROM mi_tm
WHERE to_value LIKE 'MS05%'
  AND from_value LIKE 'MSSC%'
  AND change_field = 'Location'
  AND event_time BETWEEN DATEADD(WEEK, -1, GETDATE()) AND GETDATE()
  AND DATEDIFF(MINUTE, mission_time, event_time) > 10;
```



```sql
SELECT  
SUBSTRING(from_value, 5, 2) AS Aisle,  
SUBSTRING(from_value, 8, 2) AS Level,  
tm_id,  
mission_time as start_time,  
event_time as finish_time,  
CAST((event_time - mission_time) AS TIME) AS duration,  
from_value,  
to_value  
FROM mi_tm  
WHERE from_value LIKE 'MSSC%'  
AND change_field = 'Location'  
AND (event_time - mission_time) > DATEADD(MINUTE,10, 0)  
AND event_time BETWEEN DATEADD(DAY, -2, GETDATE()) AND GETDATE()  
ORDER BY duration DESC
```

### return name of column name, data type and length 

```
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'x_sku';
```

### how to re ordering columns
```
CREATE TABLE new_table_name AS 
SELECT
-- Select all columns, adjusting the position of depal_teach_out_complete 
column1, 
column2, 
column3, 
-- Place depal_teach_out_complete in the new position here depal_teach_out_complete, 
column4, 
column5, 
-- ... include all other columns in the desired order 
FROM old_table_name; 

-- Step 2: Copy data from the old table to the new table 
INSERT INTO new_table_name 
SELECT * FROM old_table_name; 

-- Optional: Step 3: Drop the old table if you are confident with the new table 
DROP TABLE old_table_name;

EXEC sp_rename 'old_table_name', 'new_table_name';
```

### backup 
```sql
USE PRODWCSMIS;
GO
 
DBCC SHRINKFILE (PRODWCSMIS_log, 393216)
BACKUP LOG PRODWCSMIS TO DISK='NUL:'
DBCC SHRINKFILE (PRODWCSMIS_log, 393216)
```


```sql
with palletSize as (
select 
	sku.prod_id, 
	description, 
	sku.sku_id, 
	round(EXP(SUM(LOG(CAST(LEFT(units_per_parent_str, CHARINDEX(' ', units_per_parent_str)) AS INT)))),1) AS eachesPerPallet, 
	Sum(CAST(LEFT(layers_per_parent_str, CHARINDEX(' ', layers_per_parent_str)) AS INT)) AS layersperpallet,
	max(sku.vendor_pack_size) as VPSize
from 
	x_sku as sku 
	join 
	x_sku_uom as uom 
	on 
	sku.sku_id = uom.sku_id 
where 
	CAST(LEFT(units_per_parent_str, CHARINDEX(' ', units_per_parent_str)) AS INT) > 0 and 
	complete_state = 'complete'
group by 
	sku.prod_id,
	description, 
	sku.sku_id
	),

palletSizeMinProd as (
	select 
		prod_id,
		description, 
		min(eachesPerPallet) as MinEachesPerPallet,
		max(VPSize) as VPSize1
	from 
		palletSize 
	where 
		layersperpallet > 1 
	group by 
		prod_id,
		description

	),

palletSizeMaxProd as (
	select 
		prod_id, 
		description, 
		max(eachesPerPallet) as MaxEachesPerPallet,
		max(VPSize) as VPSize2
	from 
		palletSize 
	where 
		layersperpallet > 1 
	group by 
		prod_id,
		description
	),

results as (
	select 
		sequenceID, 
		insertTimestamp,
		dcNO, 
		productCode,
		VPSize1,
		minProd.description, 
		expectedDailySales as expectedDailyEaches,
		cast(expectedDailySales as decimal)/VPSize1 as expectedDailyOMsPartial,
		ceiling(cast(expectedDailySales as decimal)/VPSize1) as expectedDailyOMsWhole,
		customerID, 
		minEachesPerPallet, 
		maxEachesPerPallet, 
		expectedDailySales/MinEachesPerPallet as MaxPalletQty,
		(expectedDailySales/MinEachesPerPallet-floor(expectedDailySales/MinEachesPerPallet))*MinEachesPerPallet as lowerEstimateReplenDemand,
		expectedDailySales/MaxEachesPerPallet as MinPalletQty,
		(expectedDailySales/MaxEachesPerPallet-floor(expectedDailySales/MaxEachesPerPallet))*MaxEachesPerPallet as higherEstimateReplenDemand,
		onSaleDate
	from 
			forecast_data 
		join 
			palletSizeMinProd as minprod 
		on 
			minprod.prod_id = productCode 
		join 
			palletSizeMaxProd as maxprod 
		on 
			maxprod.prod_id = productCode
)

select 
--* 
cast(onsaledate as date) as onsaledate,
round(sum(expecteddailyeaches),1) as 'eaches per day',
round(sum(expectedDailyOMsWhole),1) as 'Whole OMs per day' --this is rounding VPS instead of OMs.....
from results group by cast(onsaledate as date) order by onsaledate desc


--order by MaxPalletQty desc  

-- delete from forecast_data where sequenceId in (
--select sequenceID from results where MinPalletQty > 1 ;
--)

```


### Count Ergopal pick
```sql
select event_time,from_value,to_value,final_destination,tm_id 
from mi_tm 
where event_time > '2024-12-16 00:00:00' and event_time < '2024-12-17 00:00:00' and change_field = 'location' and
final_destination like 'EP%' and (to_value like 'CEPAL__LSL1' or from_value like 'CEPAL__LSL1') 
--and tm_sub_type_id = 'tote' 
order by event_time asc
```


## Toll Hive

```sql
SELECT 
    COUNT(CASE WHEN to_value LIKE 'MS25%' THEN 1 END) AS MS25,
    COUNT(CASE WHEN to_value LIKE 'MS26%' THEN 1 END) AS MS26,
    COUNT(CASE WHEN to_value LIKE 'MS27%' THEN 1 END) AS MS27,
    COUNT(CASE WHEN to_value LIKE 'MS28%' THEN 1 END) AS MS28,
    COUNT(CASE WHEN to_value LIKE 'MS29%' THEN 1 END) AS MS29
FROM mi_tm
WHERE event_time >= CAST(GETDATE() AS DATE)   -- only today
  AND change_field = 'Location'
  AND (
        to_value LIKE 'MS25%'
     OR to_value LIKE 'MS26%'
     OR to_value LIKE 'MS27%'
     OR to_value LIKE 'MS28%'
     OR to_value LIKE 'MS29%'
      );

```

```sql
SELECT 
    interval_start,
    COUNT(CASE WHEN to_value = 'CCGA01GPLS' THEN 1 END) AS CCGA01GPLS,
    COUNT(CASE WHEN to_value = 'CCGP01DST4' THEN 1 END) AS CCGP01DST4,
    COUNT(CASE WHEN to_value = 'CCGP02DST4' THEN 1 END) AS CCGP02DST4,
    COUNT(CASE WHEN to_value = 'CCGP03DST4' THEN 1 END) AS CCGP03DST4,
    COUNT(CASE WHEN to_value = 'CCGP04DST4' THEN 1 END) AS CCGP04DST4,
    COUNT(CASE WHEN to_value = 'CCGP05DST4' THEN 1 END) AS CCGP05DST4,
    COUNT(CASE WHEN to_value = 'CCGP06DST4' THEN 1 END) AS CCGP06DST4,
    COUNT(CASE WHEN to_value = 'CCGP07DST4' THEN 1 END) AS CCGP07DST4,
    COUNT(CASE WHEN to_value = 'CCGP08DST4' THEN 1 END) AS CCGP08DST4,
    COUNT(CASE WHEN to_value = 'CCGP09DST4' THEN 1 END) AS CCGP09DST4,
    COUNT(CASE WHEN to_value = 'CCGP10DST4' THEN 1 END) AS CCGP10DST4,
    COUNT(CASE WHEN to_value = 'CCGP11DST4' THEN 1 END) AS CCGP11DST4,
    COUNT(CASE WHEN to_value = 'CCGP12DST4' THEN 1 END) AS CCGP12DST4,
    COUNT(CASE WHEN to_value = 'CCGP13DST4' THEN 1 END) AS CCGP13DST4,
    COUNT(CASE WHEN to_value = 'CCGP14DST4' THEN 1 END) AS CCGP14DST4,
    COUNT(CASE WHEN to_value = 'CCGP15DST4' THEN 1 END) AS CCGP15DST4,
    COUNT(CASE WHEN to_value = 'CCGA02GPLS' THEN 1 END) AS CCGA02GPLS
FROM (
    SELECT 
        DATEADD(
            MINUTE, 
            DATEDIFF(MINUTE, 0, event_time) / 30 * 30, 
            0
        ) AS interval_start,
        to_value
    FROM mi_tm
    WHERE event_time > '2025-08-28'
      AND change_field = 'Location'
      AND (
            to_value BETWEEN 'CCGP01DST4' AND 'CCGP15DST4'
            OR to_value IN ('CCGA01GPLS', 'CCGA02GPLS')
          )
) AS t
GROUP BY interval_start
ORDER BY interval_start;

```

```sql
SELECT pick_task_id, 
COUNT(DISTINCT order_id) AS distinct_orders
FROM mi_pick
WHERE event_time between '2025-12-11' AND '2025-12-12'
  AND pick_state = 'PICKED'
  AND stock_tm_id NOT LIKE '7%'
GROUP BY pick_task_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY distinct_orders DESC;
```

