CREATE TYPE [dbo].[tblPrepayAdjustment] AS TABLE (
PrepayAdjustmentId	int null,
Date	date null,
PrepayAdjAmt	decimal(28,15) null,
Comment	nvarchar(max),
Isdeleted int
);
