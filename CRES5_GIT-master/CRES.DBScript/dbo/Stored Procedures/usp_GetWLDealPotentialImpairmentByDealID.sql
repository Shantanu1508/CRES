
CREATE PROCEDURE [dbo].[usp_GetWLDealPotentialImpairmentByDealID]
(
	@UserID UNIQUEIDENTIFIER,
    @DealID UNIQUEIDENTIFIER
)
AS

 BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



DECLARE @ColPivot AS NVARCHAR(MAX),
@ColPivot1 AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX),      
@query1 as nvarchar(MAX)
--@DealID UNIQUEIDENTIFIER='C848F020-2EE5-4BD4-9939-2E4B50C59744'
    set @ColPivot= STUFF((SELECT  ',isnull(' + QUOTENAME(cast(n.CRENoteID as nvarchar(256))+'_Noteid' )+',0) as '+QUOTENAME(cast(n.CRENoteID as nvarchar(256))+'_Noteid' )                         
         from [CRE].[Note] n      
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
         and n.DealID = @DealID     
         and acc.IsDeleted = 0      
         --and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  3      
        order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name              
      FOR XML PATH(''), TYPE      
      ).value('.', 'NVARCHAR(MAX)')       
     ,1,1,'')     
	 
	 set @ColPivot1= STUFF((SELECT  ',' + QUOTENAME(cast(n.CRENoteID as nvarchar(256))+'_Noteid' )                        
         from [CRE].[Note] n      
       INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
         and n.DealID = @DealID     
         and acc.IsDeleted = 0      
         --and ISNULL(n.UseRuletoDetermineNoteFunding,4) =  3      
        order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name              
      FOR XML PATH(''), TYPE      
      ).value('.', 'NVARCHAR(MAX)')       
     ,1,1,'')

 If exists(select 1 from CRE.WLDealPotentialImpairmentMaster where DealID=@DealID)
 BEGIN
 
 Set @query=
 N'select DealID,WLDealPotentialImpairmentMasterID,RowNo,Date,Amount,AdjustmentType,Comment,Applied,' + @ColPivot + ' from
 (
 Select 
 ls.[WLDealPotentialImpairmentMasterID]
,ls.[DealID]          
,ls.[Date] 
,ls.[Amount]
,ls.AdjustmentType
,ls.[Comment]
,ls.[Applied]
,ls.RowNo
,ls.[CreatedBy]       
,ls.[CreatedDate]     
,ls.[UpdatedBy]       
,ls.[UpdatedDate]
 ,n.[CRENoteID]+''_Noteid'' as Name
 ,id.[Value] 
From [CRE].[WLDealPotentialImpairmentMaster] ls
join [CRE].[WLDealPotentialImpairmentDetail] id on ls.WLDealPotentialImpairmentMasterID=id.WLDealPotentialImpairmentMasterID
join [CRE].[Note] n on n.NoteID=id.NoteID
join core.Account acc on acc.AccountID=n.Account_AccountID
Where ls.dealid = '''+convert(varchar(MAX),@DealID)+'''
) as tblmain
PIVOT
(
sum(Value) for  Name in  (' + @ColPivot1 + ')
) PivoteTable
order by Date,RowNo
'
END
ELSE
BEGIN
 Set @query=
 N'select DealID,WLDealPotentialImpairmentMasterID,RowNo,Date,Amount,Comment,Applied,' + @ColPivot1 + ' from
 (
 Select 
 null as [WLDealPotentialImpairmentMasterID]
,d.[DealID]          
,null as [Date] 
,null as [Amount]
,null as AdjustmentType
,null [Comment]
,cast(0 as bit) as [Applied]
,null as RowNo
,null as [CreatedBy]       
,getdate() as [CreatedDate]     
,null as [UpdatedBy]       
,getdate() as [UpdatedDate]
 ,n.[CRENoteID] as Name
 ,0 as [Value] 
From [CRE].[Deal] d
join [CRE].[Note] n on n.DealID=d.DealID
join core.Account acc on acc.AccountID=n.Account_AccountID
Where d.dealid = '''+convert(varchar(MAX),@DealID)+'''
) as tblmain
PIVOT
(
sum(Value) for  Name in  (' + @ColPivot1 + ')
) PivoteTable'
END
print @query
exec(@query);




SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END