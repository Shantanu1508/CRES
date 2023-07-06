CREATE PROCEDURE [Core].[usp_GetPortfolioDetailByID] --'92D6AE4D-9183-4A87-A04F-9A64C8437F06'
(
@PortfolioID uniqueidentifier
)	
AS
BEGIN
DECLARE @PortfolioMasterID int

SELECT [PortfolioMasterID]
      ,[PortfolioMasterGuid]
      ,[PortfoliName]
	  ,(select distinct  
		stuff((
        select ','+cast(ObjectID as varchar(10)) from  core.PortfolioDetail where ObjectTypeID = 511 and PortfolioMasterID = p.[PortfolioMasterID]
        for xml path('')
		),1,1,'')) as PoolIDs
		,(select distinct  
		stuff((
        select ','+cast(ObjectID as varchar(10)) from  core.PortfolioDetail where ObjectTypeID = 510 and PortfolioMasterID = p.[PortfolioMasterID]
        for xml path('')
		),1,1,'')) as ClientIDs
		,(select distinct  
		stuff((
        select ','+cast(ObjectID as varchar(10)) from  core.PortfolioDetail where ObjectTypeID = 574 and PortfolioMasterID = p.[PortfolioMasterID]
        for xml path('')
		),1,1,'')) as FundIDs
		,(select distinct  
		stuff((
        select ','+cast(ObjectID as varchar(10)) from  core.PortfolioDetail where ObjectTypeID = 633 and PortfolioMasterID = p.[PortfolioMasterID]
        for xml path('')
		),1,1,'')) as FinancingSourceIDs
      ,[Description]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,[AllowWholeDeal]
 FROM [Core].[PortfolioMaster] p WHERE PortfolioMasterGuid = @PortfolioID

END

