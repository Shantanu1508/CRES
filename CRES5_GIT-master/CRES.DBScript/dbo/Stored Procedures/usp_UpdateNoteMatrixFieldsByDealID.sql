CREATE PROCEDURE [dbo].[usp_UpdateNoteMatrixFieldsByDealID]
	@CREDealID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

--For now commented
--UpdateNoteFields from BS

Declare @q1 nvarchar(max) = N'
SELECT Distinct AN.Noteid,ControlID,FinancingSourceDesc,InvestorName as ClientName,Servicer,Fund
FROM [acore].[vw_AcctNote] AN
INNER JOIN tblExitPlan EP
ON AN.NoteID = EP.NoteID_F
where FinancingSourceDesc <> ''Note Sale'' and ControlID = '''+ @CREDealID +''' ' 

Declare @tblNoteFields as table
(
	ControlID nvarchar(256) null,
	Noteid nvarchar(256) null,
	FinancingSourceDesc nvarchar(256) null,
	ClientName nvarchar(256) null,
	Servicer nvarchar(256) null,
	Fund nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteFields (Noteid,ControlID,FinancingSourceDesc,ClientName,Servicer,Fund,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q1

Update CRE.Note Set 
CRE.Note.ClientID  = a.ClientID,
CRE.Note.FinancingSourceID  = a.FinancingSourceDescID,
CRE.Note.FundId  = a.FundId,
CRE.Note.ServicerNameID  = a.ServicerID,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
from(
	Select d.dealid,un.Noteid,FinancingSourceDesc,un.ClientName,un.Fund as FundName,un.Servicer 
	,fs.FinancingSourceMasterID as FinancingSourceDescID
	,lClientName.ClientID
	,f.FundID
	,svr.ServicerID

	,n.FinancingSourceID as note_FinancingSourceID 
	,n.ClientID  as note_ClientID
	,n.FundID  as note_FundID
	,n.ServicerNameID  as note_ServicerNameID

	from @tblNoteFields un
	left join [CRE].[FinancingSourceMaster] fs on fs.FinancingSourceName = un.FinancingSourceDesc
	left join CRE.CLient  lClientName on lClientName.ClientName = un.ClientName 
	left join CRE.Deal d on d.CREDEalID = un.ControlID
	left join cre.fund f on f.fundName = un.Fund
	left join cre.Servicer svr on svr.ServicerName = un.Servicer
	Inner join cre.note n on n.crenoteid = un.Noteid
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and (iSNULL(fs.FinancingSourceMasterID,9999) <> iSNULL(n.FinancingSourceID,9999) OR iSNULL(lClientName.ClientID,999) <> iSNULL(n.ClientID,999) OR iSNULL(f.FundID,9999) <> iSNULL(n.FundID,9999) OR iSNULL(svr.ServicerID,9999) <> iSNULL(n.ServicerNameID,9999) )
)a
where CRE.Note.CRENoteID = a.Noteid and CRE.Note.dealid = a.dealid 
------------------------------------------------------------------

---for now commented
----Update note sale with original lender

Declare @q2 nvarchar(max) = N'
Select Distinct NoteId,Custom_FinancingSource
From(
	Select ControlId_F,NoteId,FinancingSource,OriginalLender_OrgId_F,org.OrganizationName,(fs.FinancingSourceDesc +'' - ''+org.OrganizationName) as Custom_FinancingSource
	from viewNote n
	left join dbo.tblOrganization org on org.OrganizationId = n.OriginalLender_OrgId_F
	left join tblzcdFinancingSource fs on fs.FinancingSourceCD = n.FinancingSource
	where FinancingSource = ''NOTE_SALE'' and OriginalLender_OrgId_F is  not null
	and ControlId_F = '''+ @CREDealID +''' 
)a'


Declare @tblNoteFields_NS as table
(	 
	Noteid nvarchar(256) null,
	FinancingSourceDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteFields_NS (Noteid,FinancingSourceDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q2


Update CRE.Note Set 
CRE.Note.FinancingSourceID  = a.FinancingSourceDescID,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
from(	 
	Select un.Noteid,FinancingSourceDesc,fs.FinancingSourceMasterID as FinancingSourceDescID,n.FinancingSourceID as note_FinancingSourceID 
	from @tblNoteFields_NS un
	left join [CRE].[FinancingSourceMaster] fs on fs.FinancingSourceName = un.FinancingSourceDesc	
	Inner join cre.note n on n.crenoteid = un.Noteid
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and iSNULL(fs.FinancingSourceMasterID,9999) <> iSNULL(n.FinancingSourceID,9999)
)a
where CRE.Note.CRENoteID = a.Noteid 
---========================================================================

--Update ServicerLoanNumber in note

Declare @q3 nvarchar(max) = N'Select CAST(nx.noteid_F as varchar(256)) noteid_F,nx.ServicerLoanNumber from tblNoteExp nx
Inner join tblnote n on n.noteid = nx.noteid_f
where ServicerLoanNumber is not null and n.ControlID_f = '''+ @CREDealID +''' ' 

Declare @tmp_tblNoteExp as table
(
	noteid_F nvarchar(256) null,
	ServicerLoanNumber nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tmp_tblNoteExp (noteid_F,ServicerLoanNumber,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q3

Update CRE.Note set 
CRE.Note.TaxVendorLoanNumber = a.ServicerLoanNumber,
CRE.Note.ServicerID = a.ServicerLoanNumber,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	Select CAST(noteid_F as varchar(256)) noteid_F,ServicerLoanNumber ,n.TaxVendorLoanNumber as note_ServicerID
	from @tmp_tblNoteExp un
	Inner join cre.note n on n.crenoteid = un.noteid_F
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and ISNULL(ServicerLoanNumber,'a') <> ISNULL(n.TaxVendorLoanNumber,'a')
)a
WHERE CRE.Note.crenoteid = CAST(a.noteid_F as varchar(256))



---==============Import DealType, Property Type from Backshop==================================
Declare @q4 nvarchar(max) = N'Select ControlID,dt.CollateralStatusDesc ,ptm.PropertyTypeMajorDesc
from tblControlMaster cm
left join acore.tblzCdCollateralStatus dt on dt.CollateralStatusCD = cm.CollateralStatusCd_F
left join tblzCdPropertyTypeMajor ptm on ptm.PropertyTypeMajorCd = cm.REITPropertyTypeCd_F 
Where ControlId = '''+ @CREDealID +''' '

Declare @BSDeal as table
(
	ControlID nvarchar(256) null,
	CollateralStatusDesc nvarchar(256) null,	
	PropertyTypeMajorDesc nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDeal (ControlID,CollateralStatusDesc,PropertyTypeMajorDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q4

Update CRE.Deal set 
CRE.Deal.DealTypeMasterID = a.DealTypeMasterID
,CRE.Deal.PropertyTypeBS = a.PropertyTypeMajorDesc
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(

	Select ControlID,DealTypeMasterID,PropertyTypeMajorDesc
	From(
		Select bsd.ControlID,bsd.CollateralStatusDesc,dtm.DealTypeMasterID 
		,(case when bsd.PropertyTypeMajorDesc='Hotel' then 'Hospitality' when bsd.PropertyTypeMajorDesc='Mixed Use' then 'Retail' else bsd.PropertyTypeMajorDesc end) as PropertyTypeMajorDesc
		,d.DealTypeMasterID as deal_DealTypeMasterID
		,d.PropertyTypeBS as deal_PropertyTypeBS
		from @BSDeal bsd
		left join cre.DealTypeMaster dtm on dtm.DealTypeName = Replace(Replace(CollateralStatusDesc,'Heavy Rehab', 'Heavy Renovation'),'Moderate Rehab','Moderate Renovation')
		Inner join cre.deal d on d.credealid = bsd.ControlID
		where d.isdeleted <> 1
	)b
	where (isNULL(b.DealTypeMasterID,999) <> ISNULL(b.deal_DealTypeMasterID,999) OR ISNULL(b.PropertyTypeMajorDesc,'a') <> ISNULL(b.deal_PropertyTypeBS,'a'))

)a
Where CRE.Deal.Credealid = a.ControlID

---================================================
--Update Inquiry date from bckshop

Declare @q5 nvarchar(max) = N'Select ControlId_F,InquiryDateFirst from acore.vw_LoanStatusFirstAndLastFlattened where  ControlId_F = '''+ @CREDealID +''' '

Declare @tblInquiryDate as table
(
	ControlId_F nvarchar(256) null,
	InquiryDateFirst datetime null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblInquiryDate (ControlId_F,InquiryDateFirst,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q5

Update cre.deal 
set cre.deal.InquiryDate = a.InquiryDateFirst
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(
	Select ControlId_F,InquiryDateFirst 
	from @tblInquiryDate t
	inner join cre.deal d on d.credealid = t.ControlId_F
	Where ISNULL(d.InquiryDate,'1/1/1900') <> t.InquiryDateFirst
)a
where cre.deal.credealid = a.ControlId_F

---================================================

Declare @q6 nvarchar(max) = N'Select a.ControlId, a.StatusDate, a.CollateralStatusDesc
From(
	select cm.ControlId, dh.StatusDate, colstat.CollateralStatusDesc ,ROW_NUMBER() Over (Partition by cm.ControlId order by cm.ControlId,dh.StatusDate) RowNo
	from acore.tblDealHistory dh
	join tblControlMaster cm on dh.ControlId_F = cm.ControlId
	join acore.tblzCdCollateralStatus colstat on dh.ColumnValue = colstat.CollateralStatusCD
	where ColumnName = ''collateralstatuscd_f''	
	and cast(dh.StatusDate as date) <= ''8/31/2021''
	and cm.ControlId = '''+ @CREDealID +''' 
)a
where a.RowNo = 1
order by a.ControlId'

Declare @tblDealType as table
(
	ControlId nvarchar(256) null,
	StatusDate date null,
	CollateralStatusDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblDealType (ControlId,StatusDate,CollateralStatusDesc,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q6


Update cre.deal 
set cre.deal.BS_CollateralStatusDesc = a.CollateralStatusDesc
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(
	Select dt.ControlId,dt.StatusDate,dt.CollateralStatusDesc 
	from @tblDealType dt
	inner join cre.deal d on d.credealid = dt.ControlId
	Where isNULL(d.BS_CollateralStatusDesc,'a') <> isNULL(dt.CollateralStatusDesc ,'a')
)a
where cre.deal.credealid = a.ControlId
---================================================



Declare @q7 nvarchar(max) = N'Select a.ControlId, a.StatusDate, a.CollateralStatusDesc
From(
	select cm.ControlId, dh.StatusDate, colstat.CollateralStatusDesc ,ROW_NUMBER() Over (Partition by cm.ControlId order by cm.ControlId,dh.StatusDate desc) RowNo
	from acore.tblDealHistory dh
	join tblControlMaster cm on dh.ControlId_F = cm.ControlId
	join acore.tblzCdCollateralStatus colstat on dh.ColumnValue = colstat.CollateralStatusCD
	where ColumnName = ''collateralstatuscd_f''	
	and cast(dh.StatusDate as date) <= ''8/31/2021''
	and cm.ControlId = '''+ @CREDealID +''' 
)a
where a.RowNo = 1
order by a.ControlId'

Declare @tblDealType_latest as table
(
	ControlId nvarchar(256) null,
	StatusDate date null,
	CollateralStatusDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblDealType_latest (ControlId,StatusDate,CollateralStatusDesc,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q7


Update cre.deal 
set cre.deal.BS_CollateralStatusDesclatest = a.CollateralStatusDesc
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(
	Select dt.ControlId,dt.StatusDate,dt.CollateralStatusDesc 
	from @tblDealType_latest dt
	inner join cre.deal d on d.credealid = dt.ControlId
	Where isNULL(d.BS_CollateralStatusDesclatest,'a') <> isNULL(dt.CollateralStatusDesc ,'a')
)a
where cre.deal.credealid = a.ControlId
---================================================


Declare @q8 nvarchar(max) = N'Select ControlId_F,PropertyTypeMajorCd_F,PropertyTypeMajorDesc,City,State,MSA_NAME
From(
	Select ControlId_F,p.PropertyTypeMajorCd_F,l.PropertyTypeMajorDesc,p.DealAllocationAmt,p.City,p.State ,z.MSA_NAME,
	ROW_NUMBER() Over(Partition by ControlId_F order by ControlId_F,DealAllocationAmt desc) as rno
	from dbo.[tblProperty] p
	left join dbo.[tblzCdPropertyTypeMajor] l on l.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F
	left join dbo.[tblzCDZipCode] z on z.ZIP_CODE = p.ZipCode
	left join tblPropertyExp px on px.PropertyId_F = p.PropertyId	
	Where px.PropertyRollupTypeId_F = 2
	and ControlId_F = '''+ @CREDealID +''' 
)a where a.rno = 1'

Declare @BSDealProperty as table
(
	ControlID nvarchar(256) null,
	PropertyTypeMajorCd nvarchar(50) null,	
	PropertyTypeMajorDesc nvarchar(256) null,	
	City	nvarchar(256) null,	
	[State]	nvarchar(256) null,	
	MSA_NAME nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDealProperty (ControlID,PropertyTypeMajorCd,PropertyTypeMajorDesc,City,[State],MSA_NAME,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q8


Update CRE.Deal set CRE.Deal.PropertyTypeMajorID = a.PropertyTypeMajorID,
CRE.Deal.BSCity = a.City,
CRE.Deal.BSState = a.[State],
CRE.Deal.MSA_NAME = a.MSA_NAME
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(
	Select bsd.ControlID,dtm.PropertyTypeMajorID,bsd.City,bsd.[State],bsd.MSA_NAME
	from @BSDealProperty bsd
	left join cre.[PropertyTypeMajor] dtm on dtm.PropertyTypeMajorCd = bsd.PropertyTypeMajorCd
	Inner join cre.deal d on d.credealid = bsd.ControlID
	where d.isdeleted <> 1

	and (ISNULL(d.PropertyTypeMajorID,999) <> isNULL(dtm.PropertyTypeMajorID,999) OR
	ISNULL(d.BSCity,'a') <> isNULL(bsd.City,'a') OR
	ISNULL(d.BSState,'a') <> isNULL(bsd.[State],'a') OR
	ISNULL(d.MSA_NAME,'a') <> isNULL(bsd.MSA_NAME,'a')
	)
)a
Where CRE.Deal.Credealid = a.ControlID
---=================================================


--Update ServicerLoanNumber in note


Declare @q9 nvarchar(max) = N'Select CAST(nx.noteid_F as varchar(256)) noteid_F,nx.ServicingStatusCd_F from tblNoteExp nx
Inner join tblnote n on n.noteid = nx.noteid_f
where n.ControlID_f = '''+ @CREDealID +''' ' 

Declare @tmp_tblNoteExp_ServicingStatus as table
(
	noteid_F nvarchar(256) null,
	ServicingStatusCd_F nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tmp_tblNoteExp_ServicingStatus (noteid_F,ServicingStatusCd_F,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q9


Update CRE.Note set 
CRE.Note.ServicingStatusBS = a.ServicingStatusCd_F,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	Select CAST(noteid_F as varchar(256)) noteid_F,ServicingStatusCd_F 
	from @tmp_tblNoteExp_ServicingStatus un
	Inner join cre.note n on n.crenoteid = un.noteid_F
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and ISNULL(ServicingStatusCd_F,'a') <> ISNULL(n.ServicingStatusBS,'a')
)a
WHERE CRE.Note.crenoteid = CAST(a.noteid_F as varchar(256))

---==========================================

---Update banker nae from backshop

Declare @q10 nvarchar(max) = N'Select controlid,cnt.FirstName +'' ''+ LastName as PrimaryBankerName
from tblcontrolmaster cm
Left join ACORE.RPTCONTACT cnt on cnt.UserId_F = cm.PrimaryBanker_UserId_F 
Where ControlId = '''+ @CREDealID +''' '

Declare @BSDeal_Banker as table
(
	ControlID nvarchar(256) null,
	PrimaryBankerName nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDeal_Banker (ControlID,PrimaryBankerName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = @q10


Update CRE.Deal 
set CRE.Deal.PrimaryBankerName = a.PrimaryBankerName
From(
	Select bsd.ControlID,bsd.PrimaryBankerName
	from @BSDeal_Banker bsd
	Inner join cre.deal d on d.credealid = bsd.ControlID
	where d.isdeleted <> 1
	and ISNULL(d.PrimaryBankerName,'a') <> isNULL(bsd.PrimaryBankerName,'a')
)a
Where CRE.Deal.Credealid = a.ControlID




END
GO

