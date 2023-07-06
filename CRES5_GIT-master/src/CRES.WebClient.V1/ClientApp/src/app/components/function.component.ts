import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";
import { Router, ActivatedRoute } from '@angular/router';
import { functionService } from '../core/services/function.service';
import { NgModule } from '@angular/core';
import { UtilityService } from '../core/services/utility.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { WjCoreModule } from '@grapecity/wijmo.angular2.core';
import { WjGridModule } from '@grapecity/wijmo.angular2.grid';
import { WjGridFilterModule } from '@grapecity/wijmo.angular2.grid.filter';
declare var $: any;
@Component({
  selector: "function",
  templateUrl: "./function.html",
  providers: [functionService]
})

export class FunctionComponent implements OnInit {
  public data: any;
  public data1: any;
  public lstFolders: any;
  public _isListFetching !: boolean;
  public _isCopyShow !: boolean;
  public _currentFileName !: string
  public _isSaveFile !: boolean;
  public _isDeployZip !: boolean;
  public foldername: string;
  public DestFolder !: string;
  zipfiles: any = [];
  public zipfilename: string;
  public _isDefault: boolean = false;
  lstFolderFromDB: any;

  constructor(public functionServiceSrv: functionService,
    public utilityService: UtilityService,
    private _router: Router) {
    $.getScript("/js/editorfunction.js");
    this.getFastFolderListFromDB();
    this.getFolderList();
    //this.getFileList();
    this.utilityService.setPageTitle("M61–Files");
    this.foldername = "Select";
    this.zipfilename = "Select Zip File";
    //   this.zipfiles:any = [];
    //=new Array<string>();

  }

  getFileList(): void {

    this._isListFetching = true;
    this.functionServiceSrv.getfiles()
      .subscribe(res => {

        this.data = res;
        this._isListFetching = false;
      },
        error => {
          this.utilityService.navigateToSignIn();
        }

      );
  }

  getFile(filename: string): void {
    this._currentFileName = filename;
    this._isListFetching = true;
    this.functionServiceSrv.getfile(filename)
      .subscribe(res => {
        this._isListFetching = false;
        localStorage.setItem('editorData', res._body)
        setTimeout("setData()", 500)
        this._isSaveFile = true;

      },
        error => {
          alert('error')
          //this.utilityService.navigateToSignIn();
          this._isListFetching = false;
        }

      );
  }

  ngOnInit() {
    // get return url from route parameters or default to '/'
    $('#mainSpliter').enhsplitter({ handle: 'lotsofdots', position: 435, leftMinSize: 0, fixed: false });
  }


  getFolderList(): void {

    this._isListFetching = true;
    this.functionServiceSrv.getfolders()
      .subscribe(res => {

        this.lstFolders = res;
        this._isListFetching = false;

      },
        error => {
          this.utilityService.navigateToSignIn();
        }

      );
  }

  getFastFolderListFromDB(): void {


    this.functionServiceSrv.getallFastFunction()
      .subscribe(res => {

        if (res != null && res.length > 0) {
          this.lstFolderFromDB = res;
        }

      },
        error => {

        }

      );
  }

  getFileListByFolder(): void {
    this.zipfiles = [];
    this._isListFetching = true;
    this.functionServiceSrv.getfilesbyfolder(this.foldername)
      .subscribe(res => {
        if (res != null && res.length > 0) {

          this.data = res;
          this._isCopyShow = true;

          for (var i = 0; i < this.data.length; i++) {
            if (this.data[i].replace(/^.*\./, '') == 'zip') {
              this.zipfiles.push(this.data[i]);
              this._isDeployZip = true;
            }
          }

          //$.each(this.data, function (key, value) {
          //    if (value.replace(/^.*\./, '') == 'zip') {
          //        if (this.zipfiles == undefined)
          //        {
          //            this.data1
          //            this.zipfiles = ["Select File"];
          //        }

          //        this.zipfiles.push(key);
          //    }
          //});

          console.log(this.zipfiles);
        }
        else {
          this._isCopyShow = false;
        }
        this._isListFetching = false;

      },
        error => {
          this.utilityService.navigateToSignIn();
        }

      );
  }

  cloneFolder(): void {

    if (this.foldername == 'Select') {
      alert('Please select source folder')
    }
    else if (this.DestFolder == '' || this.DestFolder == undefined) {
      alert('Please enter destinatio folder name')
    }
    else {

      this._isListFetching = true;
      this.functionServiceSrv.clonefolder(this.foldername, this.DestFolder)
        .subscribe(res => {

          this._isListFetching = false;
          alert('Folder copied successfully');
        },
          error => {
            alert('Error in copy folder');
            this.utilityService.navigateToSignIn();
          }

        );
    }

  }

