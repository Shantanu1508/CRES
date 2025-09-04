    
    
CREATE VIEW [dbo].[vw_LiabilityCalendarNote]    
AS    
Select  a.NoteID,c.Date ,CONCAT( a.NoteID,c.Date) as NoteidDate    
From(    
 Select Distinct N.crenoteid as NoteID    
 FROM CRE.LiabilityNoteAssetMapping LN    
 LEFT Join Cre.Deal D ON D.AccountID = LN.DealAccountID    
 LEFT Join Cre.Note N ON N.Account_AccountID = LN.AssetAccountID    
)a,Calendar c    
where c.year >= 2015 and c.year <= 2040    