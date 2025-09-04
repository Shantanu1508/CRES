 

--CREATE VIEW [dbo].[view_RH_NoteEntityBackshop]
--AS

--Select 
--RTRIM(LTRIM(cm.ControlId)) as DealID,
--RTRIM(LTRIM(cm.DealName)) as DealName ,
--RTRIM(LTRIM(n.NoteId)) as [NoteID],
--RTRIM(LTRIM(n.NoteName)) as [NoteName],
--RTRIM(LTRIM(fs.FinancingSourceDesc)) as [FinancingSource],
--REPLACE(RTRIM(LTRIM(rt.RateTypeDesc)),'ARM','Floating') as [RateType],

--CAST(ROUND(van.[OrigLoanAmount],2) as decimal(28,2)) as [InitialFunding],
----van.TotalCommitment as [OriginalCommitmentAmount],
--CAST(ROUND(van.[Current UPB],2) as decimal(28,2)) as [CurrentUPB],
--CAST(ROUND(van.TotalCurrentAdjustedCommitment,2) as decimal(28,2)) as [CurrentCommitment],
--LLienPositionCd_F.LienPositionDesc as [LienPosition],
--n.[Priority] as [Priority],
--nv.AmortIOPeriod as [IOTerm],
--RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(nv.IndexName,'1 Month LIBOR','1M LIBOR') ,'6 Month LIBOR','6M LIBOR') ,'3 Month LIBOR','3M LIBOR'),'SOFR 1 Month Term','1M USD SOFR') )) as [IndexName],

--van.InterestSpread  as [CurrentSPREAD],
--ISNULL(CAST(nv.InterestRateFloorPct as decimal(28,9)),0) as [CurrentFloorPercent],
--null as [Current Interest Rate],

--CAST(ISNULL(nv.OriginationFeePct,0) as decimal(28,9)) as [OriginationFeePercent],

--(CASE WHEN van.StatedMaturityDate >= Cast(getdate() as date) THEN van.StatedMaturityDate ELSE tblmat.ExtStatedMaturityDate END) as [CurrentMaturity],

--ISNULL(ne.ExtStatedMaturityDate, van.StatedMaturityDate) as [FullyExtendedMaturityDate],

--van.IntCalcMethodDesc as DayCountinthecalculator,
--ISNULL(van.DeterminationDate,0) as PaymentDate,
--iSNULL(tblPIK.PIKBls,0) as PIKBalance,
--n.FundingDate as OriginationDate,

----tblloantype.CollateralStatusDesc as LoanType,
--cs.[CollateralStatusDesc] as LoanType,

----ptm.PropertyTypeMajorDesc as PropertyType,
--tblPro.PropertyTypeMajorDesc as PropertyType,

--tblPro.City as City,
--tblPro.State as [State], 

--REPLACE(tblPro.MSA_NAME,',','-') as MSA_NAME,
--tblInq.StatusStartDate as InquiryDate



--from dbo.EX_RH_tblNote n
--left join [EX_RH_tblzCdLienPosition] LLienPositionCd_F on LLienPositionCd_F.LienPositionCd = n.LienPositionCd_F
--Left Join dbo.EX_RH_tblzcdFinancingSource fs on fs.FinancingSourceCD = n.FinancingSource
--Left Join dbo.EX_RH_tblzCdRateType rt on rt.RateTypeCode = n.RateTypeCd_F
--Left Join dbo.EX_RH_viewNote nv on nv.NoteId = n.NoteId
--Left Join (
--	Select Distinct ControlId,NoteId,NoteName,FundingDate,TotalCommitment,TotalCurrentAdjustedCommitment,[Current UPB],FirstPIPaymentDate,StatedMaturityDate,
--	OrigLoanAmount,OriginationFee,LiborFloor,OriginationFeePct,InterestSpread,AmortIOPeriod,AmortizationTerm,PaymentFreqCd_F,PaymentFreqDesc,IntCalcMethodDesc,
--	LienPosition,[Priority],AccrualRate,DeterminationMethodDay,DeterminationDate,RoundingType,RoundingDenominator,FinancingSourceDesc,InvestorName,Servicer,Fund
--	from [EX_RH_vw_AcctNote] 
--)van on van.NoteID = n.NoteID

--Left Join (
--	Select NoteID_F,MAX(ExtStatedMaturityDate) as ExtStatedMaturityDate 
--	from dbo.EX_RH_vw_AcctNoteExt
--	Group by NoteID_F
--) ne on ne.NoteId_F = n.NoteId

