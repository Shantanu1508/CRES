IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'intonlynote')
BEGIN
	Insert into cre.jsonformatcalcv1 (Type,[Key],Position,DataType,IsActive) values ('dictionary','intonlynote','data.notes.setup.dictionary','int',1)	
END

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'const_pi_flag')
BEGIN
	Insert into cre.jsonformatcalcv1 (Type,[Key],Position,DataType,IsActive) values ('dictionary','const_pi_flag','data.notes.setup.dictionary','int',1)	
END

IF NOT EXISTS(Select * from cre.jsonformatcalcv1 where [Type] = 'dictionary' and [key] = 'pmtdtaccper')
BEGIN
	Insert into cre.jsonformatcalcv1 (Type,[Key],Position,DataType,IsActive) values ('dictionary','pmtdtaccper','data.notes.setup.dictionary','int',1)	
END