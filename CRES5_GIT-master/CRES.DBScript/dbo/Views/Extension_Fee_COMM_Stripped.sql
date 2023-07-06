Create view [dbo].[Extension_Fee_COMM_Stripped]
As
Select * from    [DW].[FeeScheduleBI] F
Where Feetype = 'Extension Fee_COMM'
and ISNULL(FeetobeStripped,0) <> 0
