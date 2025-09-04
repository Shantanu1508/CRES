
--	DROP Procedure [dbo].[usp_InsertPrepayAndAdditionalFeeScheduleLiabilityDetail] ;

--	DROP TYPE [dbo].[TableTypePrepayAndAdditionalFeeScheduleLiabilityDetail];

CREATE TYPE [dbo].[TableTypePrepayAndAdditionalFeeScheduleLiabilityDetail] AS TABLE (
    [AccountID]				UNIQUEIDENTIFIER ,
	[AdditionalAccountID]   UNIQUEIDENTIFIER ,
	[EventID]				UNIQUEIDENTIFIER ,
	[EffectiveDate]			DATE,
	[ValueTypeID]			INT,
	[StartDate]				DATE,
	[FROM]					DECIMAL (28, 12),
    [TO]					DECIMAL (28, 12),
    [Value]					DECIMAL (28, 12)
);