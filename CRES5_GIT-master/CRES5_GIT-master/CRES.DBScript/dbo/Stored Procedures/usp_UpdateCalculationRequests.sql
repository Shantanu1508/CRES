
CREATE PROCEDURE [dbo].[usp_UpdateCalculationRequests]  -- '1e034feb-ee17-4699-8240-f1bcd856a2fe' , 'd9db0edcf07b4ee1bc53f3ba244c3431', 0, 'c10f3372-0fc2-4861-a9f5-148f1f80804f', '00000000-0000-0000-0000-000000000000', '' 
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
	
	
    --SELECT TOP (1000) [Id],[ObjectId],[AnalysisID],[RequestID],[CreatedDate] , [Message] FROM [dbo].[app.LoggerCalc];
	INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'SP call start');	


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
		SET @DealID_any = @ObjectID  
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
				SET @DealID_any = (Select noteid from cre.Note where CRENoteID = @ObjectID);  
			END  
		END
	END	  

	--================================= 
	Set @isNote = 0;  
	IF exists (Select noteid from cre.note where NoteID = @DealID_any)
	BEGIN
		
		SET @isNote = 1;  	 
	END
  
	    
	--=================================

	IF EXISTS(Select CalculationRequestID from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID IS NULL and (dealid = @DealID_any or noteid = @DealID_any))  
	BEGIN  
	    INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update RequestID || '  );
		-- + ( SELECT TOP 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);
		
		IF ((Select CalcType from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID IS NULL and (dealid = @DealID_any or noteid = @DealID_any) ) = 776)
		BEGIN
		  Update Core.CalculationRequests SET RequestID = @RequestID, ErrorMessage=@ErrorMessage where AnalysisID = @AnalysisID and (dealid = @DealID_any); 	
        END
		ELSE
		BEGIN
		  Update Core.CalculationRequests SET RequestID = @RequestID, ErrorMessage=@ErrorMessage where AnalysisID = @AnalysisID and (noteid = @DealID_any); 	
        END
		
		INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Updated RequestID sucessfully || ' );
		-- + ( SELECT TOP 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);
	END  
  
  

  
	IF EXISTS(Select CalculationRequestID from Core.CalculationRequests where AnalysisID = @AnalysisID and RequestID = @RequestID and (dealid = @DealID_any or noteid = @DealID_any))  
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
   
        INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update @calc_statusid || ' ); 
		--+  ( SELECT top 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);	
		
   
		IF(@calc_statusid = 265)   --Failed  
		BEGIN  

		    INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Failed || ' ); 
		-- + ( SELECT top 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);
		
			--Failed  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage where RequestID = @RequestID and AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any);  
  
			-- set all dependent note as Fail  
			IF(@isNote = 1)  
			BEGIN  
				Update Core.CalculationRequests SET [StatusID] = @calc_statusid,StartTime = getdate(), EndTime = getdate()  , ErrorMessage=@ErrorMessage
				where noteid in  
				(  
					SELECT NoteId FROM CORE.CalculationRequests  
					WHERE NoteId In (select p.StripTransferTo from CRE.PayruleSetup p  where p.StripTransferFrom = @DealID_any)  
				)  
			END  
		END  

  
		IF(@calc_statusid = 266)   --Completed   
		BEGIN  
			
			 INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Completed ||' ); 
		-- + ( SELECT top 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);

			--Completed  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,EndTime =getdate(), ErrorMessage=@ErrorMessage where RequestID = @RequestID and AnalysisID = @AnalysisID 
			and (dealid = @DealID_any or noteid = @DealID_any);  
    
			-- set all dependent note as Processing  
			IF(@isNote = 1)  
			BEGIN  
				Update Core.CalculationRequests SET [StatusID] = 292 where noteid in (  
					SELECT NoteId FROM CORE.CalculationRequests  
					WHERE NoteId In  (select p.StripTransferTo from CRE.PayruleSetup p  where  p.StripTransferFrom = @DealID_any)  
				)  
			END  
		END  

		IF(@calc_statusid = 267)   --Running  
		BEGIN  
			 INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Running ||' );
		-- + ( SELECT top 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);

			--Running  
			Update Core.CalculationRequests SET [StatusID] = @calc_statusid,StartTime =getdate(), ErrorMessage=@ErrorMessage 
			where RequestID = @RequestID and AnalysisID = @AnalysisID  and (dealid = @DealID_any or noteid = @DealID_any)
			and StartTime is null
		
		END 



		IF(@calc_statusid = 292)    --Processing  
		BEGIN  
			INSERT INTO [app.LoggerCalc] ([ObjectId],[AnalysisID],[RequestID],[Message]) VALUES(@ObjectID, @AnalysisID, @RequestID, 'Update Processing @calc_statusid = 292 || ' ); 
		-- + ( SELECT top 1 CONVERT(VARCHAR(5000),CalculationRequestID) + '_'+ ISNULL(CONVERT(VARCHAR(5000),RequestID),'NA')  FROM Core.CalculationRequests WHERE AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any ))
		--);

			Update Core.CalculationRequests SET [StatusID] = 735 , ErrorMessage=@ErrorMessage  ---,StartTime = getdate()
			where RequestID = @RequestID and AnalysisID = @AnalysisID and (dealid = @DealID_any or noteid = @DealID_any)
		
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
