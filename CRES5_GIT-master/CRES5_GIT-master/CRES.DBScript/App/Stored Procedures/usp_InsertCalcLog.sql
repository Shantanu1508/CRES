
CREATE PROCEDURE [APP].[usp_InsertCalcLog]
@Msg1 varchar(MAX),
@Msg2 varchar(MAX),
@Msg3 varchar(MAX),
@Msg4 varchar(MAX),
@Msg5 varchar(MAX),
@Msg6 varchar(MAX),
@Msg7 varchar(MAX),
@Msg8 varchar(MAX),
@Msg9 varchar(MAX),
@Msg10 varchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;

  
INSERT INTO [APP].[CalcLog] 
(
Msg1,
Msg2,
Msg3,
Msg4,
Msg5,
Msg6,
Msg7,
Msg8,
Msg9,
Msg10,
CreatedDate) 
VALUES(@Msg1,
@Msg2,
@Msg3,
@Msg4,
@Msg5,
@Msg6,
@Msg7,
@Msg8,
@Msg9,
@Msg10,
getdate())
       
END
