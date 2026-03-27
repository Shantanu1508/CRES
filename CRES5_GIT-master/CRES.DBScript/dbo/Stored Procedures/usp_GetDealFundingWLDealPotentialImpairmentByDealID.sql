CREATE PROCEDURE [dbo].[usp_GetDealFundingWLDealPotentialImpairmentByDealID]
(
	@UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER
)
AS

 BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


declare @PurposeText nvarchar(100),@PurposeID int

select @PurposeText= Name,@PurposeID=LookupID From core.Lookup where LookupID=840

DECLARE @ColPivot AS NVARCHAR(MAX),
@ColPivot1 AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX),      
@query1 as nvarchar(MAX)
--@DealID UNIQUEIDENTIFIER='C848F020-2EE5-4BD4-9939-2E4B50C59744'
    set @ColPivot= STUFF((SELECT  ',isnull(' + QUOTENAME(cast(acc.Name as nvarchar(256)))+',0) as '+QUOTENAME(cast(acc.Name as nvarchar(256)))                         
         from [CRE].[Note] n      
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
         and n.DealID = @DealID     
         and acc.IsDeleted = 0      
         --and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  3      
        order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name              
      FOR XML PATH(''), TYPE      
      ).value('.', 'NVARCHAR(MAX)')       
     ,1,1,'')     
	 
	 set @ColPivot1= STUFF((SELECT  ',' + QUOTENAME(cast(acc.Name as nvarchar(256)))                        
         from [CRE].[Note] n      
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
         and n.DealID = @DealID     
         and acc.IsDeleted = 0      
         --and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  3      
        order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name              
      FOR XML PATH(''), TYPE      
      ).value('.', 'NVARCHAR(MAX)')       
     ,1,1,'')

 
 Set @query=
 N'select ''00000000-0000-0000-0000-000000000000'' as DealFundingID	
,([Amount]*-1) as Value
,[Comment]		
,[Comment] as OldComment
,'''+@PurposeText+''' as PurposeText
,0 as EquityAmount	
,0 as RequiredEquity
,0 AdditionalEquity
,[Applied]
,[Date] as orgDate	
,[Amount] as orgValue
,[AdjustmentType]
,[Applied] as OrgApplied
,'''+convert(varchar(MAX),@PurposeID)+''' as orgPurposeID
,'''+@PurposeText+''' as OrgPurposeText
,1 as Issaved	
,''Completed'' as WF_CurrentStatus
,''Completed'' as WF_CurrentStatusDisplayName	
,1 as WF_IsCompleted	
,0 as WF_IsAllow
,0 as WF_isParticipate	
,0 as WF_IsFlowStart	
,'''+convert(varchar(MAX),@DealID)+''' as DealID	
,[Date] as Date
,'''+convert(varchar(MAX),@PurposeID)+''' as PurposeID
,RowNo as OrgDealFundingRowno
,RowNo as DealFundingRowno
,0 as IsShowDrawStatus,
GeneratedByUserID,
GeneratedByText,' + @ColPivot + ' from
 (
 Select distinct
  ls.[WLDealPotentialImpairmentMasterID]
,ls.[DealID]          
,ls.[Date] 
,ls.[Amount]
,ls.[AdjustmentType]
,ls.[Comment]
,ls.[Applied]
,ls.RowNo
,ls.[CreatedBy]
,ls.[CreatedBy] GeneratedByUserID
,u.login as GeneratedByText
,ls.[CreatedDate]     
,ls.[UpdatedBy]       
,ls.[UpdatedDate]
 ,acc.Name
 ,(id.[Value]*-1) as Value 
From [CRE].[WLDealPotentialImpairmentMaster] ls
join [CRE].[WLDealPotentialImpairmentDetail] id on ls.WLDealPotentialImpairmentMasterID=id.WLDealPotentialImpairmentMasterID
join [CRE].[Note] n on n.NoteID=id.NoteID
join core.Account acc on acc.AccountID=n.Account_AccountID
left join app.[user] u on u.UserID=ls.CreatedBy
Where ls.dealid = '''+convert(varchar(MAX),@DealID)+'''
and ls.[Applied]=1
and ls.[Date]<getdate()
) as tblmain
PIVOT
(
sum(Value) for  Name in  (' + @ColPivot1 + ')
) PivoteTable
order by Date,RowNo'
print @query
exec(@query);




SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

