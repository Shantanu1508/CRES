--Drop PROCEDURE [dbo].[usp_DeleteFundingSchedule]
CREATE PROCEDURE [dbo].[usp_DeleteFundingSchedule]       
 @notefunding [TableTypeFundingSchedule] READONLY,      
 @UserID nvarchar(256)    
    
AS      
BEGIN
SET NOCOUNT ON; 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

----=======================
--truncate table   dbo.[tblFF]
--insert into  dbo.[tblFF](NoteID,Value,Date,PurposeID,AccountId,Applied,DrawFundingId,Comments,[DealFundingRowno],isDeleted,WF_CurrentStatus)        
--Select nf.NoteID,ISNULL(nf.Value,0) as [Value],nf.Date,nf.PurposeID,n.Account_AccountID as AccountId,nf.Applied,nf.DrawFundingId,nf.Comments,nf.[DealFundingRowno],ISNULL(nf.isDeleted,0) as isDeleted,nf.WF_CurrentStatus 
--from @notefunding nf    
--Inner join cre.note n on n.NoteID = nf.NoteID    
--where nf.[Date] is not null  
----=======================

IF EXISTS(Select Distinct NoteID from @notefunding where [value] <> 0) 
BEGIN

	Declare @DealID UNIQUEIDENTIFIER;
	SET @DealID = (Select top 1 n.dealid from @notefunding nf inner join cre.note n on n.noteid = nf.noteid)


	IF OBJECT_ID('tempdb..#tblDealData') IS NOT NULL                   
	DROP TABLE #tblDealData           
                  
	create table #tblDealData             
	(         
		dealid UNIQUEIDENTIFIER NULL,
		credealid nvarchar(256) NULL,
		UseRuleToDetermineNoteFunding int NULL
	)
	INSERT INTO #tblDealData(dealid,credealid,UseRuleToDetermineNoteFunding)
	Select Distinct d.dealid,d.credealid,ISNULL(n.UseRuleToDetermineNoteFunding,4) as UseRuleToDetermineNoteFunding
	from cre.deal d 
	inner join cre.note n on n.dealid = d.dealid
	inner join core.Account acc on acc.accountid = n.account_accountid
	Left Join core.lookup l on l.lookupid = d.status
	where d.isDeleted <> 1 and acc.isdeleted <> 1
	and l.name in ('Active','Phantom')
	and d.dealid = @DealID


	IF((Select COUNT(UseRuleToDetermineNoteFunding) from #tblDealData) = 1) --Either whole deal is 'Y' or 'N'
	BEGIN
		Declare @L_UseRuleToDetermineNoteFunding int = (Select top 1 UseRuleToDetermineNoteFunding from #tblDealData)

		Declare @CRENoteId Nvarchar(256)
		Declare @AccountId UNIQUEIDENTIFIER
		Declare @NoteId UNIQUEIDENTIFIER

		IF(@L_UseRuleToDetermineNoteFunding = 3) --'Y'
		BEGIN
			PRINT 'Y'
 
			IF CURSOR_STATUS('global','CursorNoteFF')>=-1          
			BEGIN          
			DEALLOCATE CursorNoteFF          
			END          
       
			DECLARE CursorNoteFF CURSOR           
			FOR          
			(          
				Select Distinct n.NoteID,n.crenoteid,n.Account_Accountid
				from cre.note n
				Inner join cre.deal d on d.dealid = n.dealid
				where d.dealid = @DealID and n.noteid not in (Select Distinct noteid from @notefunding)     
			)      
			OPEN CursorNoteFF           
			FETCH NEXT FROM CursorNoteFF          
			INTO @NoteId,@CRENoteId,@AccountId
			WHILE @@FETCH_STATUS = 0          
			BEGIN 
				--INSERT INTO temp_DeleteNoteFF(CRENOteId) values(@CRENoteId)
				EXEC [dbo].[usp_DeleteFundingScheduleFromBackShopAndM61] @NoteId,@UserID

			FETCH NEXT FROM CursorNoteFF          
			INTO @NoteId,@CRENoteId,@AccountId
			END 
		
		END
		ELSE
		BEGIN
			IF(@L_UseRuleToDetermineNoteFunding = 4)  ---'N'
			BEGIN
				PRINT 'N'

				IF CURSOR_STATUS('global','CursorNoteFF')>=-1          
				BEGIN          
				DEALLOCATE CursorNoteFF          
				END          
       
				DECLARE CursorNoteFF CURSOR           
				FOR          
				(          
					Select Distinct n.NoteID,n.crenoteid,n.Account_Accountid
					from cre.note n
					Inner join cre.deal d on d.dealid = n.dealid
					where d.dealid = @DealID and n.noteid not in (Select Distinct NoteID from @notefunding where [value] <> 0) 				    
				)      
				OPEN CursorNoteFF           
				FETCH NEXT FROM CursorNoteFF          
				INTO @NoteId,@CRENoteId,@AccountId
				WHILE @@FETCH_STATUS = 0          
				BEGIN 

					--INSERT INTO temp_DeleteNoteFF(CRENOteId) values(@CRENoteId)
					EXEC [dbo].[usp_DeleteFundingScheduleFromBackShopAndM61] @NoteId,@UserID

				FETCH NEXT FROM CursorNoteFF          
				INTO @NoteId,@CRENoteId,@AccountId
				END 


			END


		END
	END





END





SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END  
