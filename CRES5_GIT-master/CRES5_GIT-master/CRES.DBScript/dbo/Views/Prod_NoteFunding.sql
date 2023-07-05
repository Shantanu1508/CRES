create view [dbo].[Prod_NoteFunding]
as 
select 
NoteID as NoteKey,
CRENoteID as NoteID,
TransactionDate,
Amount ,
WireConfirm ,
PurposeBI ,
DrawFundingID ,
Comments ,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate From [DW].[Prod_NoteFunding]


