-- View
CREATE VIEW [dbo].[vw_MarketPriceCurrent] 
AS        
Select NoteKey,Noteid,Date,Value  
From(  
	Select n.noteid as NoteKey,na.Noteid,na.Date,na.Value ,Row_number() over(Partition by na.Noteid order by na.date desc) as rno  
	from [DW].[NoteAttributesbyDateBI] na  	
	inner join dw.notebi n on n.crenoteid = na.noteid
	where na.ValueTypebi = 'MarketPrice'  
	and cast(na.Date as date) <=cast(getdate() as date)  
)a where rno =  1
