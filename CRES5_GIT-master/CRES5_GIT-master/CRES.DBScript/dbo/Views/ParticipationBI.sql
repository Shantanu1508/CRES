

CREATE VIEW [dbo].[ParticipationBI]  
AS  

Select n.crenoteid as NoteID,
d.credealid as DealID,
nea.PctAllocation as Participation,
en.EntityName  as Entity

from CRE.NoteEntityAllocation nea
inner join cre.entity en on en.entityID = nea.entityID
inner join cre.note n on n.noteid = nea.noteid
inner join cre.deal d on d.dealid = n.dealid
where en.EntityName in ('RSLIC','SNCC' ,'PIIC' ,'TMR' ,'HCC' ,'USSIC' ,'TMNF' ,'HAIH')


--select *  
--from  
--(  
-- select NoteID  
-- ,DealID  
-- ,  
-- RSLIC ,  
-- SNCC ,  
-- PIIC ,  
-- TMR ,  
-- HCC ,  
-- USSIC ,  
-- TMNF ,  
-- HAIH   
-- from DW.NoteMatrixBI  

--) d  
--UNPIVOT (  
-- [Participation] FOR [Entity] IN (RSLIC,SNCC ,PIIC ,TMR ,HCC ,USSIC ,TMNF ,HAIH)   
--)up  
