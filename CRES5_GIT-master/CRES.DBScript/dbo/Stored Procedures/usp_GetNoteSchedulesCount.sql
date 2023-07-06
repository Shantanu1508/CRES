

CREATE PROCEDURE [dbo].[usp_GetNoteSchedulesCount] 
AS
Begin
 
                Declare  @BalanceTransactionSchedule  int  =5;
				Declare  @DefaultSchedule  int  =6;
				Declare  @FeeCouponSchedule  int  =7;
				Declare  @FinancingFeeSchedule  int  =8;
				Declare  @FinancingSchedule  int  =9;
				Declare  @FundingSchedule  int  =10;
				Declare  @Maturity  int  =11;
				Declare  @PIKSchedule  int  =12;
				Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
				Declare  @RateSpreadSchedule  int  =14;
				Declare  @ServicingFeeSchedule  int  =15;
				Declare  @StrippingSchedule  int  =16;
				Declare  @PIKScheduleDetail  int  =17;
				Declare  @LIBORSchedule  int  =18;
				Declare  @AmortSchedule  int  =19;
				Declare  @FeeCouponStripReceivable  int  =20;

				--AndAdditionalFeeSchedule related ValueTypeId
				Declare @ExitFee int = 160;
				Declare @PrepaymentFee int = 161;
				Declare @AdditionalFee int = 162;
				Declare @UnusedFee int = 350;



				--===@RateSpreadSchedule===============================
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS RateSpreadSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.RateSpreadSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @RateSpreadSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@RateSpreadSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID
				

				--Stripping
			
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS StrippingSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.StrippingSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @StrippingSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@StrippingSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--FinancingFeeSchedule

				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS FinancingFeeSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.FinancingFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @FinancingFeeSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@FinancingFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--FinancingSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS FinancingSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.FinancingSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @FinancingSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@FinancingSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--DefaultSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS DefaultSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.DefaultSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @DefaultSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@DefaultSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--PIKSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS PIKSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PIKSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PIKSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PIKSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--ServicingFeeSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS ServicingFeeSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.ServicingFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @ServicingFeeSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@ServicingFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--FundingSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS FundingSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.FundingSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @FundingSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@FundingSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--PIKScheduleDetail
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS PIKScheduleDetail  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PIKScheduleDetail r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PIKScheduleDetail
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PIKScheduleDetail AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--LIBORSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS LIBORSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.LIBORSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @LIBORSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@LIBORSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--AmortSchedule
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS AmortSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.AmortSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @AmortSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@AmortSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID
												

				--PrepayAndAdditionalFeeSchedule

				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS PrepayAndAdditionalFeeSchedule  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PrepayAndAdditionalFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PrepayAndAdditionalFeeSchedule
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PrepayAndAdditionalFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--PrepayAndAdditionalFeeSchedule ExitFee

				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS ExitFee  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PrepayAndAdditionalFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PrepayAndAdditionalFeeSchedule
				And r.ValueTypeId = @ExitFee
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PrepayAndAdditionalFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--PrepayAndAdditionalFeeSchedule PrepaymentFee
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS PrepaymentFee  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PrepayAndAdditionalFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PrepayAndAdditionalFeeSchedule
				And r.ValueTypeId = @PrepaymentFee
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PrepayAndAdditionalFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID

				--PrepayAndAdditionalFeeSchedule AdditionalFee
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS AdditionalFee  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PrepayAndAdditionalFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PrepayAndAdditionalFeeSchedule
				And r.ValueTypeId = @AdditionalFee
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PrepayAndAdditionalFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID


				--PrepayAndAdditionalFeeSchedule UnusedFee
				SELECT  n.CRENoteID, COUNT(n.CRENoteID) AS UnusedFee  FROM cre.Note  n
				INNER JOIN  core.Account ac ON ac.AccountID = n.Account_AccountID
				INNER JOIn CORE.Event e ON e.AccountID = ac.AccountID
				INNER JOIN core.PrepayAndAdditionalFeeSchedule r ON r.EventId = e.EventId
				WHERE E.EventTypeID = @PrepayAndAdditionalFeeSchedule
				And r.ValueTypeId = @UnusedFee
				AND ISNULL(e.StatusID,1)=1
		        AND e.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = ac.Accountid and EventTypeID=@PrepayAndAdditionalFeeSchedule AND StatusID=1)
				GROUP BY n.CRENoteID 
				HAVING COUNT(n.CRENoteID) > 1
				ORDER BY n.CRENoteID
				
END


