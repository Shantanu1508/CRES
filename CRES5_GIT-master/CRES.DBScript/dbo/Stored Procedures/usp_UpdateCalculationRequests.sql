
---[dbo].[usp_UpdateCalculationRequests]  '5dd8e0a2-a2a1-424b-8653-5e97ab046b50' , 'c54408b3849145ada231933d4bf8b578', 0, '72114a53-495c-464b-a020-62884a0f1462', '00000000-0000-0000-0000-000000000000', '' 

CREATE PROCEDURE [dbo].[usp_UpdateCalculationRequests]  
(     
	 @ObjectID nvarchar(256),  
	 @RequestID nvarchar(256),  
	 @Status int,  
	 @AnalysisID nvarchar(256),      
	 @UserID UNIQUEIDENTIFIER  ,
	 @ErrorMessage nvarchar(MAX)  
)      
       
AS      
BEGIN      
    
 SET NOCOUNT ON;      
  
	Declare @DealID_any UNIQUEIDENTIFIER;  
	Declare @isNote int ;  
	
	
   
	----INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP call start');	


	IF(@AnalysisID is null)  
	BEGIN  
		SET @AnalysisID = (Select AnalysisID from core .analysis where name = 'Default')  
	END  


	IF( NULLIF(@ObjectID,'') IS NULL AND @RequestID IS NOT NULL)
	BEGIN
	  SET @ObjectID = (SELECT DealID FROM core.CalculationRequests  WHERE  RequestID = @RequestID)
	END
   
	IF((SELECT 1 WHERE @ObjectID LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)  
	BEGIN  
		---If @DealID_any is guid  
		
		IF exists (Select dealid from cre.deal where dealid = @ObjectID)  
		BEGIN  
			SET @DealID_any = @ObjectID  
		END
		ELSE 
		BEGIN
			IF exists (Select noteid from cre.note where NoteID = @ObjectID) --check input is noteId   
			BEGIN  
				SET @DealID_any = (Select Account_AccountID from cre.Note where NoteID = @ObjectID);  
			END  
		END

	END 
	ELSE 
	BEGIN
		IF exists (Select dealid from cre.deal where credealid = @ObjectID)  
		BEGIN  
			SET @DealID_any = (Select dealid from cre.deal where credealid = @ObjectID)  	
		END
		ELSE 
		BEGIN
			IF exists (Select noteid from cre.note where CRENoteID = @ObjectID) --check input is noteId   
			BEGIN  
				SET @DealID_any = (Select Account_AccountID from cre.Note where CRENoteID = @ObjectID);  
			END  
		END
	END	  

	--================================= 
	Set @isNote = 0;  
	IF exists (Select noteid from cre.note where Account_AccountID = @DealID_any)
	BEGIN
		
		SET @isNote = 1;  	 
	END
  
	    
	--=================================

	IF EXISTS(Select CalculationRequestID from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID IS NULL and (dealid = @DealID_any or AccountId = @DealID_any))  
	BEGIN  
	    ----INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update RequestID || '  );
		
		IF EXISTS(Select CalcType from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID IS NULL and (dealid = @DealID_any or AccountId = @DealID_any) and CalcType = 776 ) 
		BEGIN
		--Prepay
			---INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Updated RequestID Prepay || ' );
			Update Core.CalculationRequests SET RequestID = @RequestID, ErrorMessage=@ErrorMessage,RequestID_Time = getdate() where AnalysisID = @AnalysisID and (dealid = @DealID_any) and CalcType = 776; 	
        END
		ELSE
		BEGIN
			----INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Updated RequestID basic calc || ' );
			Update Core.CalculationRequests SET RequestID = @RequestID, ErrorMessage=@ErrorMessage,RequestID_Time = getdate()  where AnalysisID = @AnalysisID and (AccountId = @DealID_any); 	
        END
		
		
	END  
  
  

  
	IF EXISTS(Select CalculationRequestID from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID = @RequestID and (dealid = @DealID_any or AccountId = @DealID_any))  
	BEGIN  
		Declare @calc_statusid int;  
   
		--Failed= -2, -1  
		--Completed = 2  
		--Running = 1  
		--Processing = 0  
		--Dependents = ??  
  


		--Failed  
		IF(@Status < 0)  
		BEGIN  
			
			SET @calc_statusid = 265  
		END  
  
		--Completed  
		IF(@Status = 2)  
		BEGIN  
			
			SET @calc_statusid = 266  
		END  
  
		--Running  
		IF(@Status = 1)  
		BEGIN  
			
			SET @calc_statusid = 267  
		END  
   
		--Processing  
		IF(@Status = 0)  
		BEGIN  
			
			SET @calc_statusid = 292  
		END  
   
		----Dependents  
		--IF(@Status = 5)  
		--BEGIN  
		-- SET @calc_statusid = 326  
		--END  
   
        --INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update @calc_statusid || ' ); 	
		
   
		IF(@calc_statusid = 265)   --Failed  
		BEGIN  

		    --INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Failed || ' ); 		
		
			--Failed  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage where RequestID = @RequestID and AnalysisID = @AnalysisID and (dealid = @DealID_any or AccountId = @DealID_any);  
  
			-- set all dependent note as Fail  
			IF(@isNote = 1)  
			BEGIN  
				Update Core.CalculationRequests SET [StatusID] = @calc_statusid,StartTime = getdate(), EndTime = getdate()  , ErrorMessage='Excluded from the calculation as parent note failed to calculate.'
				where AccountId in  
				(  
					SELECT AccountId 
					FROM CORE.CalculationRequests cr
					Inner Join cre.note n on n.Account_AccountID = cr.AccountId
					WHERE n.NoteId In (select p.StripTransferTo from CRE.PayruleSetup p  where p.StripTransferFrom = @DealID_any)  
					and AnalysisID = @AnalysisID
				)  
				and AnalysisID = @AnalysisID
			END  
		END  

  
		IF(@calc_statusid = 266)   --Completed   
		BEGIN  
			
			 --INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Completed ||' ); 
		

			--Completed  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage where RequestID = @RequestID and AnalysisID = @AnalysisID 
			and (dealid = @DealID_any or AccountId = @DealID_any);  
    

			---- set all dependent note as Processing  
			--IF(@isNote = 1)  
			--BEGIN  

			--	DECLARE @PriID INT  
			--	SET @PriID = (Select top 1 PriorityID FROM Core.CalculationRequests where AnalysisID = @AnalysisID and CalcType = 775 and (dealid = @DealID_any or noteid = @DealID_any) )
				
			--	INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update dependent note as Processing ||' ); 

			--	Update Core.CalculationRequests SET [StatusID] = 292 ,PriorityID = 1 --@PriID
			--	where noteid in (  
			--		SELECT NoteId FROM CORE.CalculationRequests  
			--		WHERE NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom = @DealID_any)  
			--		and AnalysisID = @AnalysisID 
			--	) 
			--	and AnalysisID = @AnalysisID 
				 
			--END  
			 

		END  

		IF(@calc_statusid = 267)   --Running  
		BEGIN  
			 ---INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Running ||' );
		

			--Running  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,StartTime =getdate(), ErrorMessage=@ErrorMessage 
			where RequestID = @RequestID and AnalysisID = @AnalysisID  and (dealid = @DealID_any or AccountId = @DealID_any)
			and StartTime is null
		
		END 



		IF(@calc_statusid = 292)    --Processing  
		BEGIN  
			---INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Processing @calc_statusid = 292 || ' ); 
		

			Update Core.CalculationRequests SET [StatusID] = 735 , ErrorMessage=@ErrorMessage  ---,StartTime = getdate()
			where RequestID = @RequestID and AnalysisID = @AnalysisID and (dealid = @DealID_any or AccountId = @DealID_any)
		
			--if(@isNote = 1)  
			--BEGIN  
			--	Update Core.CalculationRequests SET [StatusID] = 0 where noteid in  
			--	(  
			--		SELECT NoteId FROM CORE.CalculationRequests  
			--		WHERE NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom = @DealID_any)  
			--	)  
			--END   
			    
		END  



	END





  
  
END
