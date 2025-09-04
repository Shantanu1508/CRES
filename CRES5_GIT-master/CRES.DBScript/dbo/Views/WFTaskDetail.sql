-- View  
CREATE View [dbo].[WFTaskDetail]                  
AS  
           
Select WFTaskDetailID                
,WFStatusPurposeMappingID                
,TaskID                 
,TaskTypeID                
,TaskTypeBI                 
,Comment                 
,SubmitType                
,SubmitTypeBI                 
,CreatedBy                 
,CreatedDate                 
,UpdatedBy                 
,UpdatedDate                 
,IsDeleted                 
,DelegatedUserID                
,SpecialInstruction                
,AdditionalComment                
,WFGroupText                
,StatusName                
,StatusDisplayName                
,DealFundingDisplayName                
,WFUnderReviewDisplayName                
,WFCurrentStatus                
,Username              
,WFStatusMasterID              
,FundingDate            
,PurposeText as PurposeType          
,Amount          
,UnderReview_Date            
            
,FundingDate_in            
,UnderReview_Date_in            
            
,tblwdcnt.Businessday_cnt            
,TotalDayCount            
From            
 (            
Select WFTaskDetailID                
 ,WFStatusPurposeMappingID                
 ,TaskID                 
 ,TaskTypeID                
 ,TaskTypeBI                 
 ,Comment                 
 ,SubmitType                
 ,SubmitTypeBI                 
 ,CreatedBy                 
 ,CreatedDate                 
 ,UpdatedBy                 
 ,UpdatedDate                 
 ,IsDeleted                 
 ,DelegatedUserID                
 ,SpecialInstruction                
 ,AdditionalComment                
 ,WFGroupText                
 ,StatusName                
 ,StatusDisplayName                
 ,DealFundingDisplayName                
 ,WFUnderReviewDisplayName                
 ,WFCurrentStatus                
 ,Username              
 ,WFStatusMasterID              
 ,FundingDate            
 ,PurposeText          
 ,Amount          
 ,UnderReview_Date            
            
 ,(CASE WHEN FundingDate < UnderReview_Date THEN UnderReview_Date ELSE FundingDate END)  as FundingDate_in            
 ,(CASE WHEN FundingDate < UnderReview_Date THEN FundingDate ELSE UnderReview_Date END) as UnderReview_Date_in             
            
 ,(CASE WHEN FundingDate < UnderReview_Date THEN DATEDIFF(day,FundingDate,UnderReview_Date) ELSE DATEDIFF(day,UnderReview_Date,FundingDate) END)   as TotalDayCount            
 ,rno            
From(               
 SELECT                 
 WFTaskDetailID                
 ,WFStatusPurposeMappingID                
 ,TaskID                 
 ,TaskTypeID                
 ,TaskTypeBI                 
 ,Comment                 
 ,SubmitType                
 ,SubmitTypeBI                 
 ,CreatedBy                 
 ,CreatedDate                 
 --,date_difference = DATEDIFF(day,UnderReview,FinalApproval)              
 ,UpdatedBy                 
 ,UpdatedDate                 
 ,IsDeleted                 
 ,DelegatedUserID                
 ,SpecialInstruction                
 ,AdditionalComment                
 ,WFGroupText                
 ,StatusName                
 ,StatusDisplayName                
 ,DealFundingDisplayName                
 ,WFUnderReviewDisplayName                
 ,WFFinalStatus as WFCurrentStatus                
 ,Username              
 ,WFStatusMasterID              
 ,FundingDate            
 ,PurposeText          
 ,Amount          
 ,case when DealFundingDisplayName = 'Under Review' then [CreatedDate] ELSE [CreatedDate] END AS UnderReview_Date            
       
 -- ,case when DealFundingDisplayName ='Final Approval Rec’d' then [CreatedDate] ELSE null END AS FinalApproval             
 ,ROW_NUMBER() over (Partition by TaskID,WFStatusMasterID,SubmitType order by  TaskID,WFStatusMasterID,CreatedDate desc) as rno    --          
 FROM [DW].[WFTaskDetailBI]               
 )z            
)a             
outer apply(            
 Select COUNT([wday]) Businessday_cnt From(            
  select Distinct a.[wday] from(            
   Select DateValue,DateNAme(dw,DateValue) as [datename] ,fn_wday.[wday]            
   from [dbo].[fn_GenerateDateRange](cASt(a.UnderReview_Date_in as date),cast(a.FundingDate_in as date),1,'day') fn_dtrange            
   Outer Apply(            
    Select dbo.Fn_GetnextWorkingDays(fn_dtrange.DateValue,1,'PMT Date') as [wday]            
   )fn_wday            
   where DateNAme(dw,DateValue)  not in ('Sunday','Saturday')            
   and fn_wday.[wday] >= a.UnderReview_Date_in and fn_wday.[wday] <= a.FundingDate_in            
  )a            
 )z            
)tblwdcnt        
      
      
            
where rno = 1       