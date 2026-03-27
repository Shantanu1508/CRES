  
---[VAL].[usp_GetFloorByTerm] 'SOFR 1M'  
  
CREATE PROCEDURE [VAL].[usp_GetFloorByTerm]    
(  
 @MarkedDate date,  
 @IndexTypeName nvarchar(256)  
)  
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     
    Declare @MarkedDateMasterID int;  
 SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)  
  
   
 DECLARE @cols_Per AS NVARCHAR(MAX);   
 DECLARE @query  AS NVARCHAR(MAX)  
  
 select @cols_Per = STUFF((SELECT ',' + QUOTENAME(CAST([month] as nvarchar(100)))   
    From(  
     Select Distinct [month]  
     from [VAL].[FloorByTerm] ft  
     Inner Join [val].FloorValue fv on fv.FloorValueID = ft.FloorValueID and fv.MarkedDateMasterID = @MarkedDateMasterID  
     Where IndexTypeName = @IndexTypeName   
     )a  
   FOR XML PATH(''), TYPE  
   ).value('.', 'NVARCHAR(MAX)')   
  ,1,1,'')  
  
IF(NULLIF(@cols_Per,'') is not null )
 BEGIN
	set @query = N'  
  Select Percentage,'+@cols_Per+'   
  from(  
   Select ft.[Percentage],ft.[Month],ft.[Value]  
   from [VAL].[FloorByTerm]  ft  
   Inner Join [val].FloorValue fv on fv.FloorValueID = ft.FloorValueID and fv.MarkedDateMasterID = '+ CAST(@MarkedDateMasterID as nvarchar(256)) +'  
   Where IndexTypeName = '''+ @IndexTypeName +'''  
  )a  
  PIVOT(  
   SUM([Value]) FOR [Month] in ('+@cols_Per+')  
  )z  
 '  
 END
 ELSE
 BEGIN
	Select null as [Percentage]
 END
 
   
 EXEC(@query);  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  