CREATE PROCEDURE [DW].[usp_UpdatePropertyNewColumnForWells]
AS
BEGIN
	SET NOCOUNT ON;


Update [CRE].Property SET IsDeleted = 1 where deal_dealid in (
	Select
	Distinct (Select top 1 dealid from cre.deal where credealid = p.ControlId_F and ISNULL(Isdeleted,0) = 0) dealid
	from dbo.tblProperty p  
	where ControlId_F in (Select Distinct credealid from cre.deal where ISNULL(Isdeleted,0) = 0 )
)
---========================================

truncate table [IO].[IN_UnderwritingProperty]

INSERT INTO [IO].[IN_UnderwritingProperty]
(dealid
,[CREDealID]
,[PropertyName]
,[ProjectName]
,[HOUSESTREET1]
,[VILLAGE]
,[ZIPCODE]
,[OwnerOccupied]
,[PROPDESCCODE]
,[SALESPRICE]
,[ConstructionDate]
,[NumberofStories]
,[MeasuredIn]
,[TotalSquareFeet]
,[TotalRentableSqFt]
,[TotalNumberofUnits]
,[OverallCondition]
,[RenovationDate]

,[PState]
,[country]
,NextInspectionDate
,GroundLease
,NumberOfTenants
,VacancyFactor
,Allocation
,LIENPosition
,CMSAProperyType
,DealAllocationAmtPCT
,PropertyTypeID
,PropertyRollUpSW

,[PropertyTypeMajorCd_F]
,City
,[Address]
,BSPropertyID
)

Select
(Select top 1 dealid from cre.deal where credealid = p.ControlId_F and ISNULL(Isdeleted,0) = 0) dealid,
p.ControlId_F as  CREDealID ,  
PropertyName as  PropertyName ,  
p.PROPERTYNAME as  ProjectName ,  
p.STREETADDRESS as  HOUSESTREET1 ,  
p.City as  VILLAGE ,  
p.ZipCode as  ZIPCODE ,  
(case when p.PERCENTOWNOCC = 1 then 'Y' else 'N' end) as  OwnerOccupied , 
 
ISNULL(lptype.Value1,'OT') as  PROPDESCCODE ,  

p.ACQUISITIONAMOUNT as  SALESPRICE ,  
(CASE WHEN LEN(p.YEARBUILT) = 4 then '01/01/' + Cast( p.YEARBUILT as nvarchar(256)) else null end) as  ConstructionDate ,  
p.NUMBEROFSTORIES as  NumberofStories ,  
p.UNITMEASUREPRIMARY as  MeasuredIn ,  
p.NUMBEROFUNITSPRIMARY as  TotalSquareFeet ,  
p.NRSFPRIMARY as  TotalRentableSqFt ,  
p.NUMBEROFUNITSPRIMARY as  TotalNumberofUnits ,  
pc.PropertyConditionDesc as  OverallCondition ,  
(CASE WHEN LEN(p.YEARRENOVATED) = 4 then '01/01/' + Cast( p.YEARRENOVATED as nvarchar(256)) else null end)  as  RenovationDate ,

p.[State],
p.[country] 
,p.InspectionDate as NextInspectionDate
,(Case when (Select count(gl.PropertyId_F) from tblGroundLease gl where gl.PropertyId_F in (Select sp.PropertyId from tblproperty sp where sp.controlid_f = p.ControlId_F)) > 0 then 'Y' else 'N' end)GroundLease
,pEx.NumOfTenants as NumberOfTenants
,ptm.UAH_VacancyFactor as VacancyFactor
,p.DealAllocationAmt as Allocation
,p.LIENPosition
,p.PropertyTypeMajorCd_F as CMSAProperyType
,p.DealAllocationAmtPCT
,lptype.lookupid as PropertyTypeID
,pEx.PropertyRollUpSW

,p.PropertyTypeMajorCd_F
,p.City
,p.STREETADDRESS as  [Address]
,p.PropertyID

from dbo.tblProperty p  
left join dbo.tblborrower b on p.BorrowerId_F = b.BorrowerId  
left join [tblPropertyExp] pEx on pEx.PropertyID_F = p.PropertyID  
left join tblzCdPropertyCondition pc on pc.PropertyConditionCd = pEx.PROPERTYCONDITIONCD_F  
left join tblzCdPropertyTypeMajor ptm on ptm.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F 
left join core.lookup lptype on lptype.name = ptm.PropertyTypeMajorDesc and parentid = 15
where ControlId_F in (Select Distinct credealid from cre.deal where ISNULL(Isdeleted,0) = 0 )

