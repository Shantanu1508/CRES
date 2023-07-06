
CREATE PROCEDURE [dbo].[usp_InsertNotePeriodicCalcDynamicColumn] 
	@ColumnNames nvarchar(256),
	@NoteiDs nvarchar(max),
	@Values nvarchar(max)
AS
BEGIN
 
  declare @Values123 varchar(10)
 IF OBJECT_ID('tempdb..#TempAlterColumn') IS NOT NULL DROP TABLE #TempAlterColumn

--delete existing notes
delete from [dbo].[NotePeriodicCalcTest] where NoteID in (select [value]  from [dbo].fn_Split(@NoteiDs))

CREATE TABLE #TempAlterColumn
(
ID int Identity(1,1),
[ColumnName] NVARCHAR(50)
)

Insert into #TempAlterColumn(ColumnName)
select [value] as [Column] from [dbo].fn_Split(@ColumnNames) where [value] not in (select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where Table_Name = 'NotePeriodicCalcTest')

DECLARE @Data NVARCHAR(50)
DECLARE @ID NVARCHAR(50)

WHILE EXISTS (SELECT * FROM #TempAlterColumn)
     BEGIN 
        SELECT TOP 1 @Data = [ColumnName],@ID=ID FROM  #TempAlterColumn

          if(LEN(@Data) > 0)
            BEGIN
               exec('ALTER TABLE [dbo].[NotePeriodicCalcTest] ADD ' +   @Data + ' decimal(28,15) NULL default 0') 
            END
        DELETE FROM #TempAlterColumn WHERE ID = @ID
     END
	-- EXECUTE sp_executesql @Values
END