  createZip(): void {

    if (this.foldername == 'Select') {
      alert('Please select source folder')
    }
    else {

      this._isListFetching = true;
      this.functionServiceSrv.createzip(this.foldername)
        .subscribe(res => {
          this.getFileListByFolder();
          this._isListFetching = false;
          alert('Zip created successfully');
        },
          error => {
            alert('Error in creating zip');
            this.utilityService.navigateToSignIn();
          }

        );
    }

  }

  ChangeFolder(newvalue:any): void {
    this.foldername = newvalue.target.value;
    this.data = null;
    if (newvalue != 'Select') {
      this.lstFolderFromDB.filter

      var folderexist = this.lstFolderFromDB.filter((x:any) => x.FunctionName == newvalue);
      if (folderexist != null && folderexist.length > 0) {
        this._isDefault = folderexist[0].IsDefault;
      }
      else {
        this._isDefault = false;
      }
      this.getFileListByFolder()
    }
    else {
      this._isCopyShow = false;
      this._isDefault = false;
    }

  }

  ChangeZipFile(newvalue:any): void {
    this.zipfilename = newvalue.target.value;
  }

  onChangeDefaultcheck(newvalue: any) {
    this._isDefault = newvalue.value;
  }


  updateFile(): void {

    this._isListFetching = true;
    setTimeout('getData()', 100);

    setTimeout(() => {
      var fileContent = localStorage.getItem('editorOut')
      var parameters = {
        FileName: this._currentFileName,
        FileContent: fileContent,
        FunctionName: this.foldername,
        IsDefault: this._isDefault
      }

      this.functionServiceSrv.updateFileFunction(parameters).subscribe(res => {
        this.getFastFolderListFromDB();
        this._isListFetching = false;
        alert('File saved successfully');
      }, error => {
        this._isListFetching = false;
        alert(error);
      });
    }, 200)

  }

  deployZip(): void {
    if (this.zipfilename == 'Select Zip File') {
      alert('Please select zip file to deploy')
    }
    else {

      this._isListFetching = true;
      this.functionServiceSrv.deployZip(this.foldername, this.zipfilename)
        .subscribe(res => {
          this._isListFetching = false;
          alert('zip deploy successfully');
        },
          error => {
            alert('Error in deploying zip');
            this.utilityService.navigateToSignIn();
          }

        );
    }

  }

  createFunction(): void {

    if (this.DestFolder == '' || this.DestFolder == undefined) {
      alert('Please enter function name')
    }
    else {
      this._isListFetching = true;
      var parameters = {
        SourceName: this.foldername,
        DestName: this.DestFolder,
        IsDefault: this._isDefault
      }

      this.functionServiceSrv.createFunction(parameters)
        .subscribe(res => {

          this._isListFetching = false;
          this.ClosePopUpCreateCopy();
          this.getFastFolderListFromDB();
          this.getFolderList();
          alert('function Created successfully');
          this._isDefault = false;
        },
          error => {
            alert('Error in creating function');
            this.utilityService.navigateToSignIn();
          }

        );

    }
  }

  updateFunction(): void {

    if (this.foldername == 'Select') {
      alert('Please select source folder')
    }
    else {
      this._isListFetching = true;
      var parameters = {
        SourceName: this.foldername,
        DestName: this.DestFolder,
        IsDefault: this._isDefault
      }

      this.functionServiceSrv.updateFunction(parameters)
        .subscribe(res => {

          this._isListFetching = false;
          alert('function updated successfully');
          this._isDefault = false;
        },
          error => {
            alert('Error in updating function');
            this.utilityService.navigateToSignIn();
          }
        );
    }
  }


