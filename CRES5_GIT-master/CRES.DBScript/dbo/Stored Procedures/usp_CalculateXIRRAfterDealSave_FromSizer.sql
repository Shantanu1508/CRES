-- Procedure
---[dbo].[usp_CalculateXIRRAfterDealSave_FromSizer] '24-092224','B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_CalculateXIRRAfterDealSave_FromSizer]
	@CREDealID nvarchar(256),
	@UserId nvarchar(256)
	
AS  
BEGIN    
  
SET NOCOUNT ON;  

	--Declare @CREDealID nvarchar(256) = '24-092224'
	--Declare @UserId nvarchar(256) = 'B0E6697B-3534-4C09-BE0A-04473401AB93'



	Declare @DealAccountid UNIQUEIDENTIFIER;
	Declare @dealid UNIQUEIDENTIFIER
	Declare @dealname nvarchar(256)


	Select @DealAccountid = Accountid ,@dealid = DealID,@dealname = DealName
	from cre.deal where CREDealID =@CREDealID

	IF (@dealname not like '%copy%')
	BEGIN
		---Calc only deal xirr
		---EXEC [dbo].[usp_CalculateXIRRAfterDealSave] @DealAccountid,@UserId,null
		EXEC [dbo].[usp_CalculateXIRRAfterDealSave] @DealAccountid,@UserId,292


		-----Calculate whole XIRR (Because deal is not accociate with that xirr)
		Select distinct xr.XIRRConfigID ---,xr.ReturnName,d.DealID,xci.DealAccountID
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid
		inner join cre.deal d on d.dealid = n.dealid
		Inner join cre.TagAccountMappingXIRR tgm on tgm.AccountID = n.account_accountid
		Inner join cre.tagmasterXIRR tg on tg.tagmasterXIRRID = tgm.tagmasterXIRRID
		Inner join (
			Select ObjectID as TagmasterXIRRID,xd.XIRRConfigID,xc.ReturnName,xc.ShowReturnonDealScreen 
			from cre.XIRRConfigDetail xd
			Inner join cre.XIRRConfig xc on xc.XIRRConfigID = xd.XIRRConfigID
			where ObjectType = 'Tag'
			and xc.ShowReturnonDealScreen  = 3
		)xr on xr.TagmasterXIRRID = tg.TagMasterXIRRID

		left join cre.XIRRCalculationInput xci on xci.XIRRConfigID = xr.XIRRConfigID and xci.DealAccountID = d.AccountID

		where acc.isdeleted <> 1 and d.IsDeleted <> 1 and d.DealName not like '%copy%'
		and d.dealid = @dealid		
		and xci.DealAccountID is null


	END
	ELSE
	BEGIN
		Select null as XIRRConfigID from cre.XIRRConfig where 1= 2
	END




END