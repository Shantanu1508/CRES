CREATE PROCEDURE [DW].[usp_UpdateNoteMatrixFields]
AS
BEGIN
	SET NOCOUNT ON;


---================================================
--Insert New Servicer from Backshop
Declare @tblServicer as table
(
	Servicer nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblServicer (Servicer,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT Distinct Servicer FROM [acore].[vw_AcctNote]'

INSERT INTO cre.Servicer (ServicerName)
Select ce.Servicer as BS_M61_ServicerName --,svr.ServicerName as M61_ServicerName
from @tblServicer ce
left join cre.Servicer svr on svr.ServicerName = ce.Servicer
where ce.Servicer is not null and svr.ServicerName is null

---================================================

---comment for now only
--Insert New FinancingSourceDesc from Backshop
Declare @tblFinancingSourceDesc as table
(
	FinancingSourceDesc nvarchar(256) null,
	InvestorName nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblFinancingSourceDesc (FinancingSourceDesc,InvestorName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT Distinct FinancingSourceDesc,InvestorName FROM [acore].[vw_AcctNote]
UNION 

Select Distinct Custom_FinancingSource as FinancingSourceDesc,null as InvestorName
From(
	Select ControlId_F,NoteId,FinancingSource,OriginalLender_OrgId_F,org.OrganizationName,(fs.FinancingSourceDesc +'' - ''+org.OrganizationName) as Custom_FinancingSource
	from viewNote n
	left join dbo.tblOrganization org on org.OrganizationId = n.OriginalLender_OrgId_F
	left join tblzcdFinancingSource fs on fs.FinancingSourceCD = n.FinancingSource
	where FinancingSource = ''NOTE_SALE'' and OriginalLender_OrgId_F is  not null
)a
'

INSERT INTO [CRE].[FinancingSourceMaster]([FinancingSourceName],[FinancingSourceCode],[ParentClient])
Select ce.FinancingSourceDesc as BS_M61_FinancingSourceDescName,ce.FinancingSourceDesc as BS_M61_FinancingSourceCode,ce.InvestorName 
from @tblFinancingSourceDesc ce
left join cre.FinancingSourceMaster svr on svr.FinancingSourceName = ce.FinancingSourceDesc
where ce.FinancingSourceDesc is not null and svr.FinancingSourceName is null




---====Insert Fund from Backshop======================================
Declare @Fund as table
(
	FundName nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @Fund (FundName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT Distinct Fund FROM [acore].[vw_AcctNote] where Fund is not null'
INSERT INTO CRE.Fund(FundName)
Select dtbs.FundName
from @Fund dtbs
left join CRE.Fund dt on dt.FundName = dtbs.FundName
where dtbs.FundName is not null and dt.FundName is null
---====================================================================

---====Insert Client from Backshop======================================
Declare @Client as table
(
	ClientName nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @Client (ClientName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT Distinct InvestorName FROM [acore].[vw_AcctNote]'

INSERT INTO CRE.Client(ClientName,Status,ClientAbbr)
Select dtbs.ClientName,1 as [Status],dtbs.ClientName
from @Client dtbs
left join CRE.Client dt on dt.ClientName = dtbs.ClientName
where dtbs.ClientName is not null and dt.ClientName is null
---====================================================================


--For now commented
--UpdateNoteFields from BS
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
@stmt = N'
SELECT Distinct AN.Noteid,ControlID,FinancingSourceDesc,InvestorName as ClientName,Servicer,Fund
FROM [acore].[vw_AcctNote] AN
INNER JOIN tblExitPlan EP
ON AN.NoteID = EP.NoteID_F
where FinancingSourceDesc <> ''Note Sale'' ' 

Update CRE.Note Set 
--CRE.Note.ClientID  = a.ClientID,
CRE.Note.FinancingSourceID  = a.FinancingSourceDescID,
CRE.Note.FundId  = a.FundId,
CRE.Note.ServicerNameID  = a.ServicerID,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
from(

	--Select d.dealid,Noteid,FinancingSourceDesc,un.ClientName ,fs.FinancingSourceMasterID as FinancingSourceDescID,lClientName.ClientID
	--,un.Fund as FundName,f.FundID,
	--un.Servicer ,svr.ServicerID
	--from @tblNoteFields un
	--left join [CRE].[FinancingSourceMaster] fs on fs.FinancingSourceName = un.FinancingSourceDesc
	--left join CRE.CLient  lClientName on lClientName.ClientName = un.ClientName 
	--left join CRE.Deal d on d.CREDEalID = un.ControlID
	--left join cre.fund f on f.fundName = un.Fund
	--left join cre.Servicer svr on svr.ServicerName = un.Servicer

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
Declare @tblNoteFields_NS as table
(	 
	Noteid nvarchar(256) null,
	FinancingSourceDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteFields_NS (Noteid,FinancingSourceDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
Select Distinct NoteId,Custom_FinancingSource
From(
	Select ControlId_F,NoteId,FinancingSource,OriginalLender_OrgId_F,org.OrganizationName,(fs.FinancingSourceDesc +'' - ''+org.OrganizationName) as Custom_FinancingSource
	from viewNote n
	left join dbo.tblOrganization org on org.OrganizationId = n.OriginalLender_OrgId_F
	left join tblzcdFinancingSource fs on fs.FinancingSourceCD = n.FinancingSource
	where FinancingSource = ''NOTE_SALE'' and OriginalLender_OrgId_F is  not null
)a'


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


--Update ClientID in Entity
Declare @tblClientIDinEntity as table
(
	TrancheName nvarchar(256) null,
	InvestorName nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblClientIDinEntity (TrancheName,InvestorName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
SELECT Distinct TrancheName,InvestorName
FROM [acore].[vw_AcctNote] AN
       INNER JOIN tblExitPlan EP
              ON AN.NoteID = EP.NoteID_F'


Update CRE.Entity Set CRE.Entity.ClientID  = b.ClientID
from(
Select TrancheName,InvestorName,lClientName.ClientID 
from @tblClientIDinEntity ce
left join CRE.CLient  lClientName on lClientName.ClientName = ce.InvestorName 
)b
where b.TrancheName = CRE.Entity.EntityName 

---========================================================================
--Insert NoteEntityAlloc
Declare @tblNoteEntityAlloc as table
(
	ControlID nvarchar(256) null,
	Noteid nvarchar(256) null,
	TrancheName nvarchar(256) null,
	PercentofNote decimal(28,15)	null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteEntityAlloc (Noteid,ControlID,TrancheName,PercentofNote,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
SELECT Distinct AN.Noteid,ControlID,TrancheName,PercentofNote
FROM [acore].[vw_AcctNote] AN
       INNER JOIN tblExitPlan EP
              ON AN.NoteID = EP.NoteID_F'



truncate table [CRE].[NoteEntityAllocation]

INSERT INTO [CRE].[NoteEntityAllocation]([EntityID],[NoteID],[PctAllocation])
Select ent.EntityID,n.Noteid,PercentofNote
from @tblNoteEntityAlloc nea
left join CRE.Entity  ent on ent.EntityName = nea.TrancheName
left join cre.note n on n.crenoteid = nea.noteid

--=============================


--Update ServicerLoanNumber in note
Declare @tmp_tblNoteExp as table
(
	noteid_F nvarchar(256) null,
	ServicerLoanNumber nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tmp_tblNoteExp (noteid_F,ServicerLoanNumber,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select CAST(noteid_F as varchar(256)) noteid_F,ServicerLoanNumber from tblNoteExp where ServicerLoanNumber is not null'

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


update CRE.Note set TaxVendorLoanNumber = 'NA' Where TaxVendorLoanNumber is null

--=============================
--Update LienPosition,Priority
Declare @tblNoteFieldsMain as table
(
	ControlID nvarchar(256) null,
	Noteid nvarchar(256) null,
	LienPosition nvarchar(256) null,
	[Priority] int null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteFieldsMain (ControlID,Noteid,LienPosition,Priority,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT ControlID_F,noteid,LLienPositionCd_F.LienPositionDesc as LienPosition,Priority 
FROM tblNote n
left join tblzCdLienPosition LLienPositionCd_F on LLienPositionCd_F.LienPositionCd = n.LienPositionCd_F'


Update CRE.Note set 
CRE.Note.lienposition = a.lienpositionID,
CRE.Note.Priority = a.Priority,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	SELECT ControlID,un.noteid,
	un.LienPosition,
	un.Priority,
	l.LookupID as lienpositionID,
	n.Priority as note_Priority,
	n.lienposition as note_lienposition

	FROM @tblNoteFieldsMain un
	Inner join cre.note n on n.crenoteid = un.noteid
	inner join core.Account acc on acc.accountid = n.account_accountid
	left join(
		Select lookupid,[name] from core.lookup where  parentid = 56
	)l on l.Name = un.lienposition
	where acc.isdeleted <> 1
	and (iSNULL(l.LookupID,9999) <> iSNULL(n.lienposition,9999) or iSNULL(un.Priority,9999) <> iSNULL(n.Priority,9999) )
)a
WHERE CRE.Note.crenoteid = CAST(a.noteid as varchar(256))
--=============================


--=============================
--Update Note Delphi Percentage
Declare @tblNoteDelphiPercentage as table
(
	NoteId_F nvarchar(256) null,
	SoldDate	Date null,
	TrancheName	 nvarchar(256) null,
	PercentofNote decimal(28,15) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblNoteDelphiPercentage (NoteId_F,SoldDate,TrancheName,PercentofNote,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'SELECT NoteId_F,SoldDate,TrancheName,PercentofNote
FROM [acore].[vw_AcctNoteExitPlan] n'


Update CRE.Note set 
CRE.Note.RSLIC = a.RSLIC,
CRE.Note.SNCC = a.SNCC,
CRE.Note.PIIC = a.PIIC,
CRE.Note.TMR = a.TMR,
CRE.Note.HCC = a.HCC,
CRE.Note.USSIC = a.USSIC,
CRE.Note.TMNF = a.TMNF,
CRE.Note.HAIH = a.HAIH,
CRE.Note.TotalParticipation = a.TotalParticipation,
CRE.Note.updatedBy = User_Name(),
CRE.Note.updatedDate = getdate()
From(
	SELECT NoteId_F 
	,pivot_table.RSLIC
	,pivot_table.SNCC
	,pivot_table.PIIC
	,pivot_table.TMR
	,pivot_table.HCC
	,pivot_table.USSIC
	,pivot_table.TMNF
	,pivot_table.HAIH
	,(ISNULL(pivot_table.RSLIC,0)+ISNULL(pivot_table.SNCC,0)+ISNULL(pivot_table.PIIC,0)+ISNULL(pivot_table.TMR,0)+ISNULL(pivot_table.HCC,0)+ISNULL(pivot_table.USSIC,0)+ISNULL(pivot_table.TMNF,0)+ISNULL(pivot_table.HAIH,0)) TotalParticipation
	FROM   
	(
		Select NoteId_F,TrancheName,PercentofNote  from @tblNoteDelphiPercentage
	) t 
	PIVOT(
		SUM(PercentofNote) 
		FOR TrancheName IN (RSLIC,SNCC,PIIC,TMR,HCC,USSIC,TMNF,HAIH)
	) AS pivot_table
	inner join cre.note n on n.crenoteid = pivot_table.noteid_f

	Where (
	iSNULL(pivot_table.RSLIC,0) <> iSNULL(n.RSLIC,0) OR
	iSNULL(pivot_table.SNCC,0) <> iSNULL(n.SNCC,0) OR
	iSNULL(pivot_table.PIIC,0) <> iSNULL(n.PIIC,0) OR
	iSNULL(pivot_table.TMR,0) <> iSNULL(n.TMR,0) OR
	iSNULL(pivot_table.HCC,0) <> iSNULL(n.HCC,0) OR
	iSNULL(pivot_table.USSIC,0) <> iSNULL(n.USSIC,0) OR
	iSNULL(pivot_table.TMNF,0) <> iSNULL(n.TMNF,0) OR
	iSNULL(pivot_table.HAIH,0) <> iSNULL(n.HAIH,0) 
	)

)a
WHERE CRE.Note.crenoteid = CAST(a.NoteId_F as varchar(256))
------------------------------------------------------------

Truncate table CRE.NoteTranchePercentage 
INSERT INTO CRE.NoteTranchePercentage (CRENoteID,SoldDate,TrancheName,PercentofNote)
Select NoteId_F,SoldDate,TrancheName,PercentofNote from @tblNoteDelphiPercentage



---================================================
--Insert DealType from Backshop
Declare @DealTypeMaster as table
(
	DealTypeCode nvarchar(256) null,
	DealTypeName nvarchar(256) null,
	SortOrder int null,
	ShardName nvarchar(256) null
)

INSERT INTO @DealTypeMaster (DealTypeCode,DealTypeName,SortOrder,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select CollateralStatusCD,CollateralStatusDesc,OrderKey from acore.tblzCdCollateralStatus'

INSERT INTO CRE.DealTypeMaster(DealTypeCode,DealTypeName,SortOrder,[Status])
Select dtbs.DealTypeCode,dtbs.DealTypeName,dtbs.SortOrder,1 as [Status]
from @DealTypeMaster dtbs
left join CRE.DealTypeMaster dt on dt.DealTypeCode = dtbs.DealTypeCode
where dtbs.DealTypeCode is not null and dt.DealTypeCode is null

---------------------------------

Declare @DealTypeMaster1 as table
(
	DealTypeCode nvarchar(256) null,
	DealTypeName nvarchar(256) null,
	SortOrder int null,
	ShardName nvarchar(256) null
)

INSERT INTO @DealTypeMaster1 (DealTypeCode,DealTypeName,SortOrder,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select CollateralStatusCD,
CollateralStatusDesc = (case when CollateralStatusDesc=''Heavy Rehab'' then ''Heavy Renovation'' 
when CollateralStatusDesc=''Moderate Rehab'' then ''Moderate Renovation'' 
else CollateralStatusDesc end)
,OrderKey from acore.tblzCdCollateralStatus'


Update cre.DealTypeMaster set cre.DealTypeMaster.DealTypeName = a.DealTypeName
From(
	Select dtbs.DealTypeCode,dtbs.DealTypeName,dtbs.SortOrder,1 as [Status]
	from @DealTypeMaster1 dtbs
)a
where cre.DealTypeMaster.DealTypeCode = a.DealTypeCode
---------------------------------

---==============Import DealType, Property Type from Backshop==================================
Declare @BSDeal as table
(
	ControlID nvarchar(256) null,
	CollateralStatusDesc nvarchar(256) null,	
	PropertyTypeMajorDesc nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDeal (ControlID,CollateralStatusDesc,PropertyTypeMajorDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select ControlID,dt.CollateralStatusDesc ,ptm.PropertyTypeMajorDesc
from tblControlMaster cm
left join acore.tblzCdCollateralStatus dt on dt.CollateralStatusCD = cm.CollateralStatusCd_F
left join tblzCdPropertyTypeMajor ptm on ptm.PropertyTypeMajorCd = cm.REITPropertyTypeCd_F '


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

---for now commented
---Update FinancingSourceCode from Backshop
Declare @BSFinancingSource as table
(
	FinancingSourceCD nvarchar(256) null,
	FinancingSourceDesc nvarchar(256) null,	
	ShardName nvarchar(256) null
)
INSERT INTO @BSFinancingSource (FinancingSourceCD,FinancingSourceDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select FinancingSourceCD,FinancingSourceDesc from tblzcdFinancingSource'

Update cre.financingsourcemaster set FinancingSourceCode = null

Update cre.financingsourcemaster set cre.financingsourcemaster.FinancingSourceCode = a.FinancingSourceCD
From(
	Select FinancingSourceCD,FinancingSourceDesc from @BSFinancingSource
)a
where cre.financingsourcemaster.FinancingSourceName =  a.FinancingSourceDesc

Update cre.financingsourcemaster set FinancingSourceCode = FinancingSourceName where FinancingSourceCode is null

Update cre.FinancingSourceMaster set ParentClient = FinancingSourceName where ParentClient is null

Update cre.FinancingSourceMaster set FinancingSourceGroup = FinancingSourceName where FinancingSourceGroup is null

Update cre.FinancingSourceMaster set IsThirdParty = 1 where FinancingSourceName like 'Note Sale - %'




---================================================
--Update Inquiry date from bckshop
Declare @tblInquiryDate as table
(
	ControlId_F nvarchar(256) null,
	InquiryDateFirst datetime null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblInquiryDate (ControlId_F,InquiryDateFirst,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select ControlId_F,InquiryDateFirst from acore.vw_LoanStatusFirstAndLastFlattened'

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


Declare @tblDealType as table
(
	ControlId nvarchar(256) null,
	StatusDate date null,
	CollateralStatusDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblDealType (ControlId,StatusDate,CollateralStatusDesc,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select a.ControlId, a.StatusDate, a.CollateralStatusDesc
From(
	select cm.ControlId, dh.StatusDate, colstat.CollateralStatusDesc ,ROW_NUMBER() Over (Partition by cm.ControlId order by cm.ControlId,dh.StatusDate) RowNo
	from acore.tblDealHistory dh
	join tblControlMaster cm on dh.ControlId_F = cm.ControlId
	join acore.tblzCdCollateralStatus colstat on dh.ColumnValue = colstat.CollateralStatusCD
	where ColumnName = ''collateralstatuscd_f''	
	and cast(dh.StatusDate as date) <= ''8/31/2021''
)a
where a.RowNo = 1
--and cm.ControlId = ''17-0851''
order by a.ControlId'


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



Declare @tblDealType_latest as table
(
	ControlId nvarchar(256) null,
	StatusDate date null,
	CollateralStatusDesc nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tblDealType_latest (ControlId,StatusDate,CollateralStatusDesc,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select a.ControlId, a.StatusDate, a.CollateralStatusDesc
From(
	select cm.ControlId, dh.StatusDate, colstat.CollateralStatusDesc ,ROW_NUMBER() Over (Partition by cm.ControlId order by cm.ControlId,dh.StatusDate desc) RowNo
	from acore.tblDealHistory dh
	join tblControlMaster cm on dh.ControlId_F = cm.ControlId
	join acore.tblzCdCollateralStatus colstat on dh.ColumnValue = colstat.CollateralStatusCD
	where ColumnName = ''collateralstatuscd_f''	
	and cast(dh.StatusDate as date) <= ''8/31/2021''
)a
where a.RowNo = 1
order by a.ControlId'


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



---======Update property type from backshop=============
Declare @PropertyTypeMajor as table
(
	PropertyTypeMajorCd nvarchar(256) null,
	PropertyTypeMajorDesc nvarchar(256) null,
	OrderKey int null,
	ShardName nvarchar(256) null
)

INSERT INTO @PropertyTypeMajor (PropertyTypeMajorCd,PropertyTypeMajorDesc,OrderKey,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select  PropertyTypeMajorCd,PropertyTypeMajorDesc,OrderKey from tblzCdPropertyTypeMajor'

INSERT INTO [CRE].[PropertyTypeMajor](PropertyTypeMajorCd,PropertyTypeMajorDesc,OrderKey,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
Select dtbs.PropertyTypeMajorCd,dtbs.PropertyTypeMajorDesc,dtbs.OrderKey,1 as IsActive,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate()
from @PropertyTypeMajor dtbs
left join CRE.[PropertyTypeMajor] dt on dt.PropertyTypeMajorCd = dtbs.PropertyTypeMajorCd
where dtbs.PropertyTypeMajorCd is not null and dt.PropertyTypeMajorCd is null


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
@stmt = N'Select ControlId_F,PropertyTypeMajorCd_F,PropertyTypeMajorDesc,City,State,MSA_NAME
From(
	Select ControlId_F,p.PropertyTypeMajorCd_F,l.PropertyTypeMajorDesc,p.DealAllocationAmt,p.City,p.State ,z.MSA_NAME,
	ROW_NUMBER() Over(Partition by ControlId_F order by ControlId_F,DealAllocationAmt desc) as rno
	from dbo.[tblProperty] p
	left join dbo.[tblzCdPropertyTypeMajor] l on l.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F
	left join dbo.[tblzCDZipCode] z on z.ZIP_CODE = p.ZipCode
	left join tblPropertyExp px on px.PropertyId_F = p.PropertyId	
	Where px.PropertyRollupTypeId_F = 2
)a where a.rno = 1'


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


--Insert LoanType from Backshop
Declare @LoanTypeMaster as table
(
	LoanStatusCd nvarchar(5)	null,
	LoanStatusDesc	nvarchar(256)	null,
	OrderKey int null,
	ShardName nvarchar(256) null
)

INSERT INTO @LoanTypeMaster (LoanStatusCd,LoanStatusDesc,OrderKey,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select LoanStatusCd,LoanStatusDesc,OrderKey from [dbo].[tblzCdLoanStatus]'

INSERT INTO CRE.LoanStatus(LoanStatusCd,LoanStatusDesc,OrderKey)
Select dtbs.LoanStatusCd,dtbs.LoanStatusDesc,dtbs.OrderKey
from @LoanTypeMaster dtbs
left join CRE.LoanStatus dt on dt.LoanStatusCd = dtbs.LoanStatusCd
where dtbs.LoanStatusCd is not null and dt.LoanStatusCd is null


Declare @BSDealLoanStatus as table
(
	ControlID nvarchar(256) null,
	LoanStatusCd_F nvarchar(5) null,	
	LoanStatusDesc nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDealLoanStatus (ControlID,LoanStatusCd_F,LoanStatusDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select cm.ControlId,cm.LoanStatusCd_F,ls.LoanStatusDesc 
from tblControlMaster cm
Left Join [dbo].[tblzCdLoanStatus] ls on ls.LoanStatusCd = cm.LoanStatusCd_F '


Update CRE.Deal 
set CRE.Deal.LoanStatusID = a.LoanStatusID
,CRE.Deal.updatedBy = User_Name()
,CRE.Deal.updatedDate = getdate()
From(

	Select bsd.ControlID,bsd.LoanStatusCd_F,ls.LoanStatusID
	from @BSDealLoanStatus bsd
	left join cre.LoanStatus ls on ls.LoanStatusCd = bsd.LoanStatusCd_F
	Inner join cre.deal d on d.credealid = bsd.ControlID
	where d.isdeleted <> 1
	and ISNULL(d.LoanStatusID,999) <> isNULL(ls.LoanStatusID,999)

)a
Where CRE.Deal.Credealid = a.ControlID

---==================================================

----for now commented
update cre.FinancingSourceMaster set ParentClient='ACP II' where FinancingSourceName like 'ACP II%' and FinancingSourceName not in ('ACP II Co-Invest')


---done from above script
--Update CRE.DEAL set BSCity = z.city,BSState = z.[state]
--From(
-- 	Select controlid,b.borrowerid,b.city,b.state
--	from(
--		Select controlid,borrowerid,ROW_NUMBER() over (PARTITION BY controlid ORDER BY borrowerid desc) as number
--		from(
--			Select cm.controlid,borrowerid,NoteId_F
--			from(
--				SELECT NoteId_F, Ranked.BorrowerId,Ranked.LastNameOrOrgName , Ranked.BorrowerOwnershipHierarchyId
--				FROM ( 
--					SELECT B.LastNameOrOrgName
--					, B.BorrowerId
--					, BOH.BorrowerOwnershipHierarchyId
--					, RANK() OVER (PARTITION BY NoteId_F ORDER BY ParentBorrowerId_F ASC) AS BorrowerRank,
--					NoteId_F
--					FROM tblBorrowerOwnershipHierarchy BOH
--					INNER JOIN tblBorrower B
--					ON B.BorrowerId = BOH.ParentBorrowerId_F
--					WHERE ChildBorrowerId_F IS NULL
				
--				) Ranked
--				WHERE Ranked.BorrowerRank = 1
--			)a
--			left join tblnote n on n.noteid = a.NoteId_F 
--			inner join tblcontrolmaster cm on cm.controlid = n.controlid_f		
--			---where cm.controlid = '17-0010'
--		)b
--		group by controlid,borrowerid
--	)c
--	left join tblborrower b on b.borrowerid = c.borrowerid  
--	where c.number = 1
--)z
--where CRE.DEAL.CREDealID = z.ControlId





--Update ServicerLoanNumber in note
Declare @tmp_tblNoteExp_ServicingStatus as table
(
	noteid_F nvarchar(256) null,
	ServicingStatusCd_F nvarchar(256) null,
	ShardName nvarchar(256) null
)

INSERT INTO @tmp_tblNoteExp_ServicingStatus (noteid_F,ServicingStatusCd_F,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select CAST(noteid_F as varchar(256)) noteid_F,ServicingStatusCd_F from tblNoteExp'


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
Declare @BSDeal_Banker as table
(
	ControlID nvarchar(256) null,
	PrimaryBankerName nvarchar(256) null,	
	ShardName nvarchar(256) null
)

INSERT INTO @BSDeal_Banker (ControlID,PrimaryBankerName,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select controlid,cnt.FirstName +'' ''+ LastName as PrimaryBankerName
from tblcontrolmaster cm
Left join ACORE.RPTCONTACT cnt on cnt.UserId_F = cm.PrimaryBanker_UserId_F '


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

