import { User } from './user';


export class OperationResult {
    Succeeded: boolean;
    Message: string;
    Token: string;
    UserData: User;
    

    constructor(succeeded: boolean, message: string, token: string, user: User) {
        this.Succeeded = succeeded;
        this.Message = message;
        this.Token = token;
    
        
        
    }
}