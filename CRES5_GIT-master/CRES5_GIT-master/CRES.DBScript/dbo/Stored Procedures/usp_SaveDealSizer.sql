

CREATE PROCEDURE [dbo].[usp_SaveDealSizer]
(
   @CREDealID nvarchar(256) ,
   @ClientDealID nvarchar(256) ,	
   @DealName nvarchar(256),      
   @Status	nvarchar(256) ,
   @AssetManager  nvarchar(256) ,
   @DealCity  nvarchar(256) ,
   @DealState  nvarchar(256) ,
   @DealPropertyType  nvarchar(256) ,
   @TotalCommitment decimal(28, 15) ,	 
   @CreatedBy nvarchar(256) ,
   @NewDealID nvarchar(256) OUTPUT
	)
  
AS
BEGIN
 set @NewDealID='';

 Update CRE.Deal set 
				DealName=@DealName,				 
				[Status]=	@Status,			 
				TotalCommitment =@TotalCommitment ,				 			 
				AssetManager=@AssetManager,
				DealCity=@DealCity,
				DealState=@DealState,
				DealPropertyType=@DealPropertyType,		
				CREDealID=	@CREDealID	 ,
				IsDeleted =0,
				UpdatedBy=@CreatedBy,
				UpdatedDate =GETDATE()			 
				where ClientDealID=@ClientDealID
				 


IF @@ROWCOUNT =0 
Begin
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
			GeneratedBy
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
			)
			  set @NewDealID = (select tNewDealId FROM @tDeal); 


 End

 if @NewDealID=''
 begin
 set  @NewDealID = ( select  DealID from CRE.Deal where ClientDealID =@ClientDealID) 
 end 


  exec [App].[usp_AddUpdateObject] @NewDealID,283,@CreatedBy,@CreatedBy
 select @NewDealID



	 
 end 
