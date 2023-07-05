






CREATE View [dbo].[AMUser]
AS
Select * from
(
Select DealID 
,[LeadAssetManager]
,[SecondaryAssetManager]
, [AssetManager]
, (LastName + ',' + ' ' + + FirstName) AMUSER

, DealKey   
,(FirstName + ' ' + LastName ) AM
From DBO.Deal D
Left join [App].[User] U 
on Replace([LeadAssetManager],',','') =  (LastName +FirstName)
 OR Replace([SecondaryAssetManager],', ','') = (LastName+FirstName ) 
 or Replace([AssetManager],',','')= (LastName+FirstName )
 where status = 'Active'
 Union
 Select DealID ,[LeadAssetManager],[SecondaryAssetManager]
, [AssetManager], (LastName + ',' + ' ' + + FirstName) AMUSER, DealKey  
, (FirstName + ' ' + LastName ) AM
 From DBO.Deal D
left join [App].[User] U 
on Replace([LeadAssetManager],', ','') =  (LastName +FirstName)
 OR Replace([SecondaryAssetManager],', ','') = (LastName+FirstName ) 
 or Replace([AssetManager],', ','')= (LastName+FirstName )
  where status = 'Active'
 )X




