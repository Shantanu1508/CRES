CREATE TABLE [App].[VMMaster] (
	VMMasterID  INT      IDENTITY (1, 1) NOT NULL,	
	VMName	NVARCHAR (256) NOT NULL,
	IsActive bit null,
	[Status] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,

	CONSTRAINT [PK_VMMasterID] PRIMARY KEY CLUSTERED ([VMMasterID] ASC)
);




