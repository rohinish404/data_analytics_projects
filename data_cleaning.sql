select * 
from portfolio_pjs.housingData;

select SaleDate
from portfolio_pjs.housingData;


select *
from portfolio_pjs.housingData
where PropertyAddress is null;

-- IFNULL takes two arguements where it checks if the values in the first on is null or not, if its null then it relaces the null value with the second arguement
select a.ParcelId, a.PropertyAddress, b.ParcelID, b.PropertyAddress,IFNULL(a.PropertyAddress, b.PropertyAddress)
from portfolio_pjs.housingData a
join portfolio_pjs.housingData b
	on a.ParcelID = b.ParcelId
    and a.UniqueId <> b.UniqueID
where a.PropertyAddress is null;

SET SQL_SAFE_UPDATES = 0;

-- 
UPDATE portfolio_pjs.housingData a
JOIN portfolio_pjs.housingData b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueId <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


select PropertyAddress
from portfolio_pjs.housingData;


USE portfolio_pjs; -- Specify the correct database name


-- substring index helps in string manipulation
SELECT
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address, -- this will give string before ','
    SUBSTRING_INDEX(PropertyAddress, ',', -1) AS City.   -- this will give string after ','
FROM portfolio_pjs.housingData;


alter table housingData
add address varchar(255);

update housingData
set address = SUBSTRING_INDEX(PropertyAddress, ',', 1);


alter table housingData
add city varchar(255);

update housingData
set city = SUBSTRING_INDEX(PropertyAddress, ',', -1);

select address,city 
from portfolio_pjs.housingData;

select ownerAddress
from portfolio_pjs.housingData;


SELECT 
    SUBSTRING_INDEX(OwnerAddress, ',' , 1) AS part1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1) AS middle_part,
    SUBSTRING_INDEX(OwnerAddress, ',' , -1) AS part2
FROM 
    portfolio_pjs.housingData;
    
alter table housingData
add Ownercity varchar(255);

update housingData
set Ownercity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1);

alter table housingData
add OwnersplitAddress varchar(255);

update housingData
set OwnersplitAddress = SUBSTRING_INDEX(OwnerAddress, ',' , 1);


alter table housingData
add Ownerstate varchar(255);

update housingData
set Ownerstate = SUBSTRING_INDEX(OwnerAddress, ',' , -1);   


select Ownercity,OwnersplitAddress,Ownerstate
from  portfolio_pjs.housingData;


select distinct(SoldAsVacant),count(SoldAsVacant)
from portfolio_pjs.housingData
group by SoldAsVacant
order by 2;

-- changing values using case
select SoldAsVacant
, Case when SoldAsVacant = "Y" then "YES"
	   when SoldAsVacant = "N" then "NO"
       else SoldAsVacant
	   end
from portfolio_pjs.housingData;


update housingData
set SoldAsVacant = Case when SoldAsVacant = "Y" then "YES"
	   when SoldAsVacant = "N" then "NO"
       else SoldAsVacant
	   end;





-- removing duplicates 
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio_pjs.housingData
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;



Select *
From Portfolio_pjs.housingData;


ALTER TABLE housingData
DROP COLUMN OwnerAddress;



ALTER TABLE housingData
DROP COLUMN TaxDistrict;


ALTER TABLE housingData
DROP COLUMN PropertyAddress;

ALTER TABLE housingData
DROP COLUMN SaleDate;

