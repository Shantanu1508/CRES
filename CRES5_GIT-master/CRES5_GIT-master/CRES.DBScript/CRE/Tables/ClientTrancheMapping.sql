CREATE TABLE [CRE].[ClientTrancheMapping] (
    [ClientTrancheMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [ClientName]             NVARCHAR (256) NULL,
    [TrancheName]            NVARCHAR (256) NULL,
    [SortOrder]              INT            NULL,
    [IsDeleted]              BIT              DEFAULT ((0)) NULL,
);

go
ALTER TABLE [CRE].[ClientTrancheMapping]
ADD CONSTRAINT PK_ClientTrancheMapping_ClientTrancheMappingID PRIMARY KEY (ClientTrancheMappingID);