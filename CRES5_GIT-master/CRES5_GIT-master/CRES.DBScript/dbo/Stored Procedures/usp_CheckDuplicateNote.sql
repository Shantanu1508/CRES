
--[dbo].[usp_CheckDuplicateNote] '38522','Mezz','a7522993-7d8b-4c4a-9a93-d0f44a985331'
CREATE PROCEDURE [dbo].[usp_CheckDuplicateNote]-- 'N111','55'
(
	@CRENoteID nvarchar(256),
	@NoteName nvarchar(256),
	@DealId nvarchar(256)
)
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Declare @IsExist bit = 0;




--IF EXISTS(Select * from core.account  where name = @NoteName)
--BEGIN
--	SET @IsExist = 1;
--END

IF EXISTS(Select * from CRE.Note n inner join CORE.Account ac on n.Account_AccountID=ac.AccountID  where CRENoteID = @CRENoteID  and ac.isdeleted=0)
BEGIN
	 SET @IsExist = 1;
END




IF EXISTS(Select * from core.account ac inner join cre.Note n on ac.AccountID=n.Account_AccountID where ac.name =@NoteName and n.DealID=@DealId and ac.isdeleted=0)
BEGIN
	 SET @IsExist = 1;
END



--IF(@IsExist = 1)
--BEGIN
--	Select @IsExist as result
--END
--ELSE
--BEGIN
--	Select 0 as result
--END

select @IsExist
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


