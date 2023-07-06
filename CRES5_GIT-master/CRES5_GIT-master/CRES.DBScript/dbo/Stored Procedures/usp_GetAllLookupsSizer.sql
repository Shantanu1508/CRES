------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------

 
CREATE PROCEDURE [dbo].[usp_GetAllLookupsSizer]	 
 
AS
BEGIN	 
	  select FeeTypeNameText , FeeTypeNameID , CAST(FeeTypeNameID as nvarchar(256)) +' - ' + FeeTypeNameText  from CRE.FeeSchedulesConfig
END


