/****** Script for SelectTopNRows command from SSMS  ******/


SELECT *
  FROM [Portfolio Project].[dbo].[NashvilleHousing]


  --------------------------------------------------------------------------------------------------------------------------
  ---- Standardize Date Format

  Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project].[dbo].[NashvilleHousing]


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data


  Select *
From [Portfolio Project].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


 Select *
From [Portfolio Project].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID;

select 
SUBSTRING (PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress)-1)AS ADDRESS
,SUBSTRING (PropertyAddress , CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))AS ADDRESS

From [Portfolio Project].[dbo].[NashvilleHousing]



ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET PropertySplitCity  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio Project].[dbo].[NashvilleHousing]



ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio Project].[dbo].[NashvilleHousing]
Add OwnerSplitState  Nvarchar(255);

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from [Portfolio Project].[dbo].[NashvilleHousing];


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field
 

 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portfolio Project].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from [Portfolio Project].[dbo].[NashvilleHousing]

Update [Portfolio Project].[dbo].[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



	---  ---- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From [Portfolio Project].[dbo].[NashvilleHousing]
--order by ParcelID
)
Select * --(delete)
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From  [Portfolio Project].[dbo].[NashvilleHousing]


ALTER TABLE  [Portfolio Project].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From [Portfolio Project].[dbo].[NashvilleHousing]


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------