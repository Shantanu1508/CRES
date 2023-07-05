CREATE PROCEDURE [dbo].[usp_DeleteFundingScheduleFromBackShopAndM61]       
 @NoteID UNIQUEIDENTIFIER,      
 @UserID nvarchar(256)    
    
AS      
BEGIN
SET NOCOUNT ON; 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


 IF EXISTS(Select eventid from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = 10 and n.NoteID = @NoteId and e.StatusID=1)      
 BEGIN  

	Declare @CreNoteID nvarchar(256);
	Declare @AccountID UNIQUEIDENTIFIER;
	Declare @DeleteCount int;

	Select @CreNoteID = CRENoteID,@AccountID = Account_AccountID from cre.note where noteid = @NoteID

	--==================
	delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10   and accountid = @AccountID)
	delete from core.event where EventTypeID = 10 and accountid = @AccountID
				
	SET @DeleteCount = @@ROWCOUNT

	--Delete FF from Backshop
	IF ((SELECT ISNUMERIC(@CRENoteId)) = 1) --Because backshop's procedure take crenoteid as int
	BEGIN
		DECLARE @BackshopFF TABLE  
		(  
			CRENoteID nvarchar(256) null,  
			FundingDate Date null,  
			FundingAmount decimal(28 ,15) null, 	 
			ShardName nvarchar(256) null  
		)  

		DECLARE @query nvarchar(MAX) = N'Select Distinct CAST(NoteID_f as varchar(256)),FundingDate,FundingAmount from [acore].[vw_AcctNoteFundings] where NoteID_f = '''+ @CRENoteId +''' '  
		INSERT INTO @BackshopFF (CRENoteID,FundingDate,FundingAmount,ShardName)  
		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF',   
		@stmt = @query 

		IF EXISTS(Select CRENoteID from @BackshopFF)
		BEGIN
			exec sp_NoteFundingsDeleteByNoteId @CRENoteId
			exec spNoteProjectedPaymentDeleteByNoteId @NoteId
			--exec sp_NoteFundingsDeleteByNoteIdPIK @CRENoteId
		END		
		
	END

	IF (@DeleteCount>0)
		exec usp_InsertActivityLog @NoteID,182,@NoteID,402,'deleted',@UserId
	--==================
	
 END


SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
END  
