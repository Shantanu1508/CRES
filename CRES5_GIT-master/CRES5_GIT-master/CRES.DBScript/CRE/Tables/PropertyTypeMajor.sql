CREATE TABLE [CRE].[PropertyTypeMajor] (
	[PropertyTypeMajorID]    INT            IDENTITY (1, 1) NOT NULL,     
	PropertyTypeMajorCd  NVARCHAR (256)  NULL,
	PropertyTypeMajorDesc  NVARCHAR (256)  NULL,
	OrderKey int null,
	[IsActive]    bit             NULL,
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL
   
    CONSTRAINT [PK_PropertyTypeMajorID] PRIMARY KEY CLUSTERED ([PropertyTypeMajorID] ASC)
);

