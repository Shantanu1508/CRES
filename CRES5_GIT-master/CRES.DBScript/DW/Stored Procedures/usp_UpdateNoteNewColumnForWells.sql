
CREATE PROCEDURE [DW].[usp_UpdateNoteNewColumnForWells]
AS
BEGIN
	SET NOCOUNT ON;


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
--WHERE CM.ControlId = @DealID
--ORDER BY CM.DealName, ES.SortOrder

--=========================================================
 IF OBJECT_ID('tempdb..#tbldetail') IS NOT NULL             
DROP TABLE #tbldetail 

create table  #tbldetail
(
dealid	unIQUEIDENTIFIER	    ,
NoteId	nvarchar(256)	    ,
TaxVendorLoanNumber	nvarchar(256)	    ,
TAXBILLSTATUS	nvarchar(256)	    ,
CURRTAXCONSTANT	int	    ,
InsuranceBillStatusCode	nvarchar(256)	    ,
RESERVETYPE	nvarchar(256)	    ,
ResDescOwnName	nvarchar(256)	    ,
MONTHLYPAYMENTAMT	int	    ,
IORPLANCODE	nvarchar(256)	    ,
NoDaysbeforeAssessment	DECIMAL (28, 15) NULL	    ,
LateChargeRateorFee	DECIMAL (28, 15) NULL	    ,
DefaultOfDaysto	DECIMAL (28, 15) NULL	    ,
DeterminationMethodDay	nvarchar(256)	    ,
WF_City	nvarchar(256)	    ,
WF_State	nvarchar(256)	    ,
Companyname	nvarchar(256)	    ,
FirstName	nvarchar(256)	    ,
Lastname	nvarchar(256)	    ,
StreetName	nvarchar(256)	    ,
ZipCodePostal	nvarchar(256)	    ,
PayeeName	nvarchar(256)	    ,
TelephoneNumber1	nvarchar(256)	    ,
FederalID1	nvarchar(256)	    ,
FundedAndOwnedByThirdParty	BIT	    
)

