  
CREATE VIEW [dbo].[WF_Property] AS  
select

n.TaxVendorLoanNumber as VendorLoanNumber,  
ROW_NUMBER() OVER (PARTITION BY n.TaxVendorLoanNumber  ORDER BY n.TaxVendorLoanNumber) AS  SequenceNumber,
'CRE' as CollateralType  ,  
PropertyName as ProjectName,  
LEFT(HOUSESTREET1,(PATINDEX('% %',HOUSESTREET1))) HOUSESTREET1, 
'' as HOUSESTREET2, 
SUBString(HOUSESTREET1,Charindex(' ',HOUSESTREET1) + 1,LEN(HOUSESTREET1)) as StreetName1,
'' as StreetName2,
VILLAGE,  
lTownCode.Value as TownCode,

'DEF' as County,

p.pState as StateCode,
LEFT(CONVERT(NVARCHAR, ZIPCODE) + '000000000', 9) as ZIPCODE,  
OwnerOccupied,  
lPropertyType.value1 as PROPDESCCODE,  
 'G' as OVERALLRATING  ,  
CollectTaxEscrow,  
 '' as SMSA  ,  
SALESPRICE,  
 '' as AppraisedValueSF  ,  
 '' as AppraisedValueUN  ,
Cast(Format(ConstructionDate,'MMddyyyy') as nvarchar(256)) as ConstructionDate, 

p.NextInspectionDate as NextInspectionDate  , 
  
NumberofStories,  
(CASE when MeasuredIn = 'Rooms' then 'S' when MeasuredIn = 'Units' then 'U' else 'M' END) as MeasuredIn,  
TotalSquareFeet,  
TotalRentableSqFt,  

p.GroundLease as GroundLease,

(CASE when MeasuredIn = 'Rooms' then 0 else TotalNumberofUnits END) TotalNumberofUnits,

p.NumberOfTenants as NumberOfTenants  ,
OverallCondition,
p.VacancyFactor as VacancyFactor  ,  
 '' as CommNRA  ,  
 '' as ResdNRA  ,
Cast(Format(RenovationDate,'MMddyyyy') as nvarchar(256)) as RenovationDate,

ProjectName as ProjectNameOptional ,
null as SecuritizationID ,
null as ProspectusID ,
null as PropertyStatus ,

p.DealAllocationAmtPCT as Allocation ,

1 as LIENPosition , --p.LIENPosition as LIENPosition ,

null as AllocofLoanatContra ,
null as ApprasialValueatContribution ,
null as ApprasialDateatContribution ,
null as LastPropContrbutionDT ,
null as NCFatContribution ,
null as AllocLoanAmount ,
d.CollectInsEscrow as CollectINSEscrow ,
'' as DefeasedDate ,
lPropertyType.value1 as PropertyDescCode2 ,
'' as ResdNRA1 ,
(CASE when p.Country = 'USA' then 'US' ELSE p.Country END ) as CountryCode ,
p.CMSAProperyType as CMSAProperyType ,

CreDealID,  
dealname, 
n.CRENoteID as CRENoteID

from cre.Property p 
 inner join cre.deal d on p.deal_dealid=d.dealid 
 inner join cre.note n on n.dealid =d.dealid
 left join core.lookup lPropertyType on lPropertyType.Name = d.DealPropertyType and lPropertyType.ParentID = 15
 left join CRE.[Town] lTownCode on lTownCode.Name = p.VILLAGE 