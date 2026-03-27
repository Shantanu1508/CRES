CREATE PROCEDURE [dbo].[usp_UpdateWFCheckListForOutstandingDrawFees]
(
	@TaskTypeID int,
	@DealID nvarchar(256),
	@UserID nvarchar(256)
)
AS  
BEGIN 
   DECLARE @TotalPendingInvoice int=0,@TotalPaidInvoice int=0,@CountInvoice int=0
   DECLARE @tblInvoice AS TABLE
	(
	  TaskID uniqueidentifier,
	  DrawFeeStatus INT,
	  Amount DECIMAL(28,15),
	  [Date] datetime
	)

	DECLARE @tblWF AS TABLE
	(
	  DealFundingID uniqueidentifier
	)
	    INSERT INTO @tblInvoice
		SELECT TaskID,DrawFeeStatus,ISNULL(i.Amount,0),df.Date FROM cre.InvoiceDetail i 
		join cre.dealfunding df ON i.ObjectID=df.DealFundingID
		join cre.Deal d ON d.DealID=df.DealID
		and i.InvoiceTypeID=558 and i.ObjectTypeID=698 
		WHERE d.DealID=@DealID
		and d.IsDeleted = 0

		INSERT INTO @tblWF
		SELECT df.DealFundingID from cre.dealfunding df join cre.Deal d ON d.DealID=df.DealID
		WHERE d.DealID=@DealID
		and d.IsDeleted = 0

		
		select @TotalPendingInvoice=count(1) from @tblInvoice where DrawFeeStatus=693 and dateadd(d,3,[Date])<getdate()
		select @TotalPaidInvoice=count(1) from @tblInvoice where DrawFeeStatus=694
		select @CountInvoice=count(1) from @tblInvoice
		IF (@CountInvoice=0)
		BEGIN
		  update cre.WFCheckListdetail set cre.WFCheckListdetail.CheckListStatus=501  
		  from(
		  	SELECT DealFundingID from @tblWF
		  ) tbl
		  where cre.WFCheckListdetail.TaskTypeID=502 and cre.WFCheckListdetail.WFCheckListMasterID=19 and 
		  cre.WFCheckListdetail.TaskId=tbl.DealFundingID
		END

		ELSE IF (@TotalPendingInvoice>0)
		 BEGIN
		  update cre.WFCheckListdetail set cre.WFCheckListdetail.CheckListStatus=874  
		  from(
		  	SELECT DealFundingID from @tblWF
		  ) tbl
		  where cre.WFCheckListdetail.TaskTypeID=502 and cre.WFCheckListdetail.WFCheckListMasterID=19 and 
		  cre.WFCheckListdetail.TaskId=tbl.DealFundingID
			
		 END
		 ELSE IF (@TotalPaidInvoice>0)
		 BEGIN
		  update cre.WFCheckListdetail set cre.WFCheckListdetail.CheckListStatus=873  
		  from(
		  	SELECT DealFundingID from @tblWF
		  ) tbl
		  where cre.WFCheckListdetail.TaskTypeID=502 and cre.WFCheckListdetail.WFCheckListMasterID=19 and 
		  cre.WFCheckListdetail.TaskId=tbl.DealFundingID
		 END
		 ELSE
		 BEGIN
		
		  update cre.WFCheckListdetail set cre.WFCheckListdetail.CheckListStatus=501  
		  from(
		  	SELECT DealFundingID from @tblWF
		  ) tbl
		  where cre.WFCheckListdetail.TaskTypeID=502 and cre.WFCheckListdetail.WFCheckListMasterID=19 and 
		  cre.WFCheckListdetail.TaskId=tbl.DealFundingID

		 END

END
