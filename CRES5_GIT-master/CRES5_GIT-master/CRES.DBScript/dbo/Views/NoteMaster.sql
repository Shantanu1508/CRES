



CREATE View [dbo].[NoteMaster]
AS
Select Distinct CAST(CRENoteid  AS Varchar(30))CRENoteid, CreDealID from [DW].[NoteBI] N
Inner join Dw.DealBi D on D.DealID = N.DealID
Where CRENoteid Not in ('10251','10252','10253')
Union
Select Distinct  Convert(varchar(30),Noteid), [ControlId_F] from [DW].[UwNoteBI]
Where Noteid not in ('10251','10252','10253')

