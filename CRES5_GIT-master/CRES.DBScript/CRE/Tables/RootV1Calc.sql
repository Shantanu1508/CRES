CREATE TABLE [CRE].[RootV1Calc] (
[RootV1CalcID]    INT IDENTITY (1, 1) NOT NULL,
calc_basis bit,
calc_deffee_basis bit,
calc_disc_basis bit,
calc_capcosts_basis bit,
batch bit,
--init_logging bit,
engine nvarchar(50)

CONSTRAINT [PK_RootV1CalcID] PRIMARY KEY CLUSTERED ([RootV1CalcID] ASC)
);

-------------------------sp---------------------------------