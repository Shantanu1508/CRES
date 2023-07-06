CREATE PROCEDURE [dbo].[usp_LCGetRateSpreadScheduleByCRENoteID] --'2307'  
(  
 @CRENoteID NVARCHAR(256)  
)  
   
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET FMTONLY OFF;  
     
  
DECLARE @cols AS NVARCHAR(MAX),  
@query  AS NVARCHAR(MAX)  
  
  
  
select @cols = STUFF((SELECT ',' + QUOTENAME( Convert (nvarchar(MAX), cast((ROW_NUMBER() over (order by RateSpreadScheduleID))  as varchar(50)), 101) )   
             from [CORE].RateSpreadSchedule rs  
    INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
    LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
    LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
    LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
    where n.CRENoteID = @CRENoteID and acc.IsDeleted = 0  
    and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)  
                group by eve.EffectiveStartDate,RateSpreadScheduleID  
                     
            FOR XML PATH(''), TYPE  
            ).value('.', 'NVARCHAR(MAX)')   
        ,1,1,'')  
  
 set @query = N'SELECT  ' + @cols + N'  
  FROM (  
    
 SELECT [RowCount], Amount, [0]  
 FROM (     
    Select   
    cast((ROW_NUMBER() over (order by eve.EffectiveStartDate,rs.[Date],RateSpreadScheduleID,RateSpreadScheduleID))  as varchar(50))   as [RowCount],  
    ISNULL(Convert (nvarchar(MAX), eve.EffectiveStartDate, 101),'''')   as [Effective Date]  
    ,ISNULL(Convert (nvarchar(MAX), rs.[Date], 101),'''') as [Rate or Spread Change Date]  
    ,ISNULL(Cast(rs.[Value] as nvarchar(MAX)),'''') as [Value]  
    ,ISNULL(Cast(LIntCalcMethodID.Name as nvarchar(MAX)),'''') as [Int Calc Method]  
    ,ISNULL(Cast(LValueTypeID.Name as nvarchar(MAX)),'''') as [Value Type]  
    ,ISNULL(Cast(rs.[RateOrSpreadToBeStripped] as nvarchar(MAX)),'''') as [RateOrSpreadToBeStripped]  
  

    from [CORE].RateSpreadSchedule rs  
    INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
    LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID  
    LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID  
    LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID      
    where n.CRENoteID = '''+ cast(@CRENoteID as varchar(256))+'''  and acc.IsDeleted = 0  
    and eve.StatusID = (Select LookupID from Core.Lookup where name = ''Active'' and parentid = 1)  
  
  
   ) as sq_source  
  UNPIVOT (Amount FOR [0] IN  
  ([Effective Date],[Rate or Spread Change Date],  [Value] , [Int Calc Method],[Value Type],[RateOrSpreadToBeStripped])  
  
  
 ) as sq_up  
           
     
   ) as sq    
     PIVOT (  
        MIN(Amount)  
        FOR [RowCount] IN  
           (' + @cols + N')  
           ) as p  
  
ORDER BY CASE WHEN [0] = ''Effective Date'' THEN ''1''  
WHEN [0] = ''Rate or Spread Change Date'' THEN ''2''  
WHEN [0] = ''Value'' THEN ''3''  
WHEN [0] = ''Int Calc Method'' THEN ''4''  
WHEN [0] = ''Value Type'' THEN ''5''  
WHEN [0] = ''RateOrSpreadToBeStripped'' THEN ''6''  

ELSE [0] END ASC'  
  
 --PRINT(@query);   
  
EXEC(@query);  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
