
--[dbo].[usp_UpdateCalculationStatusForDependents_V1] '2401','C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_UpdateCalculationStatusForDependents_V1]
@CRENoteID nvarchar(256),
@AnalysisID uniqueidentifier
 
AS
BEGIN

	Declare @parent_noteid UNIQUEIDENTIFIER;
	Declare @parent_AccountID UNIQUEIDENTIFIER;

	 
	Select @parent_noteid = n.noteid,@parent_AccountID =  n.Account_AccountID
	from cre.note n
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and n.crenoteid = @CRENoteID
	

	--IF EXISTS(select StripTransferTo from CRE.PayruleSetup where StripTransferFrom in (@parent_noteid))
	--BEGIN
	--	DECLARE @PriorityID INT  
	--	SET @PriorityID = (Select top 1 PriorityID FROM Core.CalculationRequests where AnalysisID = @analysisID and CalcType = 775 and NoteId in (@parent_noteid) )
 
	--	Update Core.CalculationRequests SET [StatusID] = 292 ,StartTime = null,Endtime = null , PriorityID = @PriorityID ,requesttime = getdate() ,RequestID = null --,ErrorMessage = 'update request time' 
	--	where  AnalysisID = @AnalysisID  
	--	and noteid in (    
	--		SELECT NoteId FROM CORE.CalculationRequests    
	--		WHERE AnalysisID = @AnalysisID  
	--		and NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom in (@parent_noteid) )  
	--		--and [StatusID] = 326  
	--		and CalcType = 775  
	--		and CalcEngineType  = 798  
	--	)    
	--	and CalcType = 775     
	--	and CalcEngineType  = 798  
	--END


	IF EXISTS(select StripTransferTo from CRE.PayruleSetup where StripTransferFrom in (@parent_noteid))
	BEGIN

		declare @tbl_parent as table (parentnote UNIQUEIDENTIFIER,parentAccountID UNIQUEIDENTIFIER)
		
		INSERT INTO @tbl_parent(parentnote,parentAccountID)
		select StripTransferFrom,Account_AccountID
		from(
			select distinct ps.StripTransferFrom ,n.Account_AccountID
			from CRE.PayruleSetup ps
			Inner Join cre.note n on n.noteid = ps.StripTransferFrom
			where StripTransferTo in (select StripTransferTo from CRE.PayruleSetup where StripTransferFrom in (@parent_noteid))
		)a
		

		DECLARE @PriorityID INT  
		SET @PriorityID = (Select top 1 PriorityID FROM Core.CalculationRequests where AnalysisID = @analysisID and CalcType = 775 and AccountId in (@parent_AccountID) )
 
		IF((Select count(parentnote) from @tbl_parent) = 1)
		BEGIN
			Update Core.CalculationRequests SET [StatusID] = 292 ,StartTime = null,Endtime = null , PriorityID = @PriorityID ,requesttime = getdate(),requestID = null --,ErrorMessage = 'update request time' 
			where  AnalysisID = @AnalysisID  
			and AccountId in (    
				SELECT AccountId FROM CORE.CalculationRequests  cr
				Inner Join cre.note n on n.Account_AccountID = cr.AccountId
				WHERE AnalysisID = @AnalysisID  
				and n.NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom in (@parent_noteid) )  
				--and [StatusID] = 326  
				and CalcType = 775  
				and CalcEngineType  = 798  
			)    
			and CalcType = 775     
			and CalcEngineType  = 798  
		END
		ELSE
		BEGIN
			---Multiple parent
			Declare @is_all_parentcompleted int;
			SET @is_all_parentcompleted = (
				Select count(*) from (
					Select Distinct statusid  from Core.CalculationRequests where  AnalysisID = @AnalysisID  and CalcType = 775  and CalcEngineType  = 798  and AccountId in (Select parentAccountID from @tbl_parent) and statusid = 266 
				)a
			)
			IF(@is_all_parentcompleted = 1)
			BEGIN
				Update Core.CalculationRequests SET [StatusID] = 292 ,StartTime = null,Endtime = null , PriorityID = @PriorityID ,requesttime = getdate(),requestID = null --,ErrorMessage = 'update request time' 
				where  AnalysisID = @AnalysisID  
				and AccountId in (    
					SELECT AccountId FROM CORE.CalculationRequests cr
					Inner Join cre.note n on n.Account_AccountID = cr.AccountId
					WHERE AnalysisID = @AnalysisID  
					and n.NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom in (@parent_noteid) )  
					--and [StatusID] = 326  
					and CalcType = 775  
					and CalcEngineType  = 798  
				)    
				and CalcType = 775     
				and CalcEngineType  = 798  
			END	
				
		END
			
		
	END



END


