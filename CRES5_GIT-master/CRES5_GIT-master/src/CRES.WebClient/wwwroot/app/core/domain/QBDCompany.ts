export class QBDCompany {

    public QuickBookCompanyID: number
    public Name: string
    public EndPointID: string
    public AutofyCompanyID: string
    public CreatedBy: string
    public CreatedDate: Date
    public UpdatedBy: string
    public UpdatedDate: Date
    //constructor
    constructor(name: string) {
        this.Name = name;
    }
}
