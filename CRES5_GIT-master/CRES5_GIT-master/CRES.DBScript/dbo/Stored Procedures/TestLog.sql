create procedure [dbo].TestLog
(
  @LogMessage varchar(max)
)
as
begin
 insert into cre.TestLog(LogMessage) values(@LogMessage)
end
