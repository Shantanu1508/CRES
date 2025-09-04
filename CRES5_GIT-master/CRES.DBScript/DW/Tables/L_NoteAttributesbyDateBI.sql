CREATE TABLE [dW].[L_NoteAttributesbyDateBI] (
	L_NoteAttributesbyDate_AutoID int IDENTITY(1,1) not null,
    [NoteID]      NVARCHAR (256)   NULL,
    [Date]        DATETIME         NULL,
    [Value]       DECIMAL (28, 15) NULL,
    [ValueTypeID] INT              NULL,
    [ValueTypeBI] NVARCHAR (256)   NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         DEFAULT (getdate()) NULL,
    [GeneratedBy] INT              NULL,
    [GeneratedByBI] NVARCHAR (256)   NULL,
    NoteAttributesbyDateID int 

	CONSTRAINT [PK_L_NoteAttributesbyDate_AutoID] PRIMARY KEY CLUSTERED (L_NoteAttributesbyDate_AutoID ASC),
);