----------------------------------
MERGE [CRE].Property P
USING [IO].[IN_UnderwritingProperty] LP
ON P.PropertyName = LP.PropertyName and LP.dealid = P.deal_dealid  and LP.CMSAProperyType = p.CMSAProperyType
WHEN MATCHED THEN
Update SET
	P.ProjectName = LP.ProjectName,
	P.HOUSESTREET1 = LP.HOUSESTREET1,
	P.VILLAGE = LP.VILLAGE,
	P.ZIPCODE = LP.ZIPCODE,
	P.OwnerOccupied = LP.OwnerOccupied,
	P.PROPDESCCODE = LP.PROPDESCCODE,
	P.SALESPRICE = LP.SALESPRICE,
	P.ConstructionDate = LP.ConstructionDate,
	P.NumberofStories = LP.NumberofStories,
	P.MeasuredIn = LP.MeasuredIn,
	P.TotalSquareFeet = LP.TotalSquareFeet,
	P.TotalRentableSqFt = LP.TotalRentableSqFt,
	P.TotalNumberofUnits = LP.TotalNumberofUnits,
	P.OverallCondition = LP.OverallCondition,
	P.RenovationDate = LP.RenovationDate,
	P.[PState] = LP.[PState]  ,
	P.[country] = LP.[country]  ,
	P.NextInspectionDate = LP.NextInspectionDate  ,
	P.GroundLease = LP.GroundLease  ,
	P.NumberOfTenants = LP.NumberOfTenants  ,
	P.VacancyFactor = LP.VacancyFactor  ,
	P.Allocation = LP.Allocation  ,
	P.LIENPosition = LP.LIENPosition  ,
	P.CMSAProperyType = LP.CMSAProperyType ,
	P.DealAllocationAmtPCT = LP.DealAllocationAmtPCT ,
	P.PropertyType = LP.PropertyTypeID ,
	P.PropertyRollUpSW = LP.PropertyRollUpSW ,
	P.IsDeleted = 0,

	P.PropertyTypeMajorCd_F = LP.PropertyTypeMajorCd_F ,
	P.City = LP.City ,
	P.[Address] = LP.[Address],
	P.BSPropertyID = LP.BSPropertyID	
	
WHEN NOT MATCHED THEN
INSERT
(Deal_DealID
,[PropertyName]
,[ProjectName]
,[HOUSESTREET1]
,[VILLAGE]
,[ZIPCODE]
,[OwnerOccupied]
,[PROPDESCCODE]
,[SALESPRICE]
,[ConstructionDate]
,[NumberofStories]
,[MeasuredIn]
,[TotalSquareFeet]
,[TotalRentableSqFt]
,[TotalNumberofUnits]
,[OverallCondition]
,[RenovationDate]
,[PState]
,[country] 
,NextInspectionDate
,GroundLease
,NumberOfTenants
,VacancyFactor
,Allocation
,LIENPosition
,CMSAProperyType
,DealAllocationAmtPCT
,PropertyType
,PropertyRollUpSW
,IsDeleted

,[PropertyTypeMajorCd_F]
,City
,[Address]
,BSPropertyID
)
VALUES(
LP.dealid,
LP.PropertyName,
LP.ProjectName,
LP.HOUSESTREET1,
LP.VILLAGE,
LP.ZIPCODE,
LP.OwnerOccupied,
LP.PROPDESCCODE,
LP.SALESPRICE,
LP.ConstructionDate,
LP.NumberofStories,
LP.MeasuredIn,
LP.TotalSquareFeet,
LP.TotalRentableSqFt,
LP.TotalNumberofUnits,
LP.OverallCondition,
LP.RenovationDate,
LP.[PState],
LP.[country],
LP.NextInspectionDate,
LP.GroundLease,
LP.NumberOfTenants,
LP.VacancyFactor,
LP.Allocation,
LP.LIENPosition,
LP.CMSAProperyType,
LP.DealAllocationAmtPCT,
LP.PropertyTypeID,
LP.PropertyRollUpSW,
0,
LP.[PropertyTypeMajorCd_F],
LP.City,
LP.[Address],
LP.BSPropertyID
);




---===tblAppraisal data from backshop in property table

--ALTER TABLE CRE.PROPERTY ADD ReportDate date null
--ALTER TABLE CRE.PROPERTY ADD ValuationDate date null
--ALTER TABLE CRE.PROPERTY ADD ReconciledValue decimal(28,15) null
--ALTER TABLE CRE.PROPERTY ADD AsCompletedDate date null
--ALTER TABLE CRE.PROPERTY ADD AsCompletedValue decimal(28,15) null
--ALTER TABLE CRE.PROPERTY ADD AsStabilizedValuationDate date null
--ALTER TABLE CRE.PROPERTY ADD AsStabilizedValue decimal(28,15) null
--ALTER TABLE CRE.PROPERTY ADD LandValue decimal(28,15) null
--ALTER TABLE CRE.PROPERTY ADD Comment nvarchar(max) null
--ALTER TABLE CRE.PROPERTY ADD HighlightComment nvarchar(max) null

