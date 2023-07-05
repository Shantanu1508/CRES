export class Property {
    public PropertyID: string;
    public DealID: string;
    public Deal_DealID: string;
    public PropertyName: string;
    public DealName: string;
    
    public Address: string;
    public City: string;
    public State: number;
    public Zip: number;
    public UWNCF: number;
    public SQFT: number;
    public PropertyType: number;
    public AllocDebtPer: number;
    public PropertySubtype: number;
    public NumberofUnitsorSF: number;
    public Occ: number;
    public Class: string;
    public YearBuilt: string;
    public Renovated: string;
    public Bldgs: number;
    public Acres: string;
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;

    constructor(DealID: string) {

        this.DealID = DealID;

    }

}




        
      
      


        

       