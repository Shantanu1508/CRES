CREATE TABLE [Core].[PrepayAndAdditionalFeeScheduleLiabilityDetail] (
    [PrepayAndAdditionalFeeScheduleLiabilityDetailID]	UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [PrepayAndAdditionalFeeScheduleLiabilityID]			UNIQUEIDENTIFIER NOT NULL,
    [FROM]												DECIMAL (28, 12) NULL,
    [TO]												DECIMAL (28, 12) NULL,
    [Value]												DECIMAL (28, 12) NULL,
    [CreatedBy]											NVARCHAR (256)   NULL,
    [CreatedDate]										DATETIME         NULL,
    [UpdatedBy]											NVARCHAR (256)   NULL,
    [UpdatedDate]										DATETIME         NULL
);