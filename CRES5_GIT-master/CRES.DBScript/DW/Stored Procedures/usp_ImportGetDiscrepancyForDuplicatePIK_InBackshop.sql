CREATE PROCEDURE [DW].[usp_ImportGetDiscrepancyForDuplicatePIK_InBackshop]
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Declare @tblBSDuplicatePIK as table
	(
		DealName nvarchar(256) null,
		DealID nvarchar(256) null,
		NoteID nvarchar(256) null,
		FundingPurposeCD nvarchar(256) null,
		[Count] int,
		ShardName nvarchar(256) null
	)
	
	INSERT INTO @tblBSDuplicatePIK (DealName,DealID,NoteID,FundingPurposeCD,[Count],ShardName)
	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
	@stmt = N'Select Distinct cm.dealname as [Deal Name],cm.ControlID as DealID,nf.Noteid_F,nf.FundingPurposeCD_F,count(nf.Noteid_F) cnt
			from tblnotefunding nf
			left join tblnote n on n.noteid = nf.noteid_f
			inner join tblcontrolmaster cm on cm.ControlID =n.controlid_F
			where FundingPurposeCD_F in (''PIKPP'',''PIKNC'') 
			and NoteID_F not in (''9809'',''9810'')
			AND cm.DealName NOT LIKE ''%copy%''
			group by cm.dealname ,cm.ControlID,nf.Noteid_F,nf.FundingDate,nf.FundingPurposeCD_F,CAST(nf.Comments as nvarchar(max))
			having count(nf.Noteid_F)  > 1'

	TRUNCATE TABLE [DW].[tbl_GetDiscrepancyForDuplicatePIK_InBackshop];

	INSERT INTO [DW].[tbl_GetDiscrepancyForDuplicatePIK_InBackshop](
	[Deal Name]		
	,[Deal ID]		
	,[Note ID]		
	,[Funding Purpose]
	,[Count])
	Select 
	DealName as [Deal Name]
	,DealID as [Deal ID]
	,NoteID as [Note ID]
	,FundingPurposeCD as [Funding Purpose]
	,[Count] from @tblBSDuplicatePIK;

	UPDATE [DW].[tbl_GetDiscrepancyForDuplicatePIK_InBackshop] SET [LastUpdatedDate]=GETDATE();
END