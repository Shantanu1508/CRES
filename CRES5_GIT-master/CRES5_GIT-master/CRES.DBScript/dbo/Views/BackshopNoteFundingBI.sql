
CREATE view [dbo].BackshopNoteFundingBI
as 

Select ControlID,
		DealName,
		FundingDate,
		NoteID,
		ServicerLoanNumber,
		NoteName,
		FinancingSource,
		FundingAmount,
		WireConfirm,
		FundingPurpose,
		RSLIC,
		SNCC,
		PIIC,
		TMR,
		HCC,
		USSIC,
		TMNF,
		HAIH
From dw.BackshopNoteFundingBI