INSERT INTO #tbldetail(dealid,NoteId,TaxVendorLoanNumber,TAXBILLSTATUS,CURRTAXCONSTANT,InsuranceBillStatusCode,RESERVETYPE,ResDescOwnName,MONTHLYPAYMENTAMT,IORPLANCODE,NoDaysbeforeAssessment,LateChargeRateorFee,DefaultOfDaysto,DeterminationMethodDay,WF_City,WF_State,Companyname,FirstName,Lastname,StreetName,ZipCodePostal,PayeeName,TelephoneNumber1,FederalID1,FundedAndOwnedByThirdParty)
Select  
(Select top 1 dealid from cre.deal where credealid = cm.ControlId and ISNULL(Isdeleted,0) = 0) dealid,
Cast(n.NoteId as nvarchar(256)) as NoteId,   
nEx.SERVICERLOANNUMBER as TaxVendorLoanNumber,  
CAST(ISNULL((Select top 1 case when EscrowStatusDesc in ('Waived','Springing') then 0 else 2 end from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Taxes' ),0) as nvarchar(10)) as TAXBILLSTATUS,  
(Select top 1  MonthlyBalance from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Taxes'  and EscrowStatusDesc = 'Waived') as CURRTAXCONSTANT, 
caST(ISNULL((Select top 1 case when EscrowStatusDesc in ('Waived','Springing') then 0 else 2 end from #tblEscrowByDeal where LoanNumber = cm.ControlId and EscrowType = 'Insurance' ),0)as nvarchar(10)) as InsuranceBillStatusCode,   
(Select top 1 EscrowType from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as RESERVETYPE,  
(Select top 1 EscrowType from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as ResDescOwnName,  
CAST((Select top 1  ROUND(MonthlyBalance,0) from #tblEscrowByDeal where LoanNumber = cm.ControlId and SortOrder = 3) as INT) as MONTHLYPAYMENTAMT,  
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
inner join cre.deal d on d.credealid = cm.ControlId
inner join cre.note n1 on n1.CRENoteId = n.NoteId
where d.isdeleted <> 1 and ISNUMERIC(n1.CRENoteId) = 1
		
--=======================================================		 
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
CRE.Note.FundedAndOwnedByThirdParty = noteData.FundedAndOwnedByThirdParty,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	select 
	 z.dealid
	,z.NoteId
	,z.TaxVendorLoanNumber
	,z.TAXBILLSTATUS
	,z.CURRTAXCONSTANT
	,z.InsuranceBillStatusCode
	,z.RESERVETYPE
	,z.ResDescOwnName
	,z.MONTHLYPAYMENTAMT
	,z.IORPLANCODE
	,z.NoDaysbeforeAssessment
	,z.LateChargeRateorFee
	,z.DefaultOfDaysto
	,z.DeterminationMethodDay
	,z.WF_City
	,z.WF_State
	,z.Companyname
	,z.FirstName
	,z.Lastname
	,z.StreetName
	,z.ZipCodePostal
	,z.PayeeName
	,z.TelephoneNumber1
	,z.FederalID1
	,z.FundedAndOwnedByThirdParty
	From(
		Select dealid,NoteId,TaxVendorLoanNumber,TAXBILLSTATUS,CURRTAXCONSTANT,InsuranceBillStatusCode,RESERVETYPE,ResDescOwnName,MONTHLYPAYMENTAMT,IORPLANCODE,NoDaysbeforeAssessment,LateChargeRateorFee,DefaultOfDaysto,DeterminationMethodDay,WF_City,WF_State,Companyname,FirstName,Lastname,StreetName,ZipCodePostal,PayeeName,TelephoneNumber1,FederalID1,FundedAndOwnedByThirdParty
		from #tbldetail
	)z	
	inner join cre.note n2 on n2.CRENoteId = z.NoteId
	Where (
	ISNULL(n2.TaxVendorLoanNumber,'a') <> ISNULL(z.TaxVendorLoanNumber,'a') OR
	ISNULL(n2.TAXBILLSTATUS,'a') <> iSNULL(z.TAXBILLSTATUS,'a') OR
	ISNULL(n2.CURRTAXCONSTANT,999) <> ISNULL(z.CURRTAXCONSTANT,999) OR
	ISNULL(n2.InsuranceBillStatusCode,'a') <> ISNULL(z.InsuranceBillStatusCode,'a') OR
	ISNULL(n2.RESERVETYPE,'a') <> ISNULL(z.RESERVETYPE,'a') OR
	ISNULL(n2.ResDescOwnName,'a') <> ISNULL(z.ResDescOwnName,'a') OR
	--ISNULL(n2.MONTHLYPAYMENTAMT,999) <> iSNULL(round(z.MONTHLYPAYMENTAMT,0),999) OR
	ISNULL(n2.IORPLANCODE,'a') <> iSNULL(z.IORPLANCODE,'a') OR
	ISNULL(n2.NoDaysbeforeAssessment,0) <> ISNULL(z.NoDaysbeforeAssessment,0) OR
	ISNULL(n2.LateChargeRateorFee,0) <> ISNULL(z.LateChargeRateorFee,0) OR
	ISNULL(n2.DefaultOfDaysto,0) <> ISNULL(z.DefaultOfDaysto,0) OR
	ISNULL(n2.Dayslookback,'a') <> isnUlL(z.DeterminationMethodDay,'a') OR
	ISNULL(n2.WF_City,'a') <> isnuLL(z.WF_City,'a') OR
	ISNULL(n2.WF_State,'a') <> iSNULL(z.WF_State,'a') OR
	ISNULL(n2.WF_Companyname,'a') <> ISNULL(z.Companyname,'a') OR
	ISNULL(n2.WF_FirstName,'a') <> ISNULL(z.FirstName,'a') OR
	ISNULL(n2.WF_Lastname,'a') <> ISNULL(z.Lastname,'a') OR
	ISNULL(n2.WF_StreetName,'a') <> ISNULL(z.StreetName,'a') OR
	ISNULL(n2.WF_ZipCodePostal,'a') <> ISNULL(z.ZipCodePostal,'a') OR
	ISNULL(n2.WF_PayeeName,'a') <> isnull(z.PayeeName,'a') OR
	ISNULL(n2.WF_TelephoneNumber1,'a') <> isNULL(z.TelephoneNumber1,'a') OR
	ISNULL(n2.WF_FederalID1 ,'a') <> iSNULL(NULLIF(z.FederalID1,''),'a') OR
	ISNULL(n2.FundedAndOwnedByThirdParty,1) <> iSNULL(z.FundedAndOwnedByThirdParty ,1)
	)
)noteData
where CRE.Note.DealID = noteData.dealid and CRE.Note.crenoteid = noteData.NoteId



--Update CurrentBls fileds (Used in wells stratergy) 
Update cre.note set cre.note.CurrentBls = a.CurrentBls,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
from
(	
	select noteid,note_CurrentBls,CurrentBls
	from(
		Select nnn.noteid,nnn.CurrentBls as note_CurrentBls,ISNULL(nnn.InitialFundingAmount,0) + ISNULL(FF.Amount,0) as CurrentBls --d.credealid,nnn.crenoteid,nnn.InitialFundingAmount,ISNULL(FF.Amount,0) Amount
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
								where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
								and acc.IsDeleted = 0
								--and n.NoteID = nn.noteid  
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
	)b
	where note_CurrentBls <> CurrentBls

)a 
where cre.note.noteid = a.noteid



END