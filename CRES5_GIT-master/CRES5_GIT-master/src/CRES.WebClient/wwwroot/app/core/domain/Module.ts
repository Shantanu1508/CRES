export class Module {

    public UserId: string;
    public ModuleName: string;
    public ModuleID: string;
    public DealID: string;
    public LookupID: number;

    constructor(ModuleID: string) {
        this.ModuleID = ModuleID;
    }
}