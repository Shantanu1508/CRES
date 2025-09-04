-- Procedure


CREATE Procedure [dbo].[usp_CalculateStatus]
@crenoteid nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;


if(@crenoteid<>'')
BEGIN
	
	CREATE TABLE #tblListNotes(
		CRENoteID VARCHAR(256)
	)
	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@crenoteid);

END;


declare @countNotes  int =  (select cOUNT(CRENoteID) from #tblListNotes);
declare @Notecount int = 0

	
While @Notecount <> @countNotes
Begin 
	WAITFOR DELAY '00:04'
	Set @Notecount  = (select count(*) from
		(
		Select Crenoteid,  StatusID, Analysisid,Errormessage  
		from [Core].[CalculationRequests] C
		Inner join Cre.Note N on N.Account_AccountID = C.AccountId
		Where creNoteid in (select CRENoteID from #tblListNotes)  
		and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		and Statusid in (265,266) and CalcType = 775
		)x
	)
end

select ST.Noteid, T.Date, T.Type, T.Amount, (ISNULL(St.Amount, 0) - ISNULL(T.Amount, 0))Delta , L.Name 
from cre.TransactionEntry T 
Inner Join core.account acc on acc.accountid =T.accountID
Inner Join cre.note n on n.account_accountid = acc.accountid
Left join dbo.Staging_TransactionEntry ST on n.Noteid = ST.Notekey and T.Date=  St.Date and T.Type = st.type
LEFT JOIN [Core].[CalculationRequests] C ON C.AccountId = n.Account_AccountID AND c.analysisid = t.analysisid and C.CalcType = 775
		
Inner join core.lookup l on l.lookupid = c.statusid
where T.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
and st.Noteid in (select (CRENoteID) from #tblListNotes) and(ISNULL(St.Amount, 0) - ISNULL(T.Amount, 0)) <> 0

End