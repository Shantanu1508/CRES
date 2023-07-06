-- View
-- View
CREATE View [dbo].[NoteTransferPostive]
as
Select *  from NoteFundingSchedule
Where Amount > 0 and Purpose = 'Note Transfer'
--Group bY CRENoteID
