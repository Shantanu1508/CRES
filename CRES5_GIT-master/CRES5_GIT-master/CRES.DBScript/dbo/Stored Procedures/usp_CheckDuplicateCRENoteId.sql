

--[dbo].[usp_CheckDuplicateCRENoteId] 'IC_Domain Memorial_Mezzx','a20daae0-069f-4b74-9947-07a3279accd7'
--[dbo].[usp_CheckDuplicateCRENoteId] '4066','D3AC641C-810C-4B54-8CB1-2A217307EE90'
CREATE PROCEDURE [dbo].[usp_CheckDuplicateCRENoteId] --'4066','48bab971-4f1b-49a6-b9af-7ebaba08c446'
(
	@CRENoteID nvarchar(256),
	@NoteID UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Declare @IsExist bit = 0;

--if(@NoteID='00000000-0000-0000-0000-000000000000')
--Begin

--IF not EXISTS(Select * from CRE.Note n inner join core.Account acc on n.Account_AccountID=acc.AccountID  where n.CRENoteID = @CRENoteID and acc.IsDeleted=0)
--		BEGIN
--			 SET @IsExist = 0;
--		END
--END
--ELSE


	IF EXISTS(Select * from CRE.Note n inner join core.Account acc on n.Account_AccountID=acc.AccountID  where n.CRENoteID = @CRENoteID and n.noteid <> @NoteID  and acc.IsDeleted=0)
	BEGIN
			SET @IsExist = 1;
	END
	ELSE
	BEGIN
			SET @IsExist = 0;
	END



select @IsExist
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
--Select * from CRE.Note  where CRENoteID = '4066' and NoteID!='48bab971-4f1b-49a6-b9af-7ebaba08c446'

--END
