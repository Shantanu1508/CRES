
Create PROCEDURE myStoredProc
AS
BEGIN


DeCLARE @COlumnNames NVARCHAR (MAX) = ''

DeCLARE @SQL NVARCHAR (MAX) = ''
Select @ColumnNames = STUFF((Select distinct ','+ QUOTeNAME (Noteid)  from NoteFunding
								For XML PATH ('') , TYPE 
								).value('.', 'NVARCHAR(MAX)'),1,1,'')



SET @SQL = 

'ALTER VIEW myView
                AS

Select * from
(
Select NoteID, Amount, TransactionDate, WireConfirm, PurposeBI,Comments  from NoteFunding
where ISNULL(Amount,0) <> 0
) BaseData

PIVOT (
 SUM(AMount) FOR NoteID 
in (' +@COlumnNames +

')
)AS PIVOTable'



Execute ( @sql)
End
