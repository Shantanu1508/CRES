--[dbo].[usp_GetXIRROutPut_VSTO]     41

CREATE PROCEDURE [dbo].[usp_GetXIRROutPut_VSTO]
(    
    @BatchLogAsyncCalcVSTOID int  
)    
     
AS    
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
DECLARE @ColPivot AS NVARCHAR(MAX),@query  AS NVARCHAR(MAX)    

SET @ColPivot = STUFF((SELECT  ',' +  QUOTENAME(cast( SizerScenario as nvarchar(256)) )           
        From(
			Select Distinct SizerScenario
			from [CRE].TransactionEntryVSTO
			where BatchDetailAsyncCalcVSTOId in (select BatchDetailAsyncCalcVSTOId from cre.BatchDetailAsyncCalcVSTO  where BatchLogAsyncCalcVSTOID=@BatchLogAsyncCalcVSTOID )
		)a
		ORDER BY SizerScenario
	  FOR XML PATH(''), TYPE    
      ).value('.', 'NVARCHAR(MAX)')     
     ,1,1,'')    

SET @query = 'SELECT NoteName,'+CAST(@ColPivot as nvarchar(256))+'
from (       
	Select NoteName_New as NoteName,SizerScenario,SUM(Amount) Amount
	From(
		select NoteName
		,(CASE WHEN NoteName like ''%Note A%'' Then ''Note A'' WHEN NoteName like ''%Note B%'' Then ''Note B'' WHEN NoteName like ''%Mezz%'' Then ''Mezz'' END)as NoteName_New
		,SizerScenario
		,Amount  
		from [CRE].TransactionEntryVSTO
		where  Type = ''AllInYieldPV''
		and BatchDetailAsyncCalcVSTOId in (select BatchDetailAsyncCalcVSTOId from cre.BatchDetailAsyncCalcVSTO  where BatchLogAsyncCalcVSTOID='''+CAST(@BatchLogAsyncCalcVSTOID as nvarchar(256))+''' )
	)a
	group by a.NoteName_New,a.SizerScenario
) x     
pivot     
(   
	sum(Amount)    
	for     
	SizerScenario in ('+CAST(@ColPivot as nvarchar(256))+')    
) p
Order by (CASE WHEN NoteName like ''%Note A%'' THEN 1	WHEN NoteName like ''%Note B%'' THEN 2 WHEN NoteName like ''%Mezz%'' THEN 3 ELSE 99999 END )'    
    

 
print @query    
        
    
exec(@query);    
    
    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END    
    
    
    
    
    
