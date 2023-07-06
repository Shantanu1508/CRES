
CREATE Procedure [dbo].[usp_GetNotePeriodicCalcDynamicByNoteId] --'629A3892-863B-4313-8CCC-70205B36B9F6'
(
 @NoteId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT top 100
npc.* FROM [dbo].[NotePeriodicCalcTest] npc
left join cre.Note n on n.noteid = npc.NoteID 
inner join core.Account acc on acc.AccountID = n.Account_AccountID
where npc.NoteID = @NoteId and acc.IsDeleted = 0
--and [PeriodEndDate] in (SELECT DISTINCT EOMONTH([PeriodEndDate]) FROM [CRE].[NotePeriodicCalc] where NoteID = @NoteID)

ORDER BY [PeriodEndDate]


--declare @qrystr nvarchar(max)

--select @qrystr=N'select '+
-- STUFF
--(
--    (
--        SELECT ','+ 'npc.'+COLUMN_NAME+'=' +case when (Data_type='date' or Data_type='datetime') then 'ISNULL('+COLUMN_NAME+',getdate())' else 'cast(ISNULL('+COLUMN_NAME+',0.00) as numeric(10,2))' end
--FROM CRES4_QA.INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = N'NotePeriodicCalcTest' and COLUMN_NAME not in('NotePeriodicCalcID','NoteID')
--FOR XML PATH('')
--    ),
--     1, 1, ''
--)
--+ ' FROM [dbo].[NotePeriodicCalcTest]
-- npc
--left join cre.Note n on n.noteid = npc.NoteID 
--inner join core.Account acc on acc.AccountID = n.Account_AccountID
--where npc.NoteID = ''+cast(@NoteId as nvarchar(100))+'' and acc.IsDeleted = 0
--ORDER BY [PeriodEndDate]
--'
--EXECUTE sp_executesql @qrystr
	
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
