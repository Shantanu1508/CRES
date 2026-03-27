-- View
Create View CommitmentatClosing
As
Select * from [dbo].[TotalCommitmentData]
where Type = 'Closing' and Value <> 0