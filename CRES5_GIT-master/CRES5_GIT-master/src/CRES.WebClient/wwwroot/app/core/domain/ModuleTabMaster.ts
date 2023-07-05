export class ModuleTabMaster {

    ModuleTabMasterID: number
    ModuleTabName: string
    ParentID: number
    StatusID: number
    SortOrder: number
    DisplayName: string
    ModuleType: string

    IsEdit: boolean
    IsView: boolean
    IsDelete: boolean
    RoleID: string
    constructor(ModuleTabName: string) {

        this.ModuleTabName = ModuleTabName;
      
    }

}