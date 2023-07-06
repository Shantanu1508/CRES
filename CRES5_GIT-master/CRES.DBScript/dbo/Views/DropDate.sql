CREATE View [dbo].[DropDate]
	As
	Select 
	distinct
		X.CRENoteID
		
		,X.Date
		--, Y.date
		----, z.date
		, ActualPayoffDate
		, Amount
			, Y.IntafterDropDate CurrentPeriodIntadj
		--, NextPeriodIntAdj = Case when ActualPayoffdate = x.Date 
		--and Day (x.Date)  > Day(FirstPaymentDate) then 0
											--else z.IntafterDropDate  end
		,z.IntafterDropDate NextPeriodIntAdj
		, Case 
		when ActualPayoffdate = x.Date and Day (x.Date)  > Day(FirstPaymentDate)
		THEN X.Amount + ISNULL(z.IntafterDropDate,0)
		
		When X.Date = ActualPayoffDate then (X.Amount + ISNULL(Z.IntafterDropDate,0))
		When ABS(DateDIff(n, Z.date , ActualPayoffDate)) < 1 Then 0
			
			Else  (X.Amount- ISNULL(Y.IntafterDropDate,0)+ ISNULL(Z.IntafterDropDate,0)) 
			End  as ExpectedInterestAfterDropdate 
		, FirstPaymentDate
		from
	(

		Select 
		T.CRENoteID
		,T.Date

		, SUM(Amount)Amount
		--, DateBi= Case when date = '10/8/2018' then '10/5/2018' else Date end
		--, Type
		, MAX(AnalysisID)AnalysisID

		from Dw.Staging_TransactionEntry t 
		where Type in ('InterestPaid') and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
			Group By CRENoteID, T.Date
		) X

			Outer Apply 
			(Select D2.date, D2.InterestAfterDropdate IntafterDropDate from DropdateInterim3 D2
						Inner join Note N on N.NoteID = D2.CRENoteID 
						
					Where X.CRENoteID = D2.CRENoteID and X.Date> D2.date and 
				
					X.Date <= eomonth(Dateadd (month, 1,d2.date),0)  
					
					
					)Z
			
		Outer Apply (Select D2.date, D2.InterestAfterDropdate IntafterDropDate from DropdateInterim3 D2

					Inner join Note N on N.NoteID = D2.CRENoteID 
					Where X.CRENoteID = D2.CRENoteID and X.Date= D2.date and
					x.Date < eomonth (d2.date,1)   
					--and (d2.date<> ActualPayoffDate and isnull(InterestAfterDropdate,0) <> 0)
					)y
				Inner join Note N On N.NoteID =  X.CRENoteID
		Where  AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		 --and ISNULL(Z.date,'') <> ISNULL(ActualPayoffDate,'')
		--and X.CRENoteID = '1311'  

		--and( ISNULL(x.Date,'') <>  ISNUll(ActualPayoffDate,'') and ISNULL(z.IntafterDropDate,0) <> 0)

--	--order by Date
--relealized and fubded 

--	exec dw.usp_deltajob 
