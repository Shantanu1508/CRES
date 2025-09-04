CREATE TABLE [VAL].[ValueDeclineByPropertyType] (
    [ValueDeclineByPropertyTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID]           INT              NULL,
    [PropertyType]                 NVARCHAR (256)   NULL,
    [ValueDecline]                 DECIMAL (28, 15) NULL,
    [CreatedBy]                    NVARCHAR (256)   NULL,
    [CreatedDate]                  DATETIME         NULL,
    [UpdateBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                  DATETIME         NULL,
    CONSTRAINT [PK_ValueDeclineByPropertyType_ValueDeclineByPropertyTypeID] PRIMARY KEY CLUSTERED ([ValueDeclineByPropertyTypeID] ASC),
    CONSTRAINT [FK_ValueDeclineByPropertyType_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);

