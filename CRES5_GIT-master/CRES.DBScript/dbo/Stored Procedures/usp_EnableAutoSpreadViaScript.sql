

CREATE PROCEDURE [dbo].[usp_EnableAutoSpreadViaScript] 
(	
	@CREDealID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] @CREDealID,'B0E6697B-3534-4C09-BE0A-04473401AB93'


	---Enable ApplyNoteLevelPaydowns for active
	Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
		select distinct d.dealid
		from cre.deal d
		left join cre.note n on n.dealid=d.dealid
		where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
		and n.actualpayoffdate is null
		and d.credealid in (@CREDealID)
	)



	----Print('Enable ApplyNoteLevelPaydowns - Phntom not linked')
	--EXEC [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '166ACA82-19E2-4B62-8454-EA2EEB283A7D','B0E6697B-3534-4C09-BE0A-04473401AB93',325

	--Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	--	select distinct d.dealid
	--	from cre.deal d
	--	left join cre.note n on n.dealid=d.dealid
	--	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=325
	--	and n.actualpayoffdate is null
	--	and d.credealid in ('17-0255IC','19-1362IC','19-0806IC')
	--)

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
