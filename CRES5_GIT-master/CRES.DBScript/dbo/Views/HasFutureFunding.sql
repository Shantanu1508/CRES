-- View
Create View HasFutureFunding
as
Select * from NoteFundingSchedule
where Amount>0 and Date > Getdate()