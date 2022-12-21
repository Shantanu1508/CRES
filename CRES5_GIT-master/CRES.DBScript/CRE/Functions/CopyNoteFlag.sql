-- Function
-- Function
-- Function
-- Function
-- Function
-- Function
-- Function
CREATE FUNCTION [CRE].[CopyNoteFlag](
    @CRENoteID varchar(128)
)
RETURNS INT
AS 
BEGIN
       declare @flag as INT
       set @flag = (
		   select distinct case 
		   when n.CRENoteID like '%phtm' then 0
		   when n.CRENoteID like '% a' or n.CRENoteID like '%b' or n.CRENoteID like '%d' or n.CRENoteID like '%P' or n.CRENoteID like '%c' or n.CRENoteID like '%cc' or n.CRENoteID like '%x' or n.CRENoteID like '%w' or n.CRENoteID like '%xx' or n.CRENoteID like '%x1' then 1                    
		   when DealName like '%Deal%' or DealName like '%Copy%' or DealName like '%Test%' then 1 
		   
		   else 0  end
		   from cre.Note n                    
		   join cre.Deal d on d.DealID = n.DealID  
		   where n.CRENoteID = @CRENoteID
	   )
    RETURN @flag
END;