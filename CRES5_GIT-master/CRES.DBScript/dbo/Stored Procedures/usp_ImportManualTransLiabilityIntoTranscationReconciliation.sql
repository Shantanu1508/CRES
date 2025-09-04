-- Procedure

    
--[dbo].[usp_ImportManualTransIntoTranscationReconciliation] 2297,'c10f3372-0fc2-4861-a9f5-148f1f80804f'    
    
CREATE PROCEDURE [dbo].[usp_ImportManualTransLiabilityIntoTranscationReconciliation]     
(    
 @Batchlogid int,    
 @ScenarioId varchar(100)    
)    
AS    
BEGIN    
    
    
    DECLARE @uploadedby varchar(250)    
    DECLARE @ignoredrows int,@TotalRowsCount int,@rowsinTrans int,@successmsg varchar(250),@ServicerMasterID int    
    SELECT @uploadedby=CreatedBy FROM [IO].[FileBatchLogLiability] WHERE BatchLogID=@Batchlogid    
    
    SELECT @ServicerMasterID=ServcerMasterID FROM [IO].[FileBatchLogLiability] WHERE BatchLogID=@Batchlogid    
  
INSERT INTO [CRE].[TransactionAuditLogLiability]
           ([BatchLogID]
           ,[LiabilityAccountID]
           ,[TransactionMode]
           ,[DealAccountID]
           ,[NoteAccountID]
           ,[TransactionType]
           ,[DueDate]
           ,[RemitDate]
           ,[ServicingAmount]
           ,[Status]
           ,[ServicerMasterID]
           ,[TransactionDate]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

            SELECT     
    @Batchlogid,
    ac.AccountID,
    mt.TransactionMode,
   null,
   null,
    mt.ValueType,     
    mt.DueDate,
    mt.RemitDate,
    isNull(mt.Value,0) as ServicingAmount,    
    'Imported',      
    @ServicerMasterID,     
    mt.DueDate,   
    @uploadedby,
    getdate(),
    @uploadedby,
    getdate()
    from IO.[L_ManualTransactionLiability] mt 
    join core.Account ac on mt.LiabilityName=ac.Name
    where FileBatchlogid= @Batchlogid  
    and mt.TransactionMode='Portfolio'
    
    union
    
    SELECT     
    @Batchlogid,
    ac.AccountID,
    mt.TransactionMode,
    acd.AccountID,
    n.Account_AccountID,
    mt.ValueType,     
    mt.DueDate,
    mt.RemitDate,
    isNull(mt.Value,0) as ServicingAmount,    
    'Imported',      
    @ServicerMasterID,     
    mt.DueDate,   
    @uploadedby,
    getdate(),
    @uploadedby,
    getdate()
    from IO.[L_ManualTransactionLiability] mt 
    join core.Account ac on mt.LiabilityName=ac.Name
    join cre.Deal d on d.CREDealID=mt.CREDealID
    join core.Account acd on acd.Name=d.DealName
    join cre.Note n on n.CRENoteID=mt.CRENoteID
    where FileBatchlogid= @Batchlogid  
    and mt.TransactionMode='Deal Level'

    --marke  data as already Reconcilled
    update ta set ta.Status='Data already Reconcilled.'       
    from cre.TransactionAuditLogLiability ta     
    inner join cre.TransactionReconciliationLiability tr on 
    tr.LiabilityAccountID=ta.LiabilityAccountID and 
    tr.DateDue=ta.DueDate and     
    tr.TransactionType=ta.[TransactionType]  and     
    isnull(tr.RemittanceDate,getdate())=isnull(ta.RemitDate,getDate()) and    
    tr.TransactionDate=ta.TransactionDate and    
    ta.ServicerMasterID=tr.ServcerMasterID    
    where tr.posteddate is not null     
    and ta.Batchlogid = @Batchlogid
    and ta.TransactionMode='Portfolio'
    and tr.Ignore <> 1    
    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')     


    update ta set ta.Status='Data already Reconcilled.'       
    from cre.TransactionAuditLogLiability ta     
    inner join cre.TransactionReconciliationLiability tr on 
    tr.LiabilityAccountID=ta.LiabilityAccountID and 
    tr.DateDue=ta.DueDate and     
    tr.TransactionType=ta.[TransactionType]  and     
    isnull(tr.RemittanceDate,getdate())=isnull(ta.RemitDate,getDate()) and    
    tr.TransactionDate=ta.TransactionDate and    
    ta.ServicerMasterID=tr.ServcerMasterID
    join core.Account ac on tr.LiabilityAccountID=ac.AccountID
    join core.Account acd on tr.DealAccountID=acd.AccountID
    join core.Account acn on tr.NoteAccountID=acn.AccountID
    where tr.posteddate is not null     
    and ta.Batchlogid = @Batchlogid
    and ta.TransactionMode='Deal Level'
    and tr.Ignore <> 1    
    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Reimported','Due date is lower than accounting close date.')     


    --marke  data as reimported

    update ta set ta.Status='Reimported'       
    from cre.TransactionAuditLogLiability ta     
    inner join cre.TransactionReconciliationLiability tr on 
    tr.LiabilityAccountID=ta.LiabilityAccountID and 
    tr.DateDue=ta.DueDate and     
    tr.TransactionType=ta.[TransactionType]  and     
    isnull(tr.RemittanceDate,getdate())=isnull(ta.RemitDate,getDate()) and    
    tr.TransactionDate=ta.TransactionDate and    
    ta.ServicerMasterID=tr.ServcerMasterID    
    where tr.posteddate is null     
    and ta.Batchlogid = @Batchlogid
    and ta.TransactionMode='Portfolio'
    and tr.Ignore <> 1    
    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Reimported','Due date is lower than accounting close date.')     


    update ta set ta.Status='Reimported'       
    from cre.TransactionAuditLogLiability ta     
    inner join cre.TransactionReconciliationLiability tr on 
    tr.LiabilityAccountID=ta.LiabilityAccountID and 
    tr.DateDue=ta.DueDate and     
    tr.TransactionType=ta.[TransactionType]  and     
    isnull(tr.RemittanceDate,getdate())=isnull(ta.RemitDate,getDate()) and    
    tr.TransactionDate=ta.TransactionDate and    
    ta.ServicerMasterID=tr.ServcerMasterID
    join core.Account ac on tr.LiabilityAccountID=ac.AccountID
    join core.Account acd on tr.DealAccountID=acd.AccountID
    join core.Account acn on tr.NoteAccountID=acn.AccountID
    where tr.posteddate is null     
    and ta.Batchlogid = @Batchlogid
    and ta.TransactionMode='Deal Level'
    and tr.Ignore <> 1    
    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Reimported','Due date is lower than accounting close date.')     


    --insert fresh data to TransactionReconcilationLiability

INSERT INTO [CRE].[TransactionReconciliationLiability]
           ([DateDue]
           ,[RemittanceDate]
           ,[ServcerMasterID]
           ,[LiabilityAccountID]
           ,[TransactionMode]
           ,[DealAccountID]
           ,[NoteAccountID]
           ,[TransactionType]
           ,[TransactionDate]
           ,[ServicingAmount]
           ,[BatchLogID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
          )
    
    select 
            [DueDate]
           ,[RemitDate]
           ,[ServicerMasterID]
           ,[LiabilityAccountID]
           ,[TransactionMode]
           ,[DealAccountID]
           ,[NoteAccountID]
           ,[TransactionType]
           ,[DueDate]
           ,[ServicingAmount]
           ,[BatchLogID]
           ,@uploadedby     
           ,GETDATE()      
           ,@uploadedby      
           ,GETDATE() 
           from cre.TransactionAuditLogLiability where BatchLogID=@Batchlogid
           and [Status] = 'imported'





--   INSERT into cre.TransactionAuditLogLiability(BatchLogID,NoteID,TransactionType,DueDate,ServicingAmount,Status,ServicerMasterID,TransactionDate,RemitDate)    --,ReconFlag
     
      
   
   
   
--   -- Update IO.[L_ManualTransaction] Set  CapitalizedInterest =null,CashInterest =NULL where ValueType <> 'InterestPaid'

--    Update IO.[L_ManualTransactionLiability] SET IO.[L_ManualTransactionLiability].NoteIDGuid = a.noteid
--    --,IO.[L_ManualTransaction].ReconFlag = (case when ValueType='InterestPaid' THEN 'InterestPaid' when ValueType='ScheduledPrincipalPaid' THEN 'ScheduledPrincipalPaid' when ValueType in ('ExitFee','PrepaymentFee','ExtensionFee','UnusedFee') THEN 'Fee' ELSE 'OtherFee' END)
--    From(
--        select n.crenoteid,n.noteid 
--        from cre.Note n   
--        inner join IO.[L_ManualTransactionLiability] mt on n.crenoteid=mt.NoteId  
--        Inner Join core.Account acc on acc.AccountID = n.Account_AccountID  
--        where acc.IsDeleted <> 1 
--    )a
--    where IO.[L_ManualTransactionLiability].noteid = a.crenoteid
    
  
--    --drop  TABLE #TempTransactionEntry  
  
--    --Select * from IO.[L_ManualTransaction] where FileBatchLogid=2542  
--    --Select *  from cre.TransactionAuditLogLiability where BatchLogid=2542  
  
--    --============================Delete Duplicate Records========================  
--    --declare @Batchlogid int=2541,@ServicerMasterID int   
--    -- SELECT @ServicerMasterID=ServcerMasterID FROM [IO].[FileBatchLog] WHERE BatchLogID=@Batchlogid   
--    ;WITH CTE AS(  
--        SELECT NoteID,ValueType,Value,DueDate,RemitDate,TransDate,  
--        RN = ROW_NUMBER()OVER(PARTITION BY NoteID,DueDate, ValueType, RemitDate,TransDate  
--        order by NoteID,DueDate, ValueType, RemitDate, TransDate)  
--        FROM IO.[L_ManualTransactionLiability]  where FileBatchLogid=@Batchlogid  
--    )   
  
  
--    INSERT into cre.TransactionAuditLogLiability(BatchLogID,NoteID,TransactionType,DueDate,RemitDate,ServicingAmount,Status,ServicerMasterID,TransactionDate)
--    SELECT   
--    @Batchlogid,  
--    n.NoteID,   
--    ttr.ValueType,   
--    ttr.DueDate,  
--    ttr.RemitDate,   
--    isnull(ttr.Value,0) as ServicingAmount,  
--    'Duplicate Record',  
--    @ServicerMasterID,   
--    ttr.TransDate       
--    FROM CTE ttr   
--    inner join cre.note n on n.CRENoteID=ttr.NoteID    
--    WHERE RN > 1   
    
  
  
--    ;WITH Dupl AS(  
--        SELECT NoteID,ValueType,Value,DueDate,RemitDate,TransDate,  
--            RN = ROW_NUMBER()OVER(PARTITION BY NoteID,ValueType,DueDate,RemitDate,TransDate  
--        order by NoteID,DueDate, ValueType, RemitDate, TransDate)  
--        FROM IO.[L_ManualTransactionLiability] where FileBatchLogid=@Batchlogid  
--    )   
--    Delete from Dupl where RN>1
--    --============================Delete Duplicate Records========================  
  
  
-- ---==========================Insert into TransactionAuditLog====================================    
    
--    INSERT into cre.TransactionAuditLogLiability(BatchLogID,NoteID,TransactionType,DueDate,ServicingAmount,Status,ServicerMasterID,TransactionDate,RemitDate)    --,ReconFlag
--    SELECT     
--    @Batchlogid,    
--    n.NoteID,     
--    mt.ValueType,     
--    mt.DueDate,        
--    isNull(mt.Value,0) as ServicingAmount,    
--    'Imported',      
--    @ServicerMasterID,     
--    mt.TransDate,    
--    mt.RemitDate  
--    --,mt.ReconFlag        
--    from IO.[L_ManualTransactionLiability] mt    
--    inner join cre.note n on n.NoteID=mt.NoteIDGuid     
      
    
--	 ---========Note oes not exists in system

--	INSERT into cre.TransactionAuditLogLiability(BatchLogID,NoteID,CRENoteID,TransactionType,DueDate,ServicingAmount,Status,ServicerMasterID,TransactionDate,RemitDate)    --,ReconFlag
--    SELECT     
--    @Batchlogid, 
--	'00000000-0000-0000-0000-000000000000',
--	mt.NoteID,
--    mt.ValueType,     
--    mt.DueDate,        
--    isNull(mt.Value,0) as ServicingAmount,    
--     'Note does not exist.',     
--    @ServicerMasterID,     
--    mt.TransDate,    
--    mt.RemitDate  
--    --,mt.ReconFlag        
--    from IO.[L_ManualTransactionLiability] mt    
--    left join cre.note n on n.NoteID=mt.NoteIDGuid where n.noteid is null

    
--    Update cre.TransactionAuditLogLiability SET [Status] = 'Due date is lower than accounting close date.' 
--    Where Batchlogid = @Batchlogid
--    and TransactionAuditLogID in (
--	    Select TransactionAuditLogID
--	    from cre.TransactionAuditLogLiability ta
--	    Left Join (
--		    Select noteid,LastAccountingCloseDate from(
--			    Select 
--			    d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
--			    ,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
--			    from cre.deal d
--			    Inner join cre.note n on n.dealid = d.dealid
--			    Left join (
--				    Select dealid,CloseDate,updateddate
--				    from CORE.[Period]
--				    where isdeleted <> 1 and CloseDate is not null
--			    )p on d.dealid = p.dealid 
--			    Where d.IsDeleted <> 1
--		    )a
--		    where a.rno = 1
--	    )z on ta.noteid = z.NoteID
--	    where ta.Batchlogid = @Batchlogid
--	    and  ta.duedate <= LastAccountingCloseDate
--    )

  
--    Update ta set ta.Status='Note does not exist.'     
--    from cre.TransactionAuditLogLiability ta     
--    inner join cre.Note n on ta.Noteid=n.noteid    
--    inner join IO.L_ManualTransaction r on r.NoteID=n.CRENoteid     
--    inner Join core.account a on n.Account_AccountID=a.AccountID     
--    where (a.IsDeleted=1 or a.StatusID=2) and ta.Batchlogid = @Batchlogid     
    
    
--    Update ta set ta.Status='Note Enable M61 Calculations is N.'     
--    from cre.TransactionAuditLogLiability ta     
--    inner join cre.Note n on ta.Noteid=n.noteid    
--    inner join IO.L_ManualTransaction r on r.NoteIDGuid=n.Noteid     
--    where n.EnableM61Calculations=4 and ta.Batchlogid = @Batchlogid     
    
    
    
--    update ta set ta.Status='Data already Reconcilled.'       
--    from cre.TransactionAuditLogLiability ta     
--    inner join cre.TransactionReconciliationLiability tr on ta.NoteID=tr.NoteID and       
--    ta.DueDate=tr.DateDue and     
--    ta.TransactionType=tr.[TransactionType]  and     
--    isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
--    ta.TransactionDate=tr.TransactionDate and    
--    ta.ServicerMasterID=tr.ServcerMasterID    
--    where tr.posteddate is not null     
--    and ta.Batchlogid = @Batchlogid    
--    and tr.Ignore <> 1    
--    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')     
--    --and ta.Reconflag in('InterestPaid','OtherFee') 

 
--    update ta set ta.Status='Due Date already Reconcilled.'       
--    from cre.TransactionAuditLogLiability ta     
--    inner join cre.TransactionReconciliationLiability tr on ta.NoteID=tr.NoteID and       
--    ta.DueDate=tr.DateDue and     
--    ta.TransactionType=tr.[TransactionType]  and 
--    ta.ServicerMasterID=tr.ServcerMasterID    
--    where tr.posteddate is not null     
--    and ta.Batchlogid = @Batchlogid    
--    and tr.Ignore <> 1    
--    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')     
--    --and ta.Reconflag in('InterestPaid','OtherFee') 


--    Update ta set ta.Status='Reimported'       
--    from cre.TransactionAuditLogLiability ta     
--    INNER join cre.TransactionReconciliationLiability tr on ta.NoteID=tr.NoteID and       
--    ta.DueDate=tr.DateDue and     
--    ta.TransactionType=tr.[TransactionType]  and   
--    isnull(ta.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) and    
--    ta.ServicerMasterID=tr.ServcerMasterID and tr.deleted=0    
--    where tr.posteddate is null and ta.Batchlogid =@Batchlogid    
--    and ta.[Status] not in ('Note does not exist.','Note Enable M61 Calculations is N.','Duplicate Record','Due date is lower than accounting close date.')     
--    --and ta.Reconflag in('InterestPaid','OtherFee')      
  
-- --================Update Existing Data=====================    
--    Update cre.TransactionReconciliationLiability     
--    set cre.TransactionReconciliationLiability.Deleted=1,     
--    cre.TransactionReconciliationLiability.UpdatedDate=GETDATE(),    
--    cre.TransactionReconciliationLiability.UpdatedBy=@uploadedby    
--    from    
--    (    
--        SELECT tr.Transcationid,    
--        mt.LandingID,       
--        mt.ValueType,    
--        mt.DueDate,    
--        isnull(tr.ServicingAmount,0) as ServicingAmount,    
--        tr.posteddate      
--        from IO.[L_ManualTransactionLiability] mt     
--        inner join cre.note n on n.NoteID=mt.NoteIDGuid       
--        inner join cre.TransactionReconciliationLiability tr on tr.NoteID=n.NoteID      
--        and mt.DueDate=tr.DateDue and     
--        mt.ValueType=tr.[TransactionType]  and  
--        @ServicerMasterID=tr.ServcerMasterID   and  
--        isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate())     
--        where tr.posteddate is null and tr.deleted=0  
--        --and mt.ReconFlag in('InterestPaid','OtherFee')  
--    ) a    
--    where a.Transcationid=cre.TransactionReconciliationLiability.Transcationid 
--  --================Update Excisting Data=====================    
     

--    Update ta set ta.Status='Transaction type does not configured in transaction master.'       
--    from cre.TransactionAuditLogLiability ta     
--    where ta.Batchlogid = @Batchlogid        
--    and ta.TransactionType not in (Select TransactionName from cre.TransactionTypes where IncludeServicingReconciliation = 3)    
--    --and ta.TransactionType not in ( 'InterestPaid','ExitFee', 'ExtensionFee','PrepaymentFee','UnusedFee')

--    --Update ta set ta.Status='Transaction type does not configured in transaction master.'       
--    --from cre.TransactionAuditLogLiability ta     
--    --where ta.Batchlogid = @Batchlogid    
--    --and ta.TransactionType  in ('ExitFeeExcludedFromLevelYield',
--    --'ExitFeeIncludedInLevelYield',
--    --'ExitFeeStrippingExcldfromLevelYield',
--    --'ExitFeeStripReceivable',
--    --'ExtensionFeeExcludedFromLevelYield',
--    --'ExtensionFeeIncludedInLevelYield',
--    --'ExtensionFeeStrippingExcldfromLevelYield',
--    --'ExtensionFeeStripReceivable')


--    Update ta set ta.Status='Transaction type does not exist in Dropdown.'       
--    from cre.TransactionAuditLogLiability ta     
--    where ta.Batchlogid = @Batchlogid    
--    and ta.TransactionType not in  
--    (Select TransactionName from [CRE].[TransactionTypes] where IncludeServicingReconciliation=3)
 
 
    
--    Update cre.TransactionReconciliationLiability SET Deleted = 1    
--    Where PostedDate is null    
--    and Noteid in(    
--        Select Noteid 
--        from cre.TransactionAuditLogLiability 
--        where [Status] in ('Note does not exist.','Transaction type does not configured in transaction master.','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not exist in Dropdown.','Data already Reconcilled.','Due Date already Reconcilled.','Due date is lower than accounting close date.')    
--    )    
--    and BatchLogID= @Batchlogid   
-----==========================Insert into TransactionAuditLog====================================    
    
    
--    INSERT into cre.TransactionReconciliationLiability(DealId,NoteID,ServcerMasterID,TransactionType,DateDue,ServicingAmount,CalculatedAmount,Delta,TransactionDate,CreatedBy,createdDate,UpdatedBy,UpdatedDate,BatchLogID,RemittanceDate,AddlInterest,TotalInterest)             
--    Select d.DealID,      
--    n.NoteID,      
--    @ServicerMasterID,      
--    mt.ValueType,      
--    mt.DueDate,      
--    isNull(mt.Value,0) as ServicingAmount,      
--    isnull(CREtr.Amount,0) as CalculatedAmount,      
--    round((isnull(mt.Value,0)-isnull(CREtr.Amount,0)),2) as Delta,      
--    mt.TransDate,      
--    @uploadedby as createdby,      
--    GETDATE() as createdDate,      
--    @uploadedby as updatedby,      
--    GETDATE() as UpdatedDate,      
--    @Batchlogid ,      
--    mt.RemitDate   ,
--    mt.CapitalizedInterest,mt.CashInterest 
--    from IO.[L_ManualTransactionLiability] mt      
--    inner join cre.note n on n.NoteID=mt.NoteIDGuid       
--    left join cre.Deal d on d.DealID=n.DealID      
--    inner join (      
--        Select BatchLogID      
--        ,NoteID      
--        ,TransactionType      
--        ,DueDate      
--        ,RemitDate      
--        ,Status      
--        ,ServicerMasterID      
--        ,TransactionDate       
--        from cre.TransactionAuditLogLiability       
--        where BatchLogid = @Batchlogid and [Status] in ('Imported','Reimported')      
--    )ta on n.NoteID=ta.NoteID        
--    AND ta.DueDate=mt.DueDate       
--    and ta.TransactionType=mt.ValueType        
--    and isnull(ta.RemitDate,getdate())=isnull(mt.RemitDate,getDate())   
--    and mt.FileBatchLogid =@Batchlogid      
--    left join cre.TransactionReconciliationLiability tr on n.NoteID=tr.NoteID  and tr.posteddate is null     
      
--    and  tr.Deleted =0       
--    AND mt.DueDate=tr.DateDue       
--    and mt.ValueType=tr.[TransactionType]        
--    and isnull(mt.RemitDate,getdate())=isnull(tr.RemittanceDate,getDate()) 
--    and tr.ServcerMasterID=@ServicerMasterID      
--    --and mt.ReconFlag in ('InterestPaid' ,'OtherFee')  
--    left join [Cre].Transactionentry CREtr on n.Account_AccountID=CREtr.AccountID and mt.DueDate=CREtr.Date and  mt.ValueType = CREtr.Type  and AnalysisID=@ScenarioId      
       
--    --Where mt.FileBatchLogid =@Batchlogid      
--    --and (mt.ValueType = 'InterestPaid' OR mt.ValueType in (Select TransactionType from CRE.FeeTransactionTypeMaster))        
--    --and n.Noteid not in (Select Noteid from cre.TransactionAuditLog where [Status] in ('Note does not exist.','Data already Reconcilled.','Transaction type does not configured in transaction master.') and Batchlogid = @Batchlogid)      
   
    

--    Update cre.TransactionReconciliationLiability  SET cre.TransactionReconciliationLiability.DueDateAlreadyReconciled = 1,cre.TransactionReconciliationLiability.CalculatedAmount=0
--    Where transcationid in (
--        Select a.transcationid
--        from(
--            Select transcationid ,NoteID,DateDue,[TransactionType],ServcerMasterID
--            from cre.TransactionReconciliationLiability 
--            where posteddate is null and Batchlogid = @Batchlogid
--            and Ignore <> 1  and [TransactionType]='InterestPaid' 
--        )a     
--        inner join cre.TransactionReconciliationLiability tr on tr.NoteID=a.NoteID and       
--        ISNULL(tr.DateDue,getdate())=ISNULL(a.DateDue,getdate()) and     
--        tr.TransactionType=a.[TransactionType]  and       
--        tr.ServcerMasterID=a.ServcerMasterID    
--        where tr.posteddate is not null 
--        and tr.Ignore <> 1    
--        and tr.TransactionType='InterestPaid' 
--    )
    
    

--    --------------------------------- Total records imported--------------------------------

    select TransactionType,sum(totalrecords-ignored-DDAllRec) Totalrecords,sum(ignored) as ignored,sum(DDAllRec) as DDAllRec , Notenotexist 
    from (

        select  TransactionType,count(Status) totalrecords,0 as ignored,0 as DDAllRec,null as Notenotexist
        from cre.TransactionAuditLogLiability  where BatchLogID=@Batchlogid 
        group by TransactionType,BatchLogID

        UNION ALL

        select  TransactionType,0,count(Status) as ignored,0 as DDAllRec,null as Notenotexist
        from cre.TransactionAuditLogLiability  where BatchLogID=@Batchlogid 
        and [Status] in ('Note does not exist.','Zero Interest','Note Enable M61 Calculations is N.','Reimported','Ignore Paydowns','Ignore Pik Principal Paid','Data already Reconcilled.','Due date is lower than accounting close date.')  ---,'Ignore Paydowns Plus Pik Principal Paid' )
        group by TransactionType,BatchLogID

        UNION ALL

        select  TransactionType,0,0 ,count(Status) as DDAllRec,null as Notenotexist
        from cre.TransactionAuditLogLiability  where BatchLogID=@Batchlogid 
        and [Status] in ('Due Date already Reconcilled.')  
        group by TransactionType,BatchLogID

		UNION ALL

	select null as TransactionType,0,0 as ignored,0 as DDAllRec,
	(SELECT STRING_AGG(CAST(NoteAccountID AS VARCHAR(500)), ',') 
	FROM (
	SELECT DISTINCT NoteAccountID
	FROM cre.TransactionAuditLogLiability 
	WHERE BatchLogID = @Batchlogid 
	AND [Status] = 'Note does not exist.'
	) AS DistinctNotes)AS Notenotexist

	from cre.TransactionAuditLogLiability  where BatchLogID=@Batchlogid 
	and [Status] in ('Note does not exist.')  
	group by TransactionType,BatchLogID

    )aa
    group by TransactionType,Notenotexist
    
    --Delete from IO.L_ManualTransactionLiability     
       
END 