create view [dbo].[Prod_DealFundingSchdule]
as 
select 
[DealID] as DealKey,
[CREDealID] as DealID,
[Date],
[Amount],
[Comment],
[PurposeBI] as Purpose,
[WireConfirm],
[DrawFundingId],	
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate From [DW].[Prod_DealFundingSchdule]

