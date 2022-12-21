CREATE View [dbo].[DealMaster]
AS
Select [ControlId] from [DW].[UwDealBI]
Union
Select CREDealID from [DW].[DealBI]
