CREATE view [dbo].[Staging_NoteFunding]
as 
select 
N.NoteID as NoteKey,
CRENoteID as NoteID,
TransactionDate,
Amount ,
WireConfirm ,
PurposeBI ,
DrawFundingID ,
ISNULL(N.Comments,'None')Comments 
  ,  CASE WHEN  N.COmments IS NULL OR N.COmments = '' THEN 'None' Else N.COmments END as CommentsBI,
N.CreatedBy,
N.CreatedDate,
N.UpdatedBy,
N.UpdatedDate,
WireConfirmBI =  ISNULL( WIRECONFIRM,0)
, Purpose_calculated = Case when PurposeBI = 'Debt Service / Opex' and WIRECOnfirm = 1 THEN 'Debt Service / Opex'
							when PurposeBI = 'Debt Service / Opex' and WIRECOnfirm = 0 THEN 'Capitalized Interest'
							when PurposeBI = 'TILC Draw'  THEN 'TI/LC'
							Else PurposeBI
							End
,D.DealKey
,DealName
							 From [DW].[Staging_NoteFunding] N
							 Left Join dbo.Note nn on N.crenoteid = nn.Noteid
							 inner join dbo.deal d on nn.dealkey = d.dealkey







