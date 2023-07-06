-- View
-- View
Create View [dbo].[NotefutureFunding]
As
Select DealName, CRENoteID, SUM(Amount)Amount from NoteFundingSchedule
Where Amount >0
Group by Crenoteid,DealName
