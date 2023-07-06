CREATE PROCEDURE [dbo].[usp_DeleteDealONLY] --'test'
	@CreDealID varchar(256)
as
Begin


Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
Declare @LookupIdForProperty int= (Select lookupid from core.Lookup where name = 'Property');

Declare @dealid UNIQUEIDENTIFIER;
SET @dealid = (Select DealID from CRE.DEAL where credealid = @CreDealID)


Delete from [CRE].[Property] where [Deal_DealID]=@dealid
Delete from [CRE].DealFunding where dealid = @dealid
Delete from [CRE].[PayruleSetup] where dealid = @dealid
Delete from [CRE].[Deal] where dealid = @dealid

Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty)
Delete from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty

Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote)
Delete from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote

Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal)
Delete from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal


END