--left join [dbo].[EX_RH_tblControlMaster] cm on cm.ControlId = n.ControlId_F
-----left join dbo.[EX_RH_tblzCdPropertyTypeMajor] ptm on ptm.PropertyTypeMajorCd = cm.REITPropertyTypeCd_F
--left join dbo.EX_RH_tblzCdCollateralStatus cs on cs.CollateralStatusCD = cm.CollateralStatusCd_F

--left JOin(
--	select NOteID_F,SUM(FUndingAmount)  as PIKBls 
--	from [dbo].[EX_RH_tblNoteFunding]
--	where FundingPurposeCD_F in ('PIKNC','PIKPP')	and [FundingDate] <=  Cast(getdate() as Date)
--	group by NOteID_F
--)tblPIK on tblPIK.NOteID_F = n.noteid
----left Join(

----	Select a.ControlId, a.StatusDate, a.CollateralStatusDesc
----	From(
----		select cm.ControlId, dh.StatusDate, colstat.CollateralStatusDesc ,ROW_NUMBER() Over (Partition by cm.ControlId order by cm.ControlId,dh.StatusDate) RowNo
----		from [EX_RH_tblDealHistory] dh
----		join [dbo].[EX_RH_tblControlMaster] cm on dh.ControlId_F = cm.ControlId
----		join [EX_RH_tblzCdCollateralStatus] colstat on dh.ColumnValue = colstat.CollateralStatusCD
----		where ColumnName = 'collateralstatuscd_f'	
----		and cast(dh.StatusDate as date) <= '8/31/2021'
----	)a
----	where a.RowNo = 1
----)tblloantype on tblloantype.ControlId = cm.ControlId


--Left Join( 
	 
--	Select ControlId_F,PropertyTypeMajorDesc,DealAllocationAmt,City,State,MSA_NAME
--	From(
--		Select ControlId_F,l.PropertyTypeMajorDesc,p.DealAllocationAmt,p.City,p.State ,z.MSA_NAME,
--		ROW_NUMBER() Over(Partition by ControlId_F order by ControlId_F,DealAllocationAmt desc) as rno
--		from dbo.[EX_RH_tblProperty] p
--		left join dbo.[EX_RH_tblzCdPropertyTypeMajor] l on l.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F
--		left join dbo.[EX_RH_tblzCDZipCode] z on z.ZIP_CODE = p.ZipCode
--		left join dbo.[EX_RH_tblPropertyExp] px on px.PropertyId_F = p.PropertyId
--		where px.PropertyRollupTypeId_F = 2		
--	)a where a.rno = 1 
--)tblPro on tblPro.ControlId_F  = cm.ControlId

--left join(
--	Select ControlId_F,MIN(StatusStartDate) as StatusStartDate 
--	from dbo.[EX_RH_tblStatusLog] 
--	where LoanStatusCD_F = 'I' 
--	group by ControlId_F
--)tblInq on tblInq.ControlId_F = cm.ControlId

--Left Join(
--	Select NoteId_F,NoteExtensionId,ExtStatedMaturityDate
--	From(
--		Select NoteId_F,NoteExtensionId,ExtStatedMaturityDate,ExecutedSw,
--		ROW_NUMBER() Over(Partition by NoteId_F order by NoteId_F,NoteExtensionId) as rno
--		from dbo.[EX_RH_vw_AcctNoteExt]
--		where ExtStatedMaturityDate >= Cast(getdate() as date)
--	)a
--	where a.rno = 1
--)tblmat on tblmat.NoteId_F = n.noteid


--left join(
--	Select n.crenoteid from cre.note n
--	inner join core.Account acc on acc.accountid = n.account_accountid
--	inner join cre.deal d on d.dealid = n.dealid
--	where acc.isdeleted <> 1 and n.actualpayoffdate is not null
--	and  d.status <> 325
--	and ISNUMERIC(n.crenoteid)= 1
--)tblpaidoff on tblpaidoff.crenoteid = n.noteid

--Left Join [dbo].[EX_RH_tblzCdLoanStatus] ls on ls.LoanStatusCd = cm.LoanStatusCd_F

--where tblpaidoff.crenoteid is null
--and ls.[LoanStatusDesc] in ('Funded', 'Securtized / Sold (partial)' ,'Paid Off')
--and fs.FinancingSourceDesc not in ('3rd Party Owned','Co-Fund')
--and cm.DealName not like 'sop%'