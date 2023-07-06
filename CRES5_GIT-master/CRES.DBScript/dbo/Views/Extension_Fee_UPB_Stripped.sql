

Create view [dbo].[Extension_Fee_UPB_Stripped]
As
Select * from    [DW].[FeeScheduleBI] F
Where Feetype = 'Extension Fee_UPB'
and ISNULL(FeetobeStripped,0) <> 0