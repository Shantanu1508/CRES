
CREATE PROCEDURE [dbo].[usp_UpdateDealDataForWellsFromBackshopByDealID]  
	@DealID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

IF EXISTS(Select credealid from cre.deal where credealid = @DealID)
BEGIN

PRINT('Start')
----ImportDataFromBackshopViews to landing tables
--EXEC [dbo].[usp_ImportDataFromBackshopViews]


--Import servicing data from Backshop
TRUNCATE TABLE [CRE].[ServicingFeeSchedule]
INSERT INTO [CRE].[ServicingFeeSchedule]([AcoreServicingFeeScheduleId],[InvestorId],[MinimumBalance],[MaximumBalance],[FeePct],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
Select [AcoreServicingFeeScheduleId],[InvestorId],[MinimumBalance],[MaximumBalance],[FeePct], [AuditAddUserid] ,[AuditAddDate],[AuditUpdateUserid],[AuditUpdateDate] 
from tblzCdAcoreServicingFeeSchedule

----Update Deal Data--================================

IF OBJECT_ID('tempdb..#tblNoteBorrowerRelation') IS NOT NULL             
DROP TABLE #tblNoteBorrowerRelation  

create table  #tblNoteBorrowerRelation 
(
  controlid nvarchar(256), 
  BorrowerId int
)

insert into #tblNoteBorrowerRelation(controlid,BorrowerId)

Select controlid,borrowerid
from(
	Select controlid,borrowerid,ROW_NUMBER() over (PARTITION BY controlid ORDER BY borrowerid desc) as number
	from(

Select cm.controlid,borrowerid,NoteId_F
		from(

SELECT NoteId_F, Ranked.BorrowerId,Ranked.LastNameOrOrgName , Ranked.BorrowerOwnershipHierarchyId
FROM ( SELECT B.LastNameOrOrgName
                     , B.BorrowerId
                     , BOH.BorrowerOwnershipHierarchyId
                     , RANK() OVER (PARTITION BY NoteId_F ORDER BY ParentBorrowerId_F ASC) AS BorrowerRank,
					 NoteId_F
              FROM tblBorrowerOwnershipHierarchy BOH
                     INNER JOIN tblBorrower B
                           ON B.BorrowerId = BOH.ParentBorrowerId_F
              WHERE ChildBorrowerId_F IS NULL
                     --AND NoteId_F IN (3010, 5390, 7033)
		) Ranked
WHERE Ranked.BorrowerRank = 1

)a
left join tblnote n on n.noteid = a.NoteId_F 
inner join tblcontrolmaster cm on cm.controlid = n.controlid_f
where cm.controlid = @DealID

)b
	group by controlid,borrowerid
)c
where c.number = 1
-------------------------------------------------------------

UPDATE CRE.Deal SET 	
CRE.Deal.DealCityWells = DealData.DealCity,
CRE.Deal.DealStateWells = DealData.DealState,
CRE.Deal.Companyname = DealData. Companyname,
CRE.Deal.FirstName = DealData. FirstName,
CRE.Deal.Lastname = DealData. Lastname,
CRE.Deal.StreetName = DealData. StreetName,
CRE.Deal.ZipCodePostal = DealData. ZipCodePostal,
CRE.Deal.PayeeName = DealData. PayeeName,
CRE.Deal.TelephoneNumber1 = DealData. TelephoneNumber1,
CRE.Deal.FederalID1 = DealData. FederalID1,
CRE.Deal.TaxEscrowConstant = DealData. TaxEscrowConstant,
CRE.Deal.InsEscrowConstant = DealData. InsEscrowConstant,
CRE.Deal.CollectTaxEscrow = DealData. CollectTaxEscrow,
CRE.Deal.CollectInsEscrow = DealData. CollectInsEscrow	
FROM
(
		select   
		cm.ControlID,  		
		b.city as DealCity ,   
		b.state as DealState, 		
		b.LASTNAMEORORGNAME as Companyname,  
		b.FirstName as FirstName,  
		'' as Lastname,
		b.STREETADDRESS as StreetName,
		Cast(b.Zip as nvarchar(256)) as ZipCodePostal,  
		b.LASTNAMEORORGNAME as PayeeName,  
		b.PHONENUMBER as TelephoneNumber1,  
		b.TAXID as FederalID1,  
		(Select top 1 MonthlyBalance from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Taxes') as TaxEscrowConstant,  
		(Select top 1 MonthlyBalance from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Insurance') as InsEscrowConstant,  
		ISNULL((Select top 1 (CAse when EscrowStatus in ('WAI','SPR') then 'N' else 'Y'  end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Taxes'),'N') as CollectTaxEscrow,  
		ISNULL((Select top 1 (CAse when EscrowStatus in ('WAI','SPR') then 'N' else 'Y'  end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Insurance'),'N') as CollectInsEscrow
		
		from tblControlMaster cm 
		left join #tblNoteBorrowerRelation DealBorrower on DealBorrower.controlid = cm.Controlid
		left join tblborrower b on b.borrowerid = DealBorrower.borrowerid  
		where cm.ControlId in (@DealID)

)DealData
where CRE.Deal.CreDealID = DealData.ControlID


--Import [DealReserve]
--Delete from [CRE].[DealReserve] where LoanNumber = @DealID

INSERT INTO [CRE].[DealReserve]
           ([EscrowId]
           ,[InterestEarnedCredited]
           ,[LoanNumber]
           ,[DealName]
           ,[SortOrder]
           ,[EscrowType]
           ,[EscrowTypeDesc]
           ,[MonthlyBalance]
           ,[BalanceAsOfDate]
           ,[ReserveType]
           ,[EscrowStatusDesc]
           ,[EscrowStatus]
           ,[IORPLANCODE])
 SELECT 
	ES.EscrowId
	,ES.InterestEarnedCredited
	,CM.ControlId AS [LoanNumber]
	, CM.DealName AS [DealName]
	, ES.SortOrder AS [SortOrder]
, RTRIM(LTRIM(ES.EscrowTypeCode)) AS [EscrowType]
	, RTRIM(LTRIM(ES.EscrowTypeDesc)) AS [EscrowTypeDesc]
	, Es.MonthlyBalance AS MonthlyBalance 
	, CONVERT(VARCHAR(10), ES.BalanceAsOfDate, 101) AS [BalanceAsOfDate]
	, ES.ReserveType AS [ReserveType]
	, EST.EscrowStatusDesc AS [EscrowStatusDesc]
	,EscrowStatus 
	,(case when InterestEarnedCredited = 'Borrower' then 'BR' else 'NI' end) as IORPLANCODE
	
FROM tblControlMaster CM
LEFT OUTER JOIN tblEscrow ES ON CM.ControlId = ES.ControlMasterId_F
LEFT OUTER JOIN tblzCdEscrowStatus EST ON ES.EscrowStatus = EST.EscrowStatusCD
Where CM.ControlId = @DealID


PRINT('	Deal data updated')
--================================


----Update Note Data--================================

IF OBJECT_ID('tempdb..#tblNoteBorrowerRelationNew') IS NOT NULL             
DROP TABLE #tblNoteBorrowerRelationNew 

create table  #tblNoteBorrowerRelationNew 
(
  controlid nvarchar(256), 
  BorrowerId int,
  Noteid_F int
)

insert into #tblNoteBorrowerRelationNew(controlid,BorrowerId,Noteid_F)
Select cm.controlid,borrowerid,NoteId_F
from(
	SELECT NoteId_F, Ranked.BorrowerId,Ranked.LastNameOrOrgName , Ranked.BorrowerOwnershipHierarchyId
	FROM ( 
			SELECT B.LastNameOrOrgName
			, B.BorrowerId
			, BOH.BorrowerOwnershipHierarchyId
			, RANK() OVER (PARTITION BY NoteId_F ORDER BY ParentBorrowerId_F ASC) AS BorrowerRank,
			NoteId_F
			FROM tblBorrowerOwnershipHierarchy BOH
			INNER JOIN tblBorrower B
				ON B.BorrowerId = BOH.ParentBorrowerId_F
			WHERE ChildBorrowerId_F IS NULL
			--AND NoteId_F IN (3010, 5390, 7033)
	) Ranked
	WHERE Ranked.BorrowerRank = 1
)a
left join tblnote n on n.noteid = a.NoteId_F 
inner join tblcontrolmaster cm on cm.controlid = n.controlid_f
where cm.controlid = @DealID
--=========================================================

IF OBJECT_ID('tempdb..#tblEscrowByDeal') IS NOT NULL             
DROP TABLE #tblEscrowByDeal  


create table  #tblEscrowByDeal   
(  
[EscrowId] int  NULL ,
InterestEarnedCredited nvarchar(max) null,
LoanNumber nvarchar(max) null,
DealName  nvarchar(max) null,
SortOrder int null,
EscrowType nvarchar(max) null,
EscrowTypeDesc nvarchar(max) null,
MonthlyBalance decimal(28,15) null,
BalanceAsOfDate date null,
ReserveType nvarchar(max) null,
EscrowStatusDesc nvarchar(max) null,
EscrowStatus nvarchar(max) null
)  
INSERT INTO #tblEscrowByDeal(EscrowId,InterestEarnedCredited,LoanNumber,DealName,SortOrder,EscrowType,EscrowTypeDesc,MonthlyBalance,BalanceAsOfDate,ReserveType,[EscrowStatusDesc],EscrowStatus)
 
 SELECT 
	ES.EscrowId
	,ES.InterestEarnedCredited
	,CM.ControlId AS [LoanNumber]
	, CM.DealName AS [DealName]
	, ES.SortOrder AS [SortOrder]
	, ES.EscrowTypeCode AS [EscrowType]
	, ES.EscrowTypeDesc AS [EscrowTypeDesc] 
	, Es.MonthlyBalance AS MonthlyBalance 
	, CONVERT(VARCHAR(10), ES.BalanceAsOfDate, 101) AS [BalanceAsOfDate]
	, ES.ReserveType AS [ReserveType]
	, EST.EscrowStatusDesc AS [EscrowStatusDesc]
	--, ES.Comment AS [Comment]
	,EscrowStatus 
FROM tblControlMaster CM
       LEFT OUTER JOIN tblEscrow ES ON CM.ControlId = ES.ControlMasterId_F
       LEFT OUTER JOIN tblzCdEscrowStatus EST ON ES.EscrowStatus = EST.EscrowStatusCD
WHERE CM.ControlId = @DealID
--ORDER BY CM.DealName, ES.SortOrder

--=========================================================
 
Update CRE.Note set
CRE.Note.TaxVendorLoanNumber = noteData.TaxVendorLoanNumber,
CRE.Note.TAXBILLSTATUS = noteData.TAXBILLSTATUS,
CRE.Note.CURRTAXCONSTANT = noteData.CURRTAXCONSTANT,
CRE.Note.InsuranceBillStatusCode = noteData.InsuranceBillStatusCode,
CRE.Note.RESERVETYPE = noteData.RESERVETYPE,
CRE.Note.ResDescOwnName = noteData.ResDescOwnName,
CRE.Note.MONTHLYPAYMENTAMT = noteData.MONTHLYPAYMENTAMT,
CRE.Note.IORPLANCODE = noteData.IORPLANCODE,
CRE.Note.NoDaysbeforeAssessment = noteData.NoDaysbeforeAssessment,
CRE.Note.LateChargeRateorFee = noteData.LateChargeRateorFee,
CRE.Note.DefaultOfDaysto = noteData.DefaultOfDaysto,
CRE.Note.ServicerID = noteData.TaxVendorLoanNumber,
CRE.Note.Dayslookback = noteData.DeterminationMethodDay,

CRE.Note.WF_City = noteData.WF_City,
CRE.Note.WF_State = noteData.WF_State,
CRE.Note.WF_Companyname = noteData.Companyname,
CRE.Note.WF_FirstName = noteData.FirstName,
CRE.Note.WF_Lastname = noteData.Lastname,
CRE.Note.WF_StreetName = noteData.StreetName,
CRE.Note.WF_ZipCodePostal = noteData.ZipCodePostal,
CRE.Note.WF_PayeeName = noteData.PayeeName,
CRE.Note.WF_TelephoneNumber1 = noteData.TelephoneNumber1,
CRE.Note.WF_FederalID1 = noteData.FederalID1,
CRE.Note.FundedAndOwnedByThirdParty = noteData.FundedAndOwnedByThirdParty

From(

	Select  
	(Select top 1 dealid from cre.deal where credealid = cm.ControlId and ISNULL(Isdeleted,0) = 0) dealid,
	Cast(NoteId as nvarchar(256)) as NoteId,   
  
	--New fields  
	nEx.SERVICERLOANNUMBER as TaxVendorLoanNumber,  
	ISNULL((Select top 1 case when EscrowStatusDesc in ('Waived','Springing') then 0 else 2 end from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Taxes' ),0) as TAXBILLSTATUS,  

	(Select top 1  MonthlyBalance from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Taxes'  and EscrowStatusDesc = 'Waived') as CURRTAXCONSTANT,  

	ISNULL((Select top 1 case when EscrowStatusDesc in ('Waived','Springing') then 0 else 2 end from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Insurance' ),0) as InsuranceBillStatusCode,  
 
	(Select top 1 EscrowType from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as RESERVETYPE,  
	(Select top 1 EscrowType from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as ResDescOwnName,  
	(Select top 1  MonthlyBalance from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as MONTHLYPAYMENTAMT,  
	(Select top 1 (case when InterestEarnedCredited = 'Borrower' then 'BR' else 'NI' end ) from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as IORPLANCODE,

	GracePeriod as NoDaysbeforeAssessment,  
	LateFee as LateChargeRateorFee,  
	prepay.DefaultRate as DefaultOfDaysto ,
	nrm.DeterminationMethodDay,

	b.city as WF_City ,   
	b.state as WF_State, 		
	b.LASTNAMEORORGNAME as Companyname,  
	b.FirstName as FirstName,  
	'' as Lastname,
	b.STREETADDRESS as StreetName,
	Cast(b.Zip as nvarchar(256)) as ZipCodePostal,  
	b.LASTNAMEORORGNAME as PayeeName,  
	b.PHONENUMBER as TelephoneNumber1,  
	b.TAXID as FederalID1,
	(Case WHEN n.PrimaryDebtFlag = 'No' then 1 Else 0 END) as FundedAndOwnedByThirdParty

	from tblcontrolmaster cm   
	inner join tblnote n on n.ControlId_F = cm.ControlId  
	left join tblNoteExp nEx on nEx.NoteId_F = n.NoteId  
	left join tblPrepayment prepay on prepay.PrepaymentId_NoteId_F = n.NoteId 
	left join [tblNoteARM]  nrm on nrm.NoteId_F = n.NoteId
	left join #tblNoteBorrowerRelationNew DealBorrower on DealBorrower.controlid = cm.Controlid and DealBorrower.noteid_F = n.noteid
	left join tblborrower b on b.borrowerid = DealBorrower.borrowerid 
	where cm.ControlId in (@DealID)

)noteData
where CRE.Note.DealID = noteData.dealid and CRE.Note.crenoteid = noteData.NoteId
 


--Update CurrentBls fileds (Used in wells stratergy) 
Update cre.note set cre.note.CurrentBls = a.CurrentBls
from
(
	Select nnn.noteid,ISNULL(nnn.InitialFundingAmount,0) + ISNULL(FF.Amount,0) as CurrentBls --d.credealid,nnn.crenoteid,nnn.InitialFundingAmount,ISNULL(FF.Amount,0) Amount
	from cre.note nnn
	inner join cre.deal d on d.dealid = nnn.dealid
	left join 
	(
		Select 
		nn.NoteID,
		SUM(fs.value) as Amount
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
					(
						
						Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
							from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							inner join cre.deal ds on ds.dealid = n.dealid
							where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
							and acc.IsDeleted = 0
							and ds.credealid = @DealID
							and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

					) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] nn ON nn.Account_AccountID = acc.AccountID
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
		and fs.value > 0
		and fs.date >= getdate()		
		group by 
		nn.NoteID,
		nn.InitialFundingAmount
	)FF on nnn.noteid = FF.noteid
	where d.credealid = @DealID

)a 
where cre.note.noteid = a.noteid

PRINT('	Note data updated')
--================================

----Update Property Data--================================
Update [CRE].Property SET IsDeleted = 1 where deal_dealid in (Select dealid from cre.deal where credealid = @DealID)

--Delete from [CRE].Property where deal_dealid in (Select dealid from cre.deal where credealid = @DealID)

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

from dbo.tblProperty p  
left join dbo.tblborrower b on p.BorrowerId_F = b.BorrowerId  
left join [tblPropertyExp] pEx on pEx.PropertyID_F = p.PropertyID  
left join tblzCdPropertyCondition pc on pc.PropertyConditionCd = pEx.PROPERTYCONDITIONCD_F  
left join tblzCdPropertyTypeMajor ptm on ptm.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F 
left join core.lookup lptype on lptype.name = ptm.PropertyTypeMajorDesc and parentid = 15
where ControlId_F in (@DealID)

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
	P.IsDeleted = 0
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
0 
);


PRINT('	Property data updated')

Update cre.deal set FederalID1 = null where FederalID1 not like '%[a-z]%'

Update cre.note set WF_FederalID1 = null where WF_FederalID1 not like '%[a-z]%'

Update cre.deal set FederalID1 = null where LEN(FederalID1) = 26 and FederalID1 is not null

Update cre.note set WF_FederalID1 = null where LEN(WF_FederalID1) = 26 and WF_FederalID1 is not null

PRINT('End')


END

--Update cre.Note set FundedAndOwnedByThirdParty = 0
--Update cre.Note set FundedAndOwnedByThirdParty = 1 where CRENoteID = '11536'


END