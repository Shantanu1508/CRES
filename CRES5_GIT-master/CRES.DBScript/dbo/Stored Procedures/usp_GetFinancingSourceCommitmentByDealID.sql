--		[dbo].[usp_GetFinancingSourceCommitmentByDealID] 'b0d68793-ba74-4097-8349-8e837711b70f'

CREATE PROCEDURE [dbo].[usp_GetFinancingSourceCommitmentByDealID]
	@dealID nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
 
	Select ClientName,
	Sum(NoteTotalCommitment) / Deal_M61TotalCommitment as 'ParticipationPerc',
	Sum(NoteTotalCommitment_ExcludeThirdParty) / Deal_M61TotalCommitment_ExcludeThirdParty as 'PariPassuPerc',
	Sum(InitialFundingAmount) /SUM(OriginalTotalCommitment) as 'InitialFundingPerc',
	Sum(InitialFundingAmount) as InitialFundingAmount,
	
	Sum(EndingBalance) as 'EstimatedCurrentBalance', 
	SUM(NoteAdjustedTotalCommitment) as 'AdjustedCommitment', 
	Sum(OriginalTotalCommitment) as 'CommitmentAtClosing',
	Sum(NoteTotalCommitment) as 'M61TotalCommitment'
	
	from (
		Select D.DealID, N.CRENoteID, N.ClosingDate,d.CreDealID,d.DealName,Cl.ClientName, tblUPB.EndingBalance, 
		N.OriginalTotalCommitment, NAdj.NoteAdjustedTotalCommitment ,ISNULL(n.InitialFundingAmount,0) as InitialFundingAmount
		,NAdj.NoteTotalCommitment
		,(CASE WHEN Cl.IsThirdParty = 1 THEN 0 ELSE NAdj.NoteTotalCommitment END) as NoteTotalCommitment_ExcludeThirdParty
		--,Cl.IsThirdParty		
		,Sum((CASE WHEN Cl.IsThirdParty = 1 THEN 0 ELSE NAdj.NoteTotalCommitment END)) Over (Partition By D.DealID) as Deal_M61TotalCommitment_ExcludeThirdParty
		,Sum(NAdj.NoteTotalCommitment) Over (Partition By D.DealID) as Deal_M61TotalCommitment

		from CRE.Note N 
		INNER JOIN Core.Account accN ON accN.AccountID = N.Account_AccountID
		INNER JOIN Cre.Deal D ON D.DealID = N.DealID
		LEFT JOIN CRE.Client Cl ON Cl.ClientID = n.ClientID
 
		LEFT JOIN(    
			Select NoteID,EndingBalance from(    
				Select n1.NoteID,ISNULL(nc.EndingBalance, 0) as EndingBalance ,ROW_NUMBER() Over(Partition by n1.noteid order by n1.noteid, nc.PeriodEndDate desc) rno    
				from cre.NotePeriodicCalc nc
				inner join cre.note n1 on n1.Account_AccountID = nc.AccountID 
				Inner join core.account acc on acc.AccountID = n1.Account_AccountID
				where acc.IsDeleted <> 1
				and nc.Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
				and N1.ActualPayoffDate IS NULL
				and nc.PeriodEndDate <= Cast(getdate() as Date)  
			)a where rno = 1    
		)tblUPB on tblUPB.NoteID = N.NoteID  
 
		LEFT JOIN (
			Select NoteID,NoteAdjustedTotalCommitment, NoteTotalCommitment
			From(			
				SELECT n2.NoteID
				,[Date]
				,nd.Type as Type
				,NoteAdjustedTotalCommitment
				,NoteTotalCommitment
				,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno
				from cre.NoteAdjustedCommitmentMaster nm
				left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
				right join cre.deal d2 on d2.DealID=nm.DealID
				Right join cre.note n2 on n2.NoteID = nd.NoteID
				inner join core.account acc on acc.AccountID = n2.Account_AccountID
				where d2.IsDeleted<>1 and acc.IsDeleted<>1
				and CAST(nm.[Date] AS Date) <= Cast(getdate() as Date)  
			)a
			where rno = 1
		) NAdj ON NAdj.NoteID = N.NoteID
 
 
		Where accN.IsDeleted<> 1		
		AND D.DealID=@dealID
	) Res 
	Group By ClientName, Deal_M61TotalCommitment,Deal_M61TotalCommitment_ExcludeThirdParty
	Order By ClientName
END