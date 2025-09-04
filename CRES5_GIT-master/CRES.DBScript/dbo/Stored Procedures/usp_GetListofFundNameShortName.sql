CREATE PROCEDURE [dbo].[usp_GetListofFundNameShortName] 
AS
BEGIN

Select 
AccountID,
AbbreviationName
from CRE.Equity

END