Declare @tblNewDebtName as Table(
	DebtName nvarchar(256),
	DebtType nvarchar(256),	
	AbbreviationName nvarchar(256),
	LinkedFundName nvarchar(256),
	DebtNameClientSheet nvarchar(256)

)

INSERT INTO @tblNewDebtName(DebtName,DebtType,AbbreviationName,LinkedFundName,DebtNameClientSheet)
VALUES('ACPI-OZK-Sale','Sale','OZK','ACP I','Bank OZK')

INSERT INTO @tblNewDebtName(DebtName,DebtType,AbbreviationName,LinkedFundName,DebtNameClientSheet)
VALUES('ACPI-TBD-TBD','TBD','TBD','ACP I','TBD')

INSERT INTO @tblNewDebtName(DebtName,DebtType,AbbreviationName,LinkedFundName,DebtNameClientSheet)
VALUES('ACPI-TBK-Sale','Sale','TBK','ACP I','TBK Bank')

INSERT INTO @tblNewDebtName(DebtName,DebtType,AbbreviationName,LinkedFundName,DebtNameClientSheet)
VALUES('AOCI-SWB 2023-01-Subline','Subline','SWB 2023-01','AOC I','SWB 2023-01')


INSERT INTO @tblNewDebtName(DebtName,DebtType,AbbreviationName,LinkedFundName,DebtNameClientSheet)
VALUES('AOCII-OZK-Sale','Sale','OZK','AOC II','Bank OZK')





Declare @L_DebtName nvarchar(256)
Declare @L_AbbreviationName nvarchar(256)
Declare @L_LinkedFundID nvarchar(256)
Declare @L_DebtType nvarchar(256)
Declare @L_DebtNameClientSheet nvarchar(256)
Declare @UserID UNIQUEIDENTIFIER = 'B0E6697B-3534-4C09-BE0A-04473401AB93'

IF CURSOR_STATUS('global','CursorInserDebtNew')>=-1
BEGIN
	DEALLOCATE CursorInserDebtNew
END

DECLARE CursorInserDebtNew CURSOR 
for
(
	Select t.DebtName as LiabilityID
	,t.AbbreviationName as FacilityShortName
	,eq.AccountID as Eq_AccountID
	,ac.AccountCategoryID debttype
	,t.DebtNameClientSheet
	from @tblNewDebtName t
	Inner join core.AccountCategory ac on ac.Name = t.DebtType
	left join cre.Equity eq on eq.AbbreviationName = t.LinkedFundName
)
OPEN CursorInserDebtNew 

FETCH NEXT FROM CursorInserDebtNew
INTO @L_DebtName,@L_AbbreviationName,@L_LinkedFundID,@L_DebtType,@L_DebtNameClientSheet
WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF NOT EXISTS(Select * from cre.debt dt inner join core.account acc on acc.accountid = dt.accountid where acc.isdeleted <> 1 and acc.name = @L_DebtName)
	BEGIN
		---=====Insert into Account table=====  
		DECLARE @insertedAccountIDdt uniqueidentifier;        
		DECLARE @CashAccountName nvarchar(256);
		DECLARE @tAccountdt TABLE (tAccountIDdt UNIQUEIDENTIFIER)        
  
		INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],BaseCurrencyID,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)        
		OUTPUT inserted.AccountID INTO @tAccountdt(tAccountIDdt)        
		VALUES(1,@L_DebtName,@L_DebtType,187,@UserID,GETDATE(),@UserID,GetDATE(),0)        
  
		SELECT @insertedAccountIDdt = tAccountIDdt FROM @tAccountdt;        
		-------------------------------------------  
	
		INSERT INTO [CRE].[Debt]
		(AccountID	
		,CreatedBy 
		,CreatedDate
		,UpdatedBy 
		,UpdatedDate		
		,AbbreviationName
		,LinkedFundID
		,DebtNameClientSheet
		)   
		VALUES(   
		@insertedAccountIDdt
		,@UserID
		,GETDATE()   
		,@UserID     
		,GETDATE() 
		,@L_AbbreviationName
		,@L_LinkedFundID
		,@L_DebtNameClientSheet
		) 
	
		SET @CashAccountName = CONCAT(@L_DebtName,  ' Portfolio');

		EXEC  [dbo].[usp_InsertUpdateCash] @insertedAccountIDdt, @CashAccountName, 'Debt', @userID

	END
					 
FETCH NEXT FROM CursorInserDebtNew
INTO @L_DebtName,@L_AbbreviationName,@L_LinkedFundID,@L_DebtType,@L_DebtNameClientSheet
END
CLOSE CursorInserDebtNew   
DEALLOCATE CursorInserDebtNew
---===============================