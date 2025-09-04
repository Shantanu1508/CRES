-- Procedure

CREATE PROCEDURE [dbo].[usp_DeleteXIRRByXIRRConfigID]
	@XIRRConfigID int
AS
BEGIN
	SET NOCOUNT ON;
	   
	Delete From [CRE].[XIRROutputPortfolioLevel]    where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRROutputDealLevel] where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRReturnGroup]      where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRCalculationInput] where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRCalculationRequests]	   where XIRRConfigID = @XIRRConfigID
	
	---Delete From [CRE].XIRRConfigArchive	   where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRInputCashflow]	   where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRConfigDetail] where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRConfigFilter] where XIRRConfigID = @XIRRConfigID
	Delete From [CRE].[XIRRConfig]	   where XIRRConfigID = @XIRRConfigID

END