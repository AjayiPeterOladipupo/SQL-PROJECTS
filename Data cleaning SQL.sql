-- CLEANING DATA IN SQL QUERIES

select *
from ptah.dbo.housing_data

-- STANDARDIZE DATE FORMAT
select [Sale Date], convert(Date, [Sale Date])
from ptah.dbo.housing_data

update ptah.dbo.housing_data
set [Sale Date] = convert(Date, [Sale Date])

alter table ptah.dbo.housing_data
Add SaleDateConverted Date;

update ptah.dbo.housing_data
set SaleDateConverted = convert(Date, [Sale Date])

select SaleDateConverted
from ptah.dbo.housing_data

-- POPULATE PROPERTY ADDRESS DATA
select *
from ptah.dbo.housing_data
--where [Property Address] is null
order by [Parcel ID]



select a.[Parcel ID], a.[Property Address], b.[Parcel ID], b.[Property Address], isnull(a.[Property Address], b.[Property Address])
from ptah.dbo.housing_data a
JOIN ptah.dbo.housing_data b
	on a.[Parcel ID] = b.[Parcel ID]
	AND a.F1 <> b.F1
where a.[Property Address] is null

update a
set [Property Address] = isnull(a.[Property Address], b.[Property Address])
from ptah.dbo.housing_data a
JOIN ptah.dbo.housing_data b
	on a.[Parcel ID] = b.[Parcel ID]
	AND a.F1 <> b.F1
where a.[Property Address] is null

-- BREAKING AN ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, State)

select [Property Address]
from ptah.dbo.housing_data

select 
SUBSTRING([Property Address], 1, charindex(',',[Property Address])) as Address
,	SUBSTRING([Property Address], charindex(',',[Property Address]) +1 , len([Property Address])) as Address
from ptah.dbo.housing_data


select Address
from ptah.dbo.housing_data

select
PARSENAME(replace(Address, ' ','.'), 3)
,PARSENAME(replace(Address, ' ','.'), 2)
,PARSENAME(replace(Address, ' ','.'), 1)
from ptah.dbo.housing_data

alter table ptah.dbo.housing_data
Add AddressSplitCity nvarchar(255);

update ptah.dbo.housing_data
set  AddressSplitCity = PARSENAME(replace(Address, ' ','.'), 2)

alter table ptah.dbo.housing_data
Add AddressSplitState nvarchar(255);

update ptah.dbo.housing_data
set  AddressSplitState = PARSENAME(replace(Address, ' ','.'), 1)


select *
from ptah.dbo.housing_data


select distinct([Sold as vacant]), count([Sold as vacant])
from ptah.dbo.housing_data
group by [Sold as vacant]
order by 2

-- REMOVE DUPLICATES

with RowNumCTE as(
select *,
	row_number() over (
	partition by [Parcel ID],
				 [Property Address],
				 [Sale Date]
				 order by F1
				 ) row_num

from ptah.dbo.housing_data
--order by [Parcel ID]
)
select *
from RowNumCTE
where row_num > 1
order by [Property Address]


with RowNumCTE as(
select *,
	row_number() over (
	partition by [Parcel ID],
				 [Property Address],
				 [Sale Date]
				 order by F1
				 ) row_num

from ptah.dbo.housing_data
--order by [Parcel ID]
)
delete
from RowNumCTE
where row_num > 1
--order by [Property Address]

with RowNumCTE as(
select *,
	row_number() over (
	partition by [Parcel ID],
				 [Property Address],
				 [Sale Date]
				 order by F1
				 ) row_num

from ptah.dbo.housing_data
--order by [Parcel ID]
)
select *
from RowNumCTE
where row_num > 1
order by [Property Address]


-- DELETE UNUSED COLUMNS

select *
from ptah.dbo.housing_data

alter table ptah.dbo.housing_data
drop column [Address], [Tax District], [Property Address]

select *
from ptah.dbo.housing_data

alter table ptah.dbo.housing_data
drop column [Sale Date]