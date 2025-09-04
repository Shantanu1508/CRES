--[dbo].[usp_GetDiscrepancyForDuplicatePIK_InBackshop] 


CREATE PROCEDURE [dbo].[usp_QueueNoteForCalc_DiscrepancyForDuplicatePIK_InBackshop] 
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
				and cm.DealName NOT LIKE ''%copy%''
				group by cm.dealname ,cm.ControlID,nf.Noteid_F,nf.FundingDate,nf.FundingPurposeCD_F,CAST(nf.Comments as nvarchar(max))
				having count(nf.Noteid_F)  > 1'


	


	---Queue note for calculation
	declare @TableTypeCR1 TableTypeCalculationRequests  
		
	delete From @TableTypeCR1

	INSERT INTO @TableTypeCR1(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType) 	
	Select Distinct n.noteid,'Processing' as StatusText,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50' as UserName,'Batch' as PriorityText,'C10F3372-0FC2-4861-A9F5-148F1F80804F' as analysisID,775 as CalcType
	from @tblBSDuplicatePIK t
	Inner join cre.note n on n.CRENoteID = t.NoteID

	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCR1,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50','3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50', NULL, NULL, 'DiscrepancyForDuplicatePIK_InBackshop'

	



 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
GO

