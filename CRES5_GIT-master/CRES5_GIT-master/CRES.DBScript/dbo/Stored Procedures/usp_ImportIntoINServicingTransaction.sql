

  

CREATE PROCEDURE [dbo].[usp_ImportIntoINServicingTransaction]  
 @tblServicingTransaction [TableTypeServicingTransaction] readonly,
 @CreatedBy nvarchar(max),
 @FileName  nvarchar(max),
 @OriginalFileName nvarchar(max),
 @storagetype nvarchar(50),
 @StartDate Date,
 @EndDate Date
AS
BEGIN
  

DECLARE @ServicerWellsFargo int = (Select LookupID from core.lookup where name = 'Wells Fargo' and parentid = 62);
DECLARE @Active int = (Select LookupID from core.lookup where name = 'Active' and parentid = 1);

--Update servicer to wells fargo in note
UPDATE CRE.note set Servicer = @ServicerWellsFargo ,UpdatedBy = @CreatedBy,UpdatedDate = getdate()
where crenoteid in (SELECT distinct NoteID FROM @tblServicingTransaction) 




Truncate table [IO].[IN_ServicingTransaction]

INSERT INTO [IO].[IN_ServicingTransaction] ([NoteID],[TransactionType],[TransactionDate],[DateDue],[PrincipalPayment],[InterestPayment])
Select [NoteID],[TransactionType],[TransactionDate],[DateDue],[PrincipalPayment],[InterestPayment] 
from @tblServicingTransaction 
where [NoteID] in 
(
	Select CRENoteID from cre.note n
	inner join core.Account acc on n.account_accountid = acc.accountid 
	where acc.StatusID = @Active and Servicer = @ServicerWellsFargo and acc.IsDeleted=0
)
and DateDue between @StartDate and @EndDate
--and [TransactionType] in ('02','04')  

--Calling main procedure (Import Landing to main table)
EXEC [dbo].[usp_ImportServicingDataFromLandingToServicingLog] @CreatedBy , @FileName ,@OriginalFileName,@storagetype,@StartDate,@EndDate


END


