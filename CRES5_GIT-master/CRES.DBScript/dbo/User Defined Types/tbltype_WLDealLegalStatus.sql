--drop PROCEDURE usp_InsertWLDealLegalStatus
--drop TYPE [dbo].[tbltype_WLDealLegalStatus]

CREATE TYPE [dbo].[tbltype_WLDealLegalStatus] AS TABLE
(	
    [CREDealID]          NVARCHAR (256)  ,
	[StartDate] DATETIME,
	[Type]       NVARCHAR (256)  ,
    [Comment]          NVARCHAR (MAX) ,
	[ReasonCode]  NVARCHAR (MAX) ,
    [UserID]          NVARCHAR (256)  
)
