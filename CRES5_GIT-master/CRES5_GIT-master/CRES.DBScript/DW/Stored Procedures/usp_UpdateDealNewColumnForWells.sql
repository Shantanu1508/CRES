
CREATE PROCEDURE [DW].[usp_UpdateDealNewColumnForWells]
AS
BEGIN
	SET NOCOUNT ON;



----Deal-------
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
--where cm.controlid = @DealID

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
CRE.Deal.CollectInsEscrow = DealData. CollectInsEscrow	,
CRE.Deal.updatedBy = User_Name(),
CRE.Deal.updatedDate = getdate()
FROM
(
	select 
	 a.ControlID
	,a.DealCity
	,a.DealState
	,a.Companyname
	,a.FirstName
	,a.Lastname
	,a.StreetName
	,a.ZipCodePostal
	,a.PayeeName
	,a.TelephoneNumber1
	,a.FederalID1
	,a.TaxEscrowConstant
	,a.InsEscrowConstant
	,a.CollectTaxEscrow
	,a.CollectInsEscrow
	From(
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
		
		--ISNULL((Select top 1 (CAse when EscrowStatus is not null then'Y' else 'N' end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Taxes'),'N') as CollectTaxEscrow,  
		--ISNULL((Select top 1 (CAse when EscrowStatus is not null then'Y' else 'N' end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Insurance'),'N') as CollectInsEscrow
		ISNULL((Select top 1 (CAse when EscrowStatus in ('WAI','SPR') then 'N' else 'Y'  end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Taxes'),'N') as CollectTaxEscrow,  
		ISNULL((Select top 1 (CAse when EscrowStatus in ('WAI','SPR') then 'N' else 'Y'  end) from tblEscrow where controlmasterid_F in (cm.ControlId) and EscrowTypeCode = 'Insurance'),'N') as CollectInsEscrow
		
		from tblControlMaster cm 
		left join #tblNoteBorrowerRelation DealBorrower on DealBorrower.controlid = cm.Controlid
		left join tblborrower b on b.borrowerid = DealBorrower.borrowerid  
		inner join cre.deal d on d.credealid = cm.ControlId
		where d.isdeleted <> 1
	)a
	inner join cre.deal d1 on d1.credealid = a.ControlId
	Where (
	ISNULL(d1.DealCityWells,'a')<>ISNULL(a.DealCity,'a') OR
	ISNULL(d1.DealStateWells,'a')<>ISNULL(a.DealState,'a') OR
	ISNULL(d1.Companyname,'a')<>ISNULL(a.Companyname,'a') OR
	ISNULL(d1.FirstName,'a')<>ISNULL(a.FirstName,'a') OR
	ISNULL(d1.Lastname,'a')<>ISNULL(a.Lastname,'a') OR
	ISNULL(d1.StreetName,'a')<>ISNULL(a.StreetName,'a') OR
	ISNULL(d1.ZipCodePostal,'a')<>ISNULL(a.ZipCodePostal,'a') OR
	ISNULL(d1.PayeeName,'a')<>ISNULL(a.PayeeName,'a') OR
	ISNULL(d1.TelephoneNumber1,'a')<>ISNULL(a.TelephoneNumber1,'a') OR
	ISNULL(d1.FederalID1,'a')<>ISNULL(a.FederalID1,'a') OR
	ISNULL(d1.TaxEscrowConstant,0)<>ISNULL(a.TaxEscrowConstant,0) OR
	ISNULL(d1.InsEscrowConstant,0)<>ISNULL(a.InsEscrowConstant,0) OR
	ISNULL(d1.CollectTaxEscrow,'a')<>ISNULL(a.CollectTaxEscrow,'a') OR
	ISNULL(d1.CollectInsEscrow,'a')<>ISNULL(a.CollectInsEscrow,'a')
	)

)DealData
where CRE.Deal.CreDealID = DealData.ControlID




--Import [DealReserve]
TRUNCATE TABLE [CRE].[DealReserve]

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





END