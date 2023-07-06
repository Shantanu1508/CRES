  
CREATE PROCEDURE [dbo].[usp_InsertCalcV1DataFrame_V1]  
  
@tbltype_CalcV1DataFrame_V1  tbltype_CalcV1DataFrame_V1 READONLY,  
@AnalysisID uniqueidentifier,
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;



IF (@AnalysisID is not null)
BEGIN
  
	Delete from [cre].[CalcV1DataFrame] where analysisid = @AnalysisID and note in (
		Select Distinct  n.crenoteid 
		from @tbltype_CalcV1DataFrame_V1 tr
		inner join cre.note n on n.crenoteid = tr.note
	)
	

	INSERT INTO [cre].[CalcV1DataFrame]
	(  
		Date	,
		Note	,
		initbal	,
		funding_fundpydn	,
		schprin	,
		balloon	,
		endbal	,
		fee_amount	,
		fee_stripped	,
		fee_strip_received	,
		fee_incl_lv_yield	,
		fee_excl_lv_yield	,
		dailyint	,
		stubint	,
		periodint	,
		clsdt	,
		totalcmt	,
		initmatdt	,
		initaccenddt	,
		initpmtdt	,
		ioterm	,
		amterm	,
		rate_valtype	,
		rate_val	,
		rate_intcalcdays	,
		rate_adj_factor	,
		amort_rate_val	,
		amort_rate_intcalcdays	,
		amort_rate_adj_factor	,
		periodstart	,
		periodend	,
		term	,
		io_term_end_date	,
		rem_term	,
		prev_endbal	,
		float_dailyint	,
		cum_dailyint	,
		levyld	,
		gaapbasis	,
		feeamort	,
		[CreatedBy] ,
		[CreatedDate] ,
		[UpdatedBy] ,
		[UpdatedDate] ,
		analysisid  )  
	 Select  
	 Date	,
		Note	,
		initbal	,
		funding_fundpydn	,
		schprin	,
		balloon	,
		endbal	,
		fee_amount	,
		fee_stripped	,
		fee_strip_received	,
		fee_incl_lv_yield	,
		fee_excl_lv_yield	,
		dailyint	,
		stubint	,
		periodint	,
		clsdt	,
		totalcmt	,
		initmatdt	,
		initaccenddt	,
		initpmtdt	,
		ioterm	,
		amterm	,
		rate_valtype	,
		rate_val	,
		rate_intcalcdays	,
		rate_adj_factor	,
		amort_rate_val	,
		amort_rate_intcalcdays	,
		amort_rate_adj_factor	,
		periodstart	,
		periodend	,
		term	,
		io_term_end_date	,
		rem_term	,
		prev_endbal	,
		float_dailyint	,
		cum_dailyint	,
		levyld	,
		gaapbasis	,
		feeamort	, 
		@CreatedBy  ,
		GETDATE()  ,
		@CreatedBy  ,
		GETDATE() ,
		@AnalysisID 
	
	 FROM @tbltype_CalcV1DataFrame_V1  tr
  
 

END
 
  

  
END  