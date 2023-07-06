CREATE view [dbo].[MaturityOnHoliday]
as
Select  
T.Noteid
, MAX(Date)Date
--, Case when  Day (MAX(Date)) <> 8 THEN 'Holiday Adjustment' Else 'No Holiday Adjustment' End as HolidayAdjustment
, Day (FullyExtendedMaturityDate) FUllyextendMonhh
from TransactionEntry T
Inner JOin Note N on T.NoteKey = N.Notekey
Where Type = 'InterestPaid'

Group by T.NoteID, Day (FullyExtendedMaturityDate)

HAving  Day (FullyExtendedMaturityDate) <> 8  
