



CREATE VIEW [dbo].[CurrentMonthActivity] AS
SELECT 

Convert( Varchar(10),Noteid_F )Noteid_F,
Funding,
Amort,
PIKInterest
from Fundinggroups

Pivot
(

SUM(FundingAmount)
FOR PurposeTypeBI in ([Funding],[Amort] ,[PIKInterest] )

)As PivotTable





