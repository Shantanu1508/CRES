
CREATE PROCEDURE dbo.usp_GetDataFromCalculationRequestsLiabilityByRequestID  --'5ccfe21c89054f08a7b8782655d87203'  
(  
    @RequestID nvarchar(256)  
)  
as  
Begin  
   
    select   
    cr.AnalysisID,   
    UserName ,  
    l.login,  
    ap.UseActuals,  
    (Select top 1 value from app.appconfig  where [key] ='AllowDebugInCalc')  as AllowDebugInCalc  
    ,cr.CalcType  
    from Core.CalculationRequestsLiability cr  
    inner join  app.[user] l on l.UserID =cr.UserName  
    inner join  core.AnalysisParameter ap on cr.AnalysisID =ap.AnalysisID  
    where RequestID =@RequestID  


end  
