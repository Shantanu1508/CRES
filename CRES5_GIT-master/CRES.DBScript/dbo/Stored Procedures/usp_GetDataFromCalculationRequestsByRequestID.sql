 CREATE PROCEDURE dbo.usp_GetDataFromCalculationRequestsByRequestID  --'5ccfe21c89054f08a7b8782655d87203'  
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
 cr.NoteId as NoteId  
 ,(Select top 1 value from app.appconfig  where [key] ='AllowDebugInCalc')  as AllowDebugInCalc  
 ,cr.CalcType  
 ,n.crenoteid
 from Core.CalculationRequests cr  
  inner join  app.[user] l on l.UserID =cr.UserName  
  inner join  core.AnalysisParameter ap on cr.AnalysisID =ap.AnalysisID  
  left join cre.note n on n.noteid = cr.noteid
  where RequestID =@RequestID  


end  