IF OBJECT_ID('tempdb..[#tblAppraisal]') IS NOT NULL                                         
 DROP TABLE [#tblAppraisal]

CREATE TABLE #tblAppraisal(
controlid nvarchar(256) null,
PropertyID int null,
PropertyName nvarchar(256) null,
ReportDate date null,
ValuationDate date null,
ReconciledValue decimal(28,15) null,
AsCompletedDate date null,
AsCompletedValue decimal(28,15) null,
AsStabilizedValuationDate date null,
AsStabilizedValue decimal(28,15) null,
LandValue decimal(28,15) null,
Comment nvarchar(max) null,
HighlightComment nvarchar(max) null,
ShardName nvarchar(256) null

)
INSERT INTO #tblAppraisal(controlid,PropertyID,PropertyName,ReportDate,ValuationDate,ReconciledValue,AsCompletedDate,AsCompletedValue,AsStabilizedValuationDate,AsStabilizedValue,LandValue,Comment,HighlightComment,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select c.controlid,PropertyID,PropertyName,ReportDate,
ValuationDate,
ReconciledValue,
AsCompletedDate,
AsCompletedValue,
AsStabilizedValuationDate,
AsStabilizedValue,
LandValue
,Cast(Comment as nvarchar(max)) Comment
,Cast(HighlightComment as nvarchar(max)) HighlightComment
from tblProperty p 
inner join tblControlmaster c on c.controlid = p.controlid_F
left join tblAppraisal a on p.PropertyId = a.PropertyId_F
left join 
(
	Select TopLevelControlNotePropertyId,HighlightComment
	From(
		Select TopLevelControlNotePropertyId,HighlightComment,AuditUpdateDate ,
		ROw_number() Over (Partition by TopLevelControlNotePropertyId order by AuditUpdateDate desc)as rowno
		from tblHighlights 
	)a
	where rowno = 1
) h on h.TopLevelControlNotePropertyId = a.PropertyId_F
--where dealname = ''Regent Southwest Office Portfolio''
order by controlid,PropertyID
'

UPDATE CRE.Property SET
CRE.Property.ReportDate = a.ReportDate,
CRE.Property.ValuationDate = a.ValuationDate,
CRE.Property.ReconciledValue = a.ReconciledValue,
CRE.Property.AsCompletedDate = a.AsCompletedDate,
CRE.Property.AsCompletedValue = a.AsCompletedValue,
CRE.Property.AsStabilizedValuationDate = a.AsStabilizedValuationDate,
CRE.Property.AsStabilizedValue = a.AsStabilizedValue,
CRE.Property.LandValue = a.LandValue,
CRE.Property.Comment = a.Comment,
CRE.Property.HighlightComment = a.HighlightComment
From(	
	Select dealid,controlid,PropertyID,PropertyName,ReportDate,ValuationDate,ReconciledValue,AsCompletedDate,AsCompletedValue,AsStabilizedValuationDate,AsStabilizedValue,LandValue,Comment,HighlightComment 
	From(
		Select Distinct d.dealid,controlid,PropertyID,PropertyName,ReportDate,ValuationDate,ReconciledValue,AsCompletedDate,AsCompletedValue,AsStabilizedValuationDate,AsStabilizedValue,LandValue,Comment,HighlightComment 
		,Row_number() Over(Partition by d.dealid,controlid,PropertyID order by controlid,PropertyName,ReportDate desc) as rowno
		from #tblAppraisal ap
		inner join cre.Deal d on d.credealid = ap.controlid
	)a
	where a.rowno = 1
)a where CRE.Property.Deal_DealID =  a.dealid and CRE.Property.PropertyName = a.PropertyName



----Update State deal level
Update cre.deal set cre.deal.statefromproperty = [State]
From(
	SELECT b.dealid,b.[State]
	From(
		Select Distinct d.dealid,d.credealid,p.city,p.PState as [State],Allocation,(city + ', ' +PState) as [M61_location],
		ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
		BSPropertyID,PropertyRollUpSW
		from cre.Property p
		inner join cre.deal d on d.dealid = p.deal_dealid
		where p.isdeleted <> 1 and d.isdeleted <> 1 AND p.PState IS NOT NULL
	)b where rno = 1
)z
where cre.deal.dealid = z.dealid



END
GO

