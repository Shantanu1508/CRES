
CREATE VIEW [dbo].[NoteFunding] AS
Select
NoteID,
TransactionDate,
WireConfirm,
PurposeBI,
Amount,
DrawFundingID,
Comments,
AuditAddUserId,
AuditAddDate,
AuditUpdateUserId,
AuditUpdateDate
from [DW].[NoteFundingBI]