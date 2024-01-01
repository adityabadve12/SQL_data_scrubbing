Select * 
From sql_project_2..Nashville_housing

--Standardizing date format
Select SaleDate
From sql_project_2..Nashville_housing

--Converting the date-time format of SaleDate to date format
Select SaleDate, CONVERT(Date,SaleDate)
From sql_project_2..Nashville_housing

Update Nashville_housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashville_housing
Add SaleDateConverted Date

Update Nashville_housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populating missing Propert address data

Select *
From sql_project_2..Nashville_housing
--where PropertyAddress is null
order by ParcelID


Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From sql_project_2..Nashville_housing a
JOIN sql_project_2..Nashville_housing b
ON a.ParcelID = b.ParcelID 
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null	


--Breaking out Propery address into individual columns (Address,City)

Select PropertyAddress
From sql_project_2..Nashville_housing

Select	
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

 From sql_project_2..Nashville_housing


 ALTER TABLE sql_project_2..Nashville_housing
Add PropertySplitAddress Nvarchar(255);

Update sql_project_2..Nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

 ALTER TABLE sql_project_2..Nashville_housing
Add PropertySplitCity Nvarchar(255);

Update sql_project_2..Nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))




Select *
From sql_project_2..Nashville_housing

--Breaking out Owner address into individual columns (Address,City, State)

Select OwnerAddress
From sql_project_2..Nashville_housing

Select
PARSENAME(REPLACE(OwnerAddress,',','.') , 3),
PARSENAME(REPLACE(OwnerAddress,',','.') , 2),
PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
From sql_project_2..Nashville_housing


ALTER TABLE sql_project_2..Nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update sql_project_2..Nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)

 ALTER TABLE sql_project_2..Nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update sql_project_2..Nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE sql_project_2..Nashville_housing
Add OwnerSplitState Nvarchar(255);

Update sql_project_2..Nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') , 1)

Select *
From sql_project_2..Nashville_housing


--Replacing Y and N to Yes and No in "SoldAsVacant" column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From sql_project_2..Nashville_housing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From sql_project_2..Nashville_housing

Update sql_project_2..Nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From sql_project_2..Nashville_housing
Group by SoldAsVacant
Order by 2


--Removing duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
From sql_project_2..Nashville_housing
--order by ParcelID
)
DELETE 
From RowNumCTE
where row_num > 1 
--Order by PropertyAddress



--Delecting unnecessary columns from the database

Select *
From sql_project_2..Nashville_housing

ALTER TABLE sql_project_2..Nashville_housing
DROP COLUMN OwnerAddress, PropertAddress, TaxDistrict

ALTER TABLE sql_project_2..Nashville_housing
DROP COLUMN SalePrice
