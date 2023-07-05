-- View
-- View
CREATE View [dbo].[NoteTransfer]
as
Select * from NoteFundingSchedule
Where Amount < 0 and Purpose = 'Note Transfer'
