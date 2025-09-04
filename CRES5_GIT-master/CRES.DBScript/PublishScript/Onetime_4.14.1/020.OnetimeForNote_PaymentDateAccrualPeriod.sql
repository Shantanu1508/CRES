


---SET PaymentDateAccrualPeriod = Preceding for   Marriott Tacoma Downtown

Update cre.note set PaymentDateAccrualPeriod = 906 where noteid in (

	Select n.noteid from cre.note n
	inner join cre.deal d on d.dealid = n.dealid
	where d.dealid = 'd584b7f9-7d0d-4fed-b18d-99bf6085ea75'

)
