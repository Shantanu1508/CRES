CREATE PROCEDURE [dbo].[usp_GetParnetNotesInaDealForCalculation]   --  'd73c24c9-797c-4165-8ef3-c1ae5839c513'
(     
    @DealID nvarchar(256)
)      
       
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON; 
  select distinct StripTransferFrom  as NoteID from cre.PayruleSetup where DealID = @DealID 
  
END   
  
   