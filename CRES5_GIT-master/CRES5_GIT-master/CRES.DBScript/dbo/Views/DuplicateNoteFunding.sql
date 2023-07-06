 CREATE view [dbo].[DuplicateNoteFunding]
As
Select Distinct CredealID, CreNoteid, DealName from 
(
Select
D.DealID 
, X.CredealID
,X.DealID NoteLevelDealID
, D.Date Deal_Date
, D.Amount Deal_AMount
--, D.Wireconfirm Deal_Wireconfirm
, D.Purposeid Deal_PurposeID
, D.Comment Deal_Comments
, X.CreNoteid
, X.Date Note_Date
, X.Amount Note_Amount
, X.Wireconfirm Note_Wireconfirm
, X.Purposeid Note_PurposeID
, X.Comments Note_Comments
, DealName
  from [DW].[DealFundingSchduleBI]D
Right Join (Select  
			N.crenoteid
			, N1.Dealid
			, D1.CreDealID
			, Date
			, AMount
			, Purposeid
			, Wireconfirm
			, N.Comments
			, UseRuletoDetermineNoteFunding
			, DealName 
			from [DW].[NoteFundingScheduleBI] N
			left Join dw.NoteBI N1 on n1.Crenoteid  = N.Crenoteid
			Inner join Dw.DealBI D1 on D1.DealID =  N1.DealID 
			)X
			On D.DealID = X.DealID and D.Date = X.Date
			where D.DealID is null and X.Amount >  0

			and CreNoteid in (Select Distinct CreNoteid from [DW].[FundingSequencesBI]
								Where SequenceTypeBI = 'Funding sequence'
								and Value <>0 )
								and UseRuletoDetermineNoteFunding = 3


	Union


	Select
D.DealID DealID1
,X.CredealID
,X.DealID NoteLevelDealID
, D.Date Deal_Date
, D.Amount Deal_AMount
--, D.Wireconfirm Deal_Wireconfirm
, D.Purposeid Deal_PurposeID
, D.Comment Deal_Comments
, X.CreNoteid
, X.Date Note_Date
, X.Amount Note_Amount
, X.Wireconfirm Note_Wireconfirm
, X.Purposeid Note_PurposeID
, X.Comments Note_Comments
, DealName
  from [DW].[DealFundingSchduleBI]D
Right Join (Select  N.crenoteid, N1.Dealid,D1.CreDealID, Date, AMount, Purposeid, Wireconfirm, N.Comments
			, UseRuletoDetermineNoteFunding, DealName
			from [DW].[NoteFundingScheduleBI] N
			left Join dw.NoteBI N1 on n1.Crenoteid  = N.Crenoteid
			Inner join Dw.DealBI D1 on D1.DealID =  N1.DealID 
			)X
			
			On D.DealID = X.DealID and D.Date = X.Date
			where D.DealID is null and X.Amount <  0

			and CreNoteid in (Select Distinct CreNoteid from [DW].[FundingSequencesBI]
								Where SequenceTypeBI = 'Repayment sequence'
								and Value <>0 )
								and UseRuletoDetermineNoteFunding = 3
								)x

