--standardize date format
select SaleDateConverted , convert(date,saledate) 
from House_Data.dbo.Nashvile_Housing

update  House_Data.dbo.Nashvile_Housing
set SaleDate=convert(date,saledate)

alter table House_Data.dbo.Nashvile_Housing
add SaleDateConverted date

update  House_Data.dbo.Nashvile_Housing
set SaleDateConverted=convert(date,saledate)


-- populate propert address data

select * from  House_Data.dbo.Nashvile_Housing
order by ParcelID
--where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress) 
from House_Data.dbo.Nashvile_Housing a
join House_Data.dbo.Nashvile_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

update a
set PropertyAddress= ISNULL(a.PropertyAddress , b.PropertyAddress)
from House_Data.dbo.Nashvile_Housing a
join House_Data.dbo.Nashvile_Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns (Address , City , State)

select
substring(PropertyAddress, 1 , charindex(',' , PropertyAddress)-1) as Address
,substring (PropertyAddress,  charindex(',' , PropertyAddress)+1, len(PropertyAddress)) as City
from House_Data.dbo.Nashvile_Housing

alter table House_Data.dbo.Nashvile_Housing
add PropertySplitAddress nvarchar(255)

update House_Data.dbo.Nashvile_Housing
set PropertySplitAddress=substring(PropertyAddress, 1 , charindex(',' , PropertyAddress)-1)  

alter table House_Data.dbo.Nashvile_Housing
add PropertySplitCity nvarchar(255)

update House_Data.dbo.Nashvile_Housing
set PropertySplitCity=substring (PropertyAddress,  charindex(',' , PropertyAddress)+1, len(PropertyAddress))

select * from House_Data.dbo.Nashvile_Housing


-- Same for OwnerAddress


select 
parsename(replace(owneraddress,',','.'),3) ,
parsename(replace(owneraddress,',','.'),2) ,
parsename(replace(owneraddress,',','.'),1) 
from House_Data.dbo.Nashvile_Housing

Alter table House_Data.dbo.Nashvile_Housing
Add OwnerSplitAddress nvarchar(250)

Update House_Data.dbo.Nashvile_Housing
set OwnerSplitAddress=parsename(replace(owneraddress,',','.'),3)

Alter table House_Data.dbo.Nashvile_Housing
add OwnerSplitCity nvarchar(250)

Update House_Data.dbo.Nashvile_Housing
set OwnerSplitCity=parsename(replace(owneraddress,',','.'),2)

Alter table House_Data.dbo.Nashvile_Housing
add OwnerSplitState nvarchar(250)

update House_Data.dbo.Nashvile_Housing
set OwnerSplitState=parsename(replace(owneraddress,',','.'),1)

Select * from House_Data.dbo.Nashvile_Housing

--change Y and N to Yes and No from column 'SoldasVacant'

select distinct(SoldAsVacant) , count(SoldAsVacant)
from House_Data.dbo.Nashvile_Housing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant ,
case when soldasvacant='Y' then 'YES'
when soldasvacant='N' then 'NO'
else soldasvacant
end
from House_Data.dbo.Nashvile_Housing


update House_Data.dbo.Nashvile_Housing
set SoldAsVacant=case when soldasvacant='Y' then 'YES'
when soldasvacant='N' then 'NO'
else soldasvacant
end

select SoldAsVacant , count(SoldAsVacant) from House_Data.dbo.Nashvile_Housing
group by SoldAsVacant


--Remove Duplicates

select * from House_Data.dbo.Nashvile_Housing

with RowNumCTE as (
select *,
row_number() over(
partition by parcelid,
propertyaddress,
saledate,
saleprice,
legalreference
order by uniqueid) Row_Num
from House_Data.dbo.Nashvile_Housing
) 

delete from RowNumCTE
where Row_Num>1
           

-- Delete Unused Columns

select * from House_Data.dbo.Nashvile_Housing

Alter table House_Data.dbo.Nashvile_Housing
drop column propertyaddress,owneraddress,taxdistrict

Alter table House_Data.dbo.Nashvile_Housing
drop column saledate



