
CREATE TABLE [Core].[AccountCategory] (
    [AccountCategoryID]    INT            IDENTITY (1, 1) NOT NULL,   
    [Name]        NVARCHAR (256) NOT NULL,
    [Type]       NVARCHAR (256) NULL,   
    [AssetOrLiability]      int NULL,
    [Priority]   SMALLINT       NOT NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL
    CONSTRAINT [PK_AccountCategoryID] PRIMARY KEY CLUSTERED ([AccountCategoryID] ASC)
);




go
Print('INSERT INTO [Core].[AccountCategory]')

INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('CRE Loan (Note)','Asset Note',1,1)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Repo','Long Term Liabilities',-1,-2)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Subline','Short Term Liabilities',-1,-3)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Fund','Equity',-1,-1)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Note-on-Note','Long Term Liabilities',-1,-2)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('A-Note Buyer','Long Term Liabilities',-1,-2)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('RMBS','Short Term Assets',1,2)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Cash','Short Term Assets',1,3)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Mandate','Equity',-1,-1)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('CRE Whole Loan','Long Term Assets',1,1)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Debt Note','Liability Note',-1,-1)
INSERT INTO [Core].[AccountCategory] ([Name],[Type],[AssetOrLiability],[Priority]) Values ('Equity Note','Liability Note',-1,-2)


Update core.account set AccountTypeID = 1 where AccountTypeID = 182