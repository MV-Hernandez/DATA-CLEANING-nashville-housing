


  /* cleaning data SQL */

  SELECT *
  FROM [portfolio M.H.].dbo.Nashvillehousing


  SELECT saledatenew, Convert(Date, SaleDate)
  FROM [portfolio M.H.].dbo.Nashvillehousing;

  ALTER TABLE Nashvillehousing
  ADD saledatenew Date;

  Update Nashvillehousing 
  SET saledatenew = CONVERT(Date, SaleDate);


  --Populate Property Address Data

  SELECT *
  FROM [portfolio M.H.].dbo.Nashvillehousing
  WHERE PropertyAddress is null;

  

  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
  FROM [portfolio M.H.].dbo.Nashvillehousing a
  JOIN [portfolio M.H.].dbo.Nashvillehousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]


UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM [portfolio M.H.].dbo.Nashvillehousing a
  JOIN [portfolio M.H.].dbo.Nashvillehousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]
WHERE a.PropertyAddress is null



--Individual columns for Property address (Adress, City, State)



  
  SELECT 
  SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
  SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress)) AS Address
  FROM [portfolio M.H.].dbo.Nashvillehousing





  ALTER TABLE Nashvillehousing
  ADD Propertysplitaddress nvarchar(255);

  Update Nashvillehousing 
  SET Propertysplitaddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


  ALTER TABLE Nashvillehousing
  ADD Propertysplitcity nvarchar(255);

  Update Nashvillehousing 
  SET Propertysplitcity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress))


 



  --Individual Columns for owner addres (Adress, City, State)




  SELECT OwnerAddress
  FROM [portfolio M.H.].dbo.Nashvillehousing


  SELECT 
  PARSENAME(REPLACE (OwnerAddress,',','.'), 3) ,
  PARSENAME(REPLACE (OwnerAddress,',','.'), 2) ,
  PARSENAME(REPLACE (OwnerAddress,',','.'), 1)
  FROM [portfolio M.H.].dbo.Nashvillehousing



  ALTER TABLE [portfolio M.H.]..Nashvillehousing
  ADD ownerstate NVARCHAR(255) 

   Update [portfolio M.H.]..Nashvillehousing
  SET ownerstate = PARSENAME(REPLACE (OwnerAddress,',','.'), 3)


  ALTER TABLE [portfolio M.H.]..Nashvillehousing
  ADD ownercity nvarchar(255);

  Update [portfolio M.H.]..Nashvillehousing 
  SET ownercity = PARSENAME(REPLACE (OwnerAddress,',','.'), 2) 


  ALTER TABLE [portfolio M.H.]..Nashvillehousing
  ADD ownersplitaddress nvarchar(255);

  Update [portfolio M.H.]..Nashvillehousing 
  SET ownersplitaddress = PARSENAME(REPLACE (OwnerAddress,',','.'), 1)




  --Change Y and N to YES and NO in "sold as vacant"

  SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
  FROM [portfolio M.H.]..Nashvillehousing
  Group BY SoldAsVacant
  ORDER BY 2


  SELECT SoldAsVacant
	,CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
  FROM [portfolio M.H.]..Nashvillehousing

  UPDATE Nashvillehousing
  SET SoldAsVacant =
  CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


	--REMOVE DUPLICATES

	WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER () OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate, LegalReference 
		ORDER BY 
		UniqueID) row_num

	FROM [portfolio M.H.]..Nashvillehousing

	)
	SELECT *
	FROM RowNumCTE
	WHERE row_num > 1
	

	--DELETE UNUSED COLUMNS

	ALTER TABLE [portfolio M.H.]..Nashvillehousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	SELECT *
	FROM [portfolio M.H.]..Nashvillehousing





