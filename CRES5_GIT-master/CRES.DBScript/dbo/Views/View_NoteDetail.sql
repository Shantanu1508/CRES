
CREATE VIEW [dbo].[View_NoteDetail] 
AS 
       
SELECT  
d.DealName,
d.CreDealID AS DealID,  
[DealStatusBI] as [DealStatus],     
n.[CRENoteID] as NoteID, 
n.M61Commitment,    
n.M61AdjustedCommitment,
tblCurrNPC.EndingBalance as[CurrentBalance],
tblTR.m61interest ,
ServicerBalance,
ServicerInterestRate,
SericerCurrentPaidToDate
      
FROM [DW].[NoteBI] n  
Left join dw.dealBI d on d.dealid = n.dealid
Left Join(    
	Select noteid,EndingBalance from(    
		Select n.noteid,EndingBalance ,ROW_NUMBER() Over(Partition by n.noteid order by n.noteid,PeriodEndDate desc) rno    
		from dw.NotePeriodicCalcBI nc
		inner join dw.notebi n on n.noteid =nc.noteid 
		where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'     
		and EndingBalance is not null     
		and PeriodEndDate <= Cast(getdate() as Date)  
		and nc.AccountTypeID = 1
	)a where rno = 1    
)tblCurrNPC on tblCurrNPC.NoteID = n.NoteID  
Left Join(
	Select Noteid,sUM(amount) as m61interest from dW.TransactionEntryBI T 
	where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F' 
	and [Type] in ('SpreadPercentage','LIBORPercentage')
	and T.AccountTypeID= 1
	group by Noteid
)tblTR   on tblTR.NoteID = n.NoteID  
left join(

Select NoteId,ServicerBalance,ServicerInterestRate,SericerCurrentPaidToDate
From(

	SELECT a.NoteId,WDT.[Balance_After_Funding_Transacton] as [ServicerBalance]
	,WDT.Current_All_In_Interest_Rate as [ServicerInterestRate]
	,WDT.Current_Interest_Paid_To_Date as [SericerCurrentPaidToDate]
	FROM [dbo].[WellsDataTap] WDT
	inner Join(
		SELECT wd.NoteId, wd.TransactionDate, MAX(Entry_no) as Entry_no 
		FROM [dbo].[WellsDataTap] WD 
		Inner JOIN 
		(
			SELECT NoteId,MAx(TransactionDate) as TransactionDate 
			FROM WellsDataTap WDT
			group by noteid
		) SW ON SW.NoteId = WD.NoteId and SW.TransactionDate = WD.TransactionDate

		group by wd.NoteId, wd.TransactionDate
	)a ON WDT.noteid = a.NoteId and a.Entry_no = WDT.Entry_No and a.TransactionDate = WDT.TransactionDate

	uNION

	Select NoteId	,	
	BKD.Principal_Balance as ServicerBalance,
	BKD.[Interest_Rate] as ServicerInterestRate	,
	(CASE WHEN (CB.isholidayBI = 1 OR CB.IsWeekend = 1)
	THEN DATEADD(Day, -1, DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt]))
	ELSE DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt]) END) as SericerCurrentPaidToDate
	From [dbo].[BerkadiaDataTap] BKD
	INNER JOIN [dbo].[Calendar] CB ON CB.[Date] = DATEADD(Month, -1, BKD.[Next_Pmt_Due_Dt])

)tblsvr

)svr on svr.noteid = n.crenoteid