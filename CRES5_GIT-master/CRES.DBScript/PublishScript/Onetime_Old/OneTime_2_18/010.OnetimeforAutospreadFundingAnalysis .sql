Update cre.deal set enableautospread = 0 where credealid in (
'15-0461','15-0618','16-0426','16-1024','16-1585','17-0010','17-0044','17-0149','17-0542','17-0916','17-1123','17-1439','17-1453','17-1464','17-1643','17-1714','17-1810','18-0058','18-0099','18-0293','18-0296','18-0331','18-0345','18-0358','18-0409','18-0441','18-0572','18-0602','18-0923','18-0989','18-1043','18-1059','18-1313','18-1499','18-1536','18-1747','18-1818','18-1833','18-1854','18-1911','18-2131','18-2132','18-2385','18-2463','19-0036','19-0039','19-0182','19-0293','19-0349','19-0369','19-0378','19-0463','19-0532','19-0582','19-0583','19-0604','19-0747','19-0869','19-0870','19-0946','19-0988','19-1050','19-1087','19-1131','19-1166','19-1208','19-1259','19-1265','19-1324','19-1391','19-1433','19-1471','19-1555','19-1571','19-1647','19-1655','19-1827','19-2314','19-2668','20-0429','20-0512','20-0514','20-0687','20-0846','20-0884','20-0921','20-0980','20-0992','20-1044','20-1081','20-1152','20-1170','20-1194','20-1255','20-1319','20-1357','20-1401','20-1589','20-1672','20-1680','20-1687','20-1700','21-0117','21-0122','21-0408','21-0526','21-0595','21-0724','21-0754','21-0891','21-1799','21-1812','21-1812X'
)


go


Delete from [CRE].[AutoSpreadRule] where dealid in (
	Select Distinct d.dealid
	from cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.Deal d on n.DealID = d.DealID
	inner join [CRE].[DealFunding] df on d.dealid = df.dealid
	where n.ActualPayoffdate is null 
	and acc.IsDeleted <> 1 and d.isdeleted <> 1
	and UseRuletoDetermineNoteFunding = 3	
	and d.Status = 323
	and df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
	and d.dealid not in (Select dealid from cre.deal where enableautospread = 1)
	and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
)

go


INSERT INTO [CRE].[AutoSpreadRule]
([DealID]
,[PurposeType]
,[DebtAmount]
,RequiredEquity
,AdditionalEquity
,[StartDate]
,[EndDate]
,[DistributionMethod]
,[FrequencyFactor]
,[Comment]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate])


SELECT   df.DealID
	    ,df.PurposeID as [Purpose Type]	   
	    ,sum(Amount) as [Debt Amount]
		,sum(RequiredEquity) as RequiredEquity
		,sum(AdditionalEquity) as AdditionalEquity       
	   
	    ,ISNULL(tbldfMaxDate.min_unlock_date,getdate()) as [Start Date]
        ,dbo.Fn_GetnextWorkingDays(tblCurrmat.currMaturityDate,-1,'PMT Date')  as [End Date]

	    ,609 as [Distribution Method]
	    ,1 as [Frequency Factor]
		,null [Comment]
		,'B0E6697B-3534-4C09-BE0A-04473401AB93' as [CreatedBy]
		,getdate() as [CreatedDate]
		,'B0E6697B-3534-4C09-BE0A-04473401AB93' as [UpdatedBy]
		,getdate() as [UpdatedDate]
	  
FROM [CRE].[DealFunding] df 
inner join cre.Deal d on d.DealID = df.DealID
left join [Core].[Lookup] l on df.PurposeID = l.LookupID 
Left JOin(
	Select d.dealid, DateAdd(day,-1,MAX(ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) ) ) as currMaturityDate
	from cre.note n1
	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	inner join cre.deal d on d.dealid = n1.dealid
	Left Join(
		Select noteid,MaturityType,MaturityDate,Approved
		from (
				Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
				ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11 and eve.StatusID = 1					
					and acc.IsDeleted = 0  
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where mat.MaturityDate > getdate()
				and lApproved.name = 'Y'
		)a where a.rno = 1
	)currMat on currMat.noteid = n1.noteid
	where acc1.IsDeleted <> 1	
	group by d.dealid
)tblCurrmat on tblCurrmat.dealid = d.dealid

Left Join(
	Select df.dealid,df.purposeid,MIN(date) as min_unlock_date
	FROM [CRE].[DealFunding] df 
	inner join cre.Deal d on d.DealID = df.DealID
	WHERE  df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
	and nullif(df.comment,'') is null
	and df.applied <> 1
	group by df.dealid,df.purposeid
)tbldfMaxDate on tbldfMaxDate.dealid = df.dealid and tbldfMaxDate.purposeid = df.purposeid

WHERE  df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
and df.DealID IN (
	Select Distinct d.dealid
	from cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.Deal d on n.DealID = d.DealID
	inner join [CRE].[DealFunding] df on d.dealid = df.dealid
	where n.ActualPayoffdate is null 
	and acc.IsDeleted <> 1 and d.isdeleted <> 1
	and UseRuletoDetermineNoteFunding = 3	
	and d.Status = 323
	and df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
	and d.dealid not in (Select dealid from cre.deal where enableautospread = 1)
	and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
	--and d.dealname = 'Village Park at Alpharetta'
)
	
Group By   df.DealID, df.PurposeID, l.name,tblCurrmat.currMaturityDate,tbldfMaxDate.min_unlock_date
Order By DealID, [Purpose Type] ASC


go

Update cre.deal set enableautospread = 1 where dealid in (
	Select Distinct d.dealid
	from cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.Deal d on n.DealID = d.DealID
	inner join [CRE].[DealFunding] df on d.dealid = df.dealid
	where n.ActualPayoffdate is null 
	and acc.IsDeleted <> 1 and d.isdeleted <> 1
	and UseRuletoDetermineNoteFunding = 3	
	and d.Status = 323
	and df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
	and d.dealid not in (Select dealid from cre.deal where enableautospread = 1)
	and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
)

