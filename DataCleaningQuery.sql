select * from NashvilleHousing

  select SaleDateConverted, CONVERT(date,SaleDate)
  from DataCleaningSQL..NashvilleHousing

  update NashvilleHousing
  Set SaleDate = CONVERT(date,SaleDate)
  --Adding a more readable Date
  ALTER TABLE NashvilleHousing
  add SaleDateConverted Date;

  update NashvilleHousing
  Set SaleDateConverted = CONVERT(date,SaleDate)
  --Removing redundant data
  ALTER TABLE NashvilleHousing
  DROP COLUMN SaleDate;


  Select *
  From DataCleaningSQL..NashvilleHousing
 -- where PropertyAddress is null
  order by ParcelID

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
  From DataCleaningSQL..NashvilleHousing a
  JOIN DataCleaningSQL..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
  where b.PropertyAddress is null
  --Filling in Null addresses
  Update a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  From DataCleaningSQL..NashvilleHousing a
  JOIN DataCleaningSQL..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  Select PropertyAddress
  From DataCleaningSQL..NashvilleHousing
 -- where PropertyAddress is null
  --order by ParcelID

  Select
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
  From DataCleaningSQL..NashvilleHousing



  --Add column for street address
  ALTER TABLE NashvilleHousing
  add PropertySplitAddress Nvarchar(255);
  --populate street address
  update NashvilleHousing
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
  --Add column for city
  ALTER TABLE NashvilleHousing
  add PropertySplitCity Nvarchar(255);
  --populate city
  update NashvilleHousing
  Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
  --Checking
  Select* 
  From DataCleaningSQL..NashvilleHousing

  --Removing redundant data
  ALTER TABLE NashvilleHousing
  DROP COLUMN PropertyAddress;



  Select
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
  from DataCleaningSQL..NashvilleHousing
  --Adding and populating columns for splitting up the OwnerAdress
  ALTER TABLE NashvilleHousing
  add OwnerSplitAddress Nvarchar(255);

  update NashvilleHousing
  Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

  ALTER TABLE NashvilleHousing
  add OwnerSplitCity Nvarchar(255);

  update NashvilleHousing
  Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  ALTER TABLE NashvilleHousing
  add OwnerSplitState Nvarchar(255);

  update NashvilleHousing
  Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



  Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
  from DataCleaningSQL..NashvilleHousing
  group by SoldAsVacant
  order by 2

  Select SoldAsVacant,
  Case when SoldAsVacant = 'Y' Then 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
  from DataCleaningSQL..NashvilleHousing

  Update NashvilleHousing
  Set SoldAsVacant =   Case when SoldAsVacant = 'Y' Then 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
from DataCleaningSQL.dbo.NashvilleHousing
)

Select *
from RowNumCTE
where row_num > 1
--order by LegalReference


Select * from DataCleaningSQL..NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN TaxDistrict, OwnerAddress;
