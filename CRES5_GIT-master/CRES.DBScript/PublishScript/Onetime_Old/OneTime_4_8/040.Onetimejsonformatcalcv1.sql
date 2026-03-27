IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'noteactuals' and [Key] = 'comment')
BEGIN	
	INSERT INTO cre.jsonformatcalcv1([Type],[Key],Position,DataType,IsActive)
	Values('noteactuals','comment','data.notes.actuals','nvarchar(256)',1)
END



