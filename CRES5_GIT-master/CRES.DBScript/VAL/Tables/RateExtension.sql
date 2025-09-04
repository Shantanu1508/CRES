CREATE TABLE [VAL].[RateExtension] (
    [RateExtensionID]		INT	IDENTITY (1, 1)	NOT NULL,
    [MarkedDateMasterID]    INT					NULL,
    [Value]					DECIMAL (28, 15)	NULL,
    [CreatedBy]				NVARCHAR (256)		NULL,
    [CreatedDate]			DATETIME			NULL,
    [UpdateBy]				NVARCHAR (256)		NULL,
    [UpdatedDate]			DATETIME			NULL,
    CONSTRAINT [PK_RateExtension_RateExtensionID] PRIMARY KEY CLUSTERED ([RateExtensionID] ASC),
    CONSTRAINT [FK_RateExtension_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);

