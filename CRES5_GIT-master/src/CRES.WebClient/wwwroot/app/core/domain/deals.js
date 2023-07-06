"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PrepayProjection = exports.FeeCredits = exports.MinMultSchedule = exports.SpreadMaintenanceSchedule = exports.PrepayAdjustment = exports.PrepaymentPremium = exports.AutoRepaymentNoteBalances = exports.AutoRepaymentBalances = exports.ProjectedPayoffDate = exports.AutoEquity = exports.DealAdjustedTotalCommitmentTab = exports.NoteAmort = exports.Amort = exports.NoteAmortization = exports.DealAmortization = exports.AutoSpreadRule = exports.PayruleSetMaster = exports.NoteDetailFunding = exports.NoteSequence = exports.Notefunding = exports.DealFunding = exports.deals = void 0;
var deals = /** @class */ (function () {
    function deals(DealID) {
        this.Flag_DealFundingSave = false;
        this.Flag_NoteSaveFromDealDetail = false;
        this.Flag_DealAmortSave = false;
        this.ListFeeInvoice = [];
        this.MaturityList = [];
        this.ReserveAccountList = [];
        this.ReserveScheduleList = [];
        this.DealID = DealID;
        this.amort = new Amort();
        this.PrepaymentPremium = new PrepaymentPremium();
    }
    return deals;
}());
exports.deals = deals;
var DealFunding = /** @class */ (function () {
    function DealFunding(DealID) {
        this.DealID = DealID;
    }
    return DealFunding;
}());
exports.DealFunding = DealFunding;
var Notefunding = /** @class */ (function () {
    function Notefunding() {
    }
    return Notefunding;
}());
exports.Notefunding = Notefunding;
var NoteSequence = /** @class */ (function () {
    function NoteSequence() {
        this.Ratio = 0;
    }
    return NoteSequence;
}());
exports.NoteSequence = NoteSequence;
var NoteDetailFunding = /** @class */ (function () {
    function NoteDetailFunding() {
    }
    return NoteDetailFunding;
}());
exports.NoteDetailFunding = NoteDetailFunding;
var PayruleSetMaster = /** @class */ (function () {
    function PayruleSetMaster() {
    }
    return PayruleSetMaster;
}());
exports.PayruleSetMaster = PayruleSetMaster;
var AutoSpreadRule = /** @class */ (function () {
    function AutoSpreadRule() {
    }
    return AutoSpreadRule;
}());
exports.AutoSpreadRule = AutoSpreadRule;
var DealAmortization = /** @class */ (function () {
    function DealAmortization() {
    }
    return DealAmortization;
}());
exports.DealAmortization = DealAmortization;
var NoteAmortization = /** @class */ (function () {
    function NoteAmortization() {
    }
    return NoteAmortization;
}());
exports.NoteAmortization = NoteAmortization;
//export class PayruleDealFunding {
//    public DealFundingID: string;
//    public DealID: string;
//    public Date: Date;
//    public Value: number;
//    public Comment: string;
//    public PurposeID: number;
//    public PurposeText: string;
//    public CreatedBy: string;
//    public CreatedDate: Date;
//    public UpdatedBy: string;
//    public UpdatedDate: Date;
//}
var Amort = /** @class */ (function () {
    function Amort() {
    }
    return Amort;
}());
exports.Amort = Amort;
var NoteAmort = /** @class */ (function () {
    function NoteAmort() {
    }
    return NoteAmort;
}());
exports.NoteAmort = NoteAmort;
var DealAdjustedTotalCommitmentTab = /** @class */ (function () {
    function DealAdjustedTotalCommitmentTab() {
    }
    return DealAdjustedTotalCommitmentTab;
}());
exports.DealAdjustedTotalCommitmentTab = DealAdjustedTotalCommitmentTab;
var AutoEquity = /** @class */ (function () {
    function AutoEquity() {
    }
    return AutoEquity;
}());
exports.AutoEquity = AutoEquity;
var ProjectedPayoffDate = /** @class */ (function () {
    function ProjectedPayoffDate() {
    }
    return ProjectedPayoffDate;
}());
exports.ProjectedPayoffDate = ProjectedPayoffDate;
var AutoRepaymentBalances = /** @class */ (function () {
    function AutoRepaymentBalances() {
    }
    return AutoRepaymentBalances;
}());
exports.AutoRepaymentBalances = AutoRepaymentBalances;
var AutoRepaymentNoteBalances = /** @class */ (function () {
    function AutoRepaymentNoteBalances() {
    }
    return AutoRepaymentNoteBalances;
}());
exports.AutoRepaymentNoteBalances = AutoRepaymentNoteBalances;
var PrepaymentPremium = /** @class */ (function () {
    function PrepaymentPremium() {
    }
    return PrepaymentPremium;
}());
exports.PrepaymentPremium = PrepaymentPremium;
var PrepayAdjustment = /** @class */ (function () {
    function PrepayAdjustment() {
    }
    return PrepayAdjustment;
}());
exports.PrepayAdjustment = PrepayAdjustment;
var SpreadMaintenanceSchedule = /** @class */ (function () {
    function SpreadMaintenanceSchedule() {
    }
    return SpreadMaintenanceSchedule;
}());
exports.SpreadMaintenanceSchedule = SpreadMaintenanceSchedule;
var MinMultSchedule = /** @class */ (function () {
    function MinMultSchedule() {
    }
    return MinMultSchedule;
}());
exports.MinMultSchedule = MinMultSchedule;
var FeeCredits = /** @class */ (function () {
    function FeeCredits() {
    }
    return FeeCredits;
}());
exports.FeeCredits = FeeCredits;
var PrepayProjection = /** @class */ (function () {
    function PrepayProjection() {
    }
    return PrepayProjection;
}());
exports.PrepayProjection = PrepayProjection;
//# sourceMappingURL=deals.js.map