  invokeFunction(): void {

    if (this.foldername == 'Select') {
      alert('Please select source folder')
    }
    else {
      this._isListFetching = true;
      var inputjson =
      {
        "JsonData": {
          "Deal": {
            "size": "44200000.00",
            "name": "StewModelTieout",
            "description": "Stew Model Tie Out 20160718 excel file",
            "id": "12341234",
            "issueDate": "20161020",
            "settlementDate": "20161020",
            "firstPayDate": "20161108",
            "calculationFrequency": "dynamic",
            "calculateDeal": "dealSimStandard"
          },
          "Notes": [{
            "name": "A",
            "type": "Note",
            "description": "A Note",
            "id": "11115",
            "InitialFundingAmount": 17100000.00,
            "balanceTarget": 22100000.00,
            "paymentFrequency": "monthly",
            "dayCount": "30360",
            "rateType": "floating",
            "rateIndex": "L30",
            "spreadCash": 0.025,
            "spreadMaintain": 0.025,
            "amRate": 0.052,
            "amTerm": 360,
            "ioTerm": 36,
            "loanTerm": 60,
            "stubAdvance": "true",
            "originationFee": 0.01,
            "exitFee": 0.01,
            "extensionFee": 0.01,
            "extensionTerm": 18,
            "minimumFee": 0.01,
            "additionalPik": 0,
            "maturityDate": "20220120",
            "closingDate": "20170120",
            "registers": ["eopBal", "principal", "interest"],
            "calculateAccount": "loanSimStandard",
            "settlementDate": "20170123",
            "PayFrequency": "M"
          }
          ],
          "Accounts": [{
            "name": "EQUITYACORE",
            "type": "Entity",
            "description": "ACORE Lender Account",
            "id": "21115",
            "balanceInit": 0,
            "registers": ["cash"]
          },
          {
            "name": "EQUITYDELPHI",
            "type": "Entity",
            "description": "DELPHI Lender Account",
            "id": "21116",
            "balanceInit": 0,
            "registers": ["cash"]
          },
          {
            "name": "BORROWERCASH",
            "type": "Entity",
            "description": "Borrower Account",
            "id": "21117",
            "balanceInit": 0,
            "registers": ["cash"]
          }],
          "variables": [{
            "arbitrary2DArrayxxxxx": [
              [0, 10],
              [30, 50],
              [90, 100]
            ]
          },
          {
            "asOfDate": "20160901"
          }
          ],
          "Rules": [
            {
              "Name": "1",
              "description": "Transfer $1038483 from Note 123 to Entity 232043 on Settlement Date of Note 123",
              "when": {
                "condition": "Period",
                "conditionParameters": {
                  "type": "Note",
                  "id": "11115",
                  "attribute": "settlementDate"
                }
              },
              "action": {
                "Name": "Transfer",
                "actionParameters": {
                  "Amount": "1038483",
                  "From": {
                    "type": "Note",
                    "id": "11115"
                  },
                  "To": {
                    "type": "Entity",
                    "id": "21115"
                  }
                }
              },
              "priority": "6"
            },
            {
              "Name": "2",
              "description": "Calculate Note 123 for every period",
              "when": "",
              "action": {
                "actionHandler": "Note",
                "Name": "Calculate",
                "actionParameters": {
                  "type": "Note",
                  "id": "11115"
                }
              },
              "priority": "5"
            }
          ]
        }
      }




      //this._isCalcJsonFetched = true;
      var parameters = {
        FunctionName: this.foldername,
        PlayLoad: JSON.stringify(inputjson)
      }
      this.functionServiceSrv.invokeFunction(parameters)
        .subscribe(res => {

          this._isListFetching = false;
          if (res != "")
            alert(res);
          else
            alert('Error-Something went wrong');
        },
          error => {
            alert('Error-Something went wrong');
            this.utilityService.navigateToSignIn();
          }
        );
    }
  }

  showDialogCreateCopy(): void {
    if (this.foldername == 'Select') {
      alert('Please select version')
    }
    else {
      var modal:any = document.getElementById('myModalCreateCopy');
      modal.style.display = "block";
      $.getScript("/js/jsDrag.js");
    }
  }

  ClosePopUpCreateCopy(): void {

    this.DestFolder = "";
    var modal:any = document.getElementById('myModalCreateCopy');
    $('#txtNoteJsonForScriptEngine').val('');
    $('#txtNoteJsonResponseForScriptEngine').val('');
    modal.style.display = "none";

  }

  updateAndDeploy(): void {

    if (this.foldername == 'Select') {
      alert('Please select version')
    }
    else {

      this._isListFetching = true;
      setTimeout('getData()', 100);

      setTimeout(() => {
        var fileContent = localStorage.getItem('editorOut')
        var parameters = {
          FileName: this._currentFileName,
          FileContent: fileContent
        }

        this.functionServiceSrv.updateFile(parameters).subscribe(res => {
          //update
          this._isListFetching = true;
          var parameters = {
            SourceName: this.foldername,
            DestName: this.DestFolder,
            IsDefault: this._isDefault
          }

          this.functionServiceSrv.updateFunction(parameters)
            .subscribe(res => {
              this.DeployFunction();
              this.getFastFolderListFromDB();
            },
              error => {
                alert('Error in updating function');
                this.utilityService.navigateToSignIn();
              }
            );
          //
        }, error => {
          this._isListFetching = false;
          alert(error);
        });
      }, 200)
    }
  }

  DeployFunction(): void {

    if (this.foldername == 'Select') {
      alert('Please select version')
    }
    else {
      //this._isCalcJsonFetched = true;
      var parameters = {
        FunctionName: this.foldername
      }
      this.functionServiceSrv.invokeFunction(parameters)
        .subscribe(res => {
          //this._isDefault = false;
          this._isListFetching = false;
          if (res != "")
            alert(res);
          else
            alert('Error-Something went wrong');
        },
          error => {
            alert('Error-Something went wrong');
            this.utilityService.navigateToSignIn();
          }
        );
    }
  }

}

const routes: Routes = [

  { path: '', component: FunctionComponent }]

@NgModule({
  imports: [FormsModule, CommonModule, RouterModule.forChild(routes), WjCoreModule, WjGridModule, WjGridFilterModule],
  declarations: [FunctionComponent]
})

export class functionModule { }
