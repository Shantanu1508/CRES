

CREATE PROCEDURE [DBO].[usp_CheckDuplicateDealSizer] 
(
	@CREDealID nvarchar(256),
	@DealName nvarchar(256),
	@Username  nvarchar(256),
	@Password  nvarchar(256)
)
AS
BEGIN
  SET NOCOUNT ON;  
 Declare @IsExist nVARCHAR(50);
 Declare @Functionres int;
 set @IsExist ='Not Duplicate'

 set @Functionres = (select( DBO.ufn_UnderwrittingCheckPermissionFunction(@Username,@Password,@CREDealID))); 

if (@Functionres =2) 
 begin    	 			
             print  @Functionres

 			IF EXISTS(Select * from CRE.Deal  where dealname = @DealName and isnull(isdeleted,0)=0)
			BEGIN
				SET @IsExist = 'Duplicate';
			END

			IF EXISTS(Select * from CRE.Deal  where CREDealID = @CREDealID and isnull(isdeleted,0)=0)
			BEGIN
				 SET @IsExist = 'Duplicate';
			END

			IF(@IsExist = 'Duplicate')
			BEGIN
				Select @IsExist as result
			END
			ELSE
			BEGIN
				Select @IsExist as result
			END

 end
 else
 begin 
   -- 0 or 1
    print  @Functionres
    set @CREDealID = @Functionres
    Select @CREDealID
  end 



END

