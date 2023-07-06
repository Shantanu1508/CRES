export class ruletype
{

   public  RuleTypeMasterID: number;
   public  RuleTypeName: string;
   public  RuleTypeDetailID: number;
   public  FileName: string;
   public  Type: string;
   public  Comments: string;
   public  DBFileName: string;
   public  Content: string;
    public IsBalanceAware: boolean;

    constructor(name: string) {
        this.RuleTypeName = name;
    }
}


