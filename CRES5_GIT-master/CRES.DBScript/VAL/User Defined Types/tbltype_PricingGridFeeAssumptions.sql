CREATE TYPE [VAL].[tbltype_PricingGridFeeAssumptions] AS TABLE (
    [MarkedDate]      DATE             NULL,
    [ValueType]       NVARCHAR (256)   NULL,
    [Nonconstruction] DECIMAL (28, 15) NULL,
    [Construction]    DECIMAL (28, 15) NULL,
    [UserID]          NVARCHAR (256)   NULL);

