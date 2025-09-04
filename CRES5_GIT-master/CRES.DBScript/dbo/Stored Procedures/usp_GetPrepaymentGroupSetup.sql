CREATE Procedure [dbo].[usp_GetPrepaymentGroupSetup]
(
 @DealID UNIQUEIDENTIFIER
)
as 
BEGIN
	SET NOCOUNT ON;

	Select 
   pg.PrepaymentGroupSetupID,
   pg.DealID,
   pg.GroupId,
   pg.AttributeName,
   pg.AttributeValue,
   pg.CreatedBy,
   pg.CreatedDate,
   pg.UpdatedBy,
   pg.UpdatedDate

   from [CRE].[PrepaymentGroupSetup] pg
   where pg.DealID = @DealID and ISNULL(pg.IsDeleted,0) <> 1

END