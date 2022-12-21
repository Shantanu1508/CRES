export class FinancingWarehouse {
  public FinancingWarehouseID !: string
  public AccountID !: string
  public Name !: string
  public StatusID !: number
  public StatusIDText !: string
  public IsRevolving !: string
  public IsRevolvingText !: string
  public BaseCurrencyID !: number
  public PayFrequency !: number
  public BaseCurrencyIDText !: string
  public OriginationFee !: number
  public TotalConstraint !: number
  public CreatedBy !: string;
  public CreatedDate !: Date;
  public UpdatedBy !: string;
  public UpdatedDate !: Date;
  lstFinancingWarehouseDetail !: Array<FinancingWarehouseDetail>;
}


export class FinancingWarehouseDetail {
  public FinancingWarehouseDetailID !: string
  public FinancingWarehouseID !: string
  public StartDate !: string
  public EndDate !: string
  public Value !: number
  public CreatedBy !: string;
  public CreatedDate !: Date;
  public UpdatedBy !: string;
  public UpdatedDate !: Date;
}
