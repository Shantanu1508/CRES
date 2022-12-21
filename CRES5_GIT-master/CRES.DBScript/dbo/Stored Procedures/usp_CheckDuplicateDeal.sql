-- Procedure

-- [DBO].[usp_CheckDuplicateDeal] '00000000-0000-0000-0000-000000000000',  'NKM15-0006','NewDeal','2230'        --202
-- [DBO].[usp_CheckDuplicateDeal] '00000000-0000-0000-0000-000000000000',  'NKM15-0006','NewDeal','2230xxx'     --204
-- [DBO].[usp_CheckDuplicateDeal] '00000000-0000-0000-0000-000000000000','15-0468','NOPSI Hotel','1806,2445,6071,2846'        --203
-- [DBO].[usp_CheckDuplicateDeal] '75029692-C657-4D0C-8858-877A0EC0F3A7','458666','Copy seventy rainey','2230A,2742C,4352D'    --204
-- [DBO].[usp_CheckDuplicateDeal]  '00000000-0000-0000-0000-000000000000','15-0468','NOPSI Hotel','2230xxxxxx' --201

CREATE PROCEDURE [DBO].[usp_CheckDuplicateDeal] 
(
	@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@CREDealID nvarchar(256),
	@DealName nvarchar(256),
	@CRENoteID nvarchar(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Declare @IsExist int = 204;

IF OBJECT_ID('tempdb..[#tblListNotes]') IS NOT NULL                                         
 DROP TABLE [#tblListNotes]

	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)

IF(@CRENoteID <>'')
BEGIN
	
	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@CRENoteID);
END;

 ----Check duplicate deal-----
 IF Exists(Select dealid from CRE.Deal where (CREDealID=@CREDealID and dealid <> @DealId and IsDeleted=0) 
   OR (DealName=@DealName and dealid <> @DealId and IsDeleted=0)) 
   BEGIN
     SET @IsExist = 201;
	 
   END
 

----Check duplicate note-----
 IF EXISTS(Select NoteID from CRE.Note n inner join core.Account acc on n.Account_AccountID=acc.AccountID  where n.CRENoteID in (select CRENoteID from #tblListNotes)
				and acc.IsDeleted=0 and n.DealID <> @DealId) 
	BEGIN
		SET @IsExist = 202;
		
	END



------Check duplicate deal and note -----
IF(@ISExist = 201 OR @IsExist = 202)
BEGIN
	IF EXISTS(Select d.dealid from cre.deal d 
		  inner join CRE.Note n on n.dealid = d.dealid
		  inner join core.Account acc on acc.AccountID=n.Account_AccountID
		  where  d.DealID <> @DealId and
		  d.CREDealID = @CREDealID
		  and d.DealName = @DealName
		  and d.IsDeleted=0
		  and n.CRENoteID in (select CRENoteID from #tblListNotes)
		  and acc.IsDeleted=0) 

	BEGIN
		SET @IsExist = 203;
		
	END
	
END


SELECT @IsExist;


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

