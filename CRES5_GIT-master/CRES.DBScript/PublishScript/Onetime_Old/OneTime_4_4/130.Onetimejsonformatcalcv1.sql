
IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'sourcetype')
BEGIN	
	INSERT INTO cre.jsonformatcalcv1([Type],[Key],Position,DataType,IsActive)
	Values('noteactuals','sourcetype','data.notes.actuals','nvarchar(256)',1)
END

