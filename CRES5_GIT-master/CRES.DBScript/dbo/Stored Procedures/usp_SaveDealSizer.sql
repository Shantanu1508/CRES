-- Procedure  
  
  
CREATE PROCEDURE [dbo].[usp_SaveDealSizer]  
(  
 @CREDealID nvarchar(256) ,  
 @ClientDealID nvarchar(256) ,   
 @DealName nvarchar(256),        
 @Status nvarchar(256) ,  
 @AssetManager  nvarchar(256) ,  
 @DealCity  nvarchar(256) ,  
 @DealState  nvarchar(256) ,  
 @DealPropertyType  nvarchar(256) ,  
 @TotalCommitment decimal(28, 15) ,    
 @CreatedBy nvarchar(256) ,   
 @NewDealID nvarchar(256) OUTPUT  ,
 @EnableAutoSpread bit = null
)    
  
AS  
BEGIN  
	set @NewDealID='';  
  
	Update CRE.Deal set   
	DealName=@DealName,       
	[Status]= @Status,      
	TotalCommitment =@TotalCommitment ,           
	AssetManager=@AssetManager,  
	DealCity=@DealCity,  
	DealState=@DealState,  
	DealPropertyType=@DealPropertyType,    
	CREDealID= @CREDealID  ,  
	---IsDeleted =0,  
	UpdatedBy=@CreatedBy,  
	UpdatedDate =GETDATE() ,  
	EnableAutoSpread = @EnableAutoSpread,  
	EnableAutospreadRepayments =0,  
	ApplyNoteLevelPaydowns=0    
	where ClientDealID=@ClientDealID  
	and isdeleted <> 1  
  
  
	IF @@ROWCOUNT = 0   
	Begin  


		---=====Insert into Account table=====  
		DECLARE @insertedAccountID uniqueidentifier;        
        
		DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)        
  
		INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)        
		OUTPUT inserted.AccountID INTO @tAccount(tAccountID)        
		VALUES(1,@DealName,10,@CreatedBy,GETDATE(),@CreatedBy,GetDATE(),0)        
  
		SELECT @insertedAccountID = tAccountID FROM @tAccount;        
		-------------------------------------------  

		DECLARE @tDeal TABLE (tNewDealId UNIQUEIDENTIFIER)  
  
		INSERT INTO CRE.Deal  
		( 
		CREDealID,  
		ClientDealID,  
		DealName,  
		Status,  
		AssetManager,  
		DealCity,  
		DealState,  
		DealPropertyType,  
		TotalCommitment,  
		CreatedBy,  
		CreatedDate,  
		UpdatedBy,  
		UpdatedDate,  
		IsDeleted,  
		GeneratedBy,  
		EnableAutoSpread,  
		EnableAutospreadRepayments,  
		ApplyNoteLevelPaydowns , 
		AccountID
		)  
		OUTPUT inserted.DealID INTO @tDeal(tNewDealId)  
    
		VALUES  
		(  
		@CREDealID,  
		@ClientDealID,  
		@DealName,  
		@Status,  
		@AssetManager,  
		@DealCity,  
		@DealState,  
		@DealPropertyType,  
		@TotalCommitment,  
		@CreatedBy,  
		GETDATE(),  
		@CreatedBy  
		,GETDATE()  
		,0  
		,(select lookupid from Core.Lookup where ParentID= 36 and name ='By Sizer')  
		,@EnableAutoSpread  
		,0  
		,0  
		,@insertedAccountID
		)  
		set @NewDealID = (select tNewDealId FROM @tDeal);  
	End
	ELSE
	BEGIN
		---Update Deal
		declare @L_Accountid UNIQUEIDENTIFIER;  
		SEt @L_Accountid = (Select AccountID from CRE.Deal where ClientDealID=@ClientDealID  )  
		Update CORE.Account set [name] = @DealName where AccountID = @L_Accountid and AccountTypeID = 10  
      
	END  
  

	IF @NewDealID=''  
	BEGIN  
		set  @NewDealID = (select  DealID from CRE.Deal where ClientDealID =@ClientDealID and isdeleted <> 1)   
	END   
  
  
	exec [App].[usp_AddUpdateObject] @NewDealID,283,@CreatedBy,@CreatedBy  
	select @NewDealID  
  
  
 end
GO

