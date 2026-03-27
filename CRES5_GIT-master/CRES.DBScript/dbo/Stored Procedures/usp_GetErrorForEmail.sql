CREATE PROCEDURE [dbo].[usp_GetErrorForEmail] -- 'AutoSpread_UnderwritingDataChanged'  
 
AS        
BEGIN              
            
 SET NOCOUNT ON;         
       
     select    
 Module,Message,MethodName,ObjectID,Message_StackTrace ,LoggerID,CreatedDate  as Time
 from app.logger ff  
where ff.Severity ='Error'  
 and ff.CreatedDate >= cast(dateadd(day, -1, getdate()) as date)  
    
        
END 