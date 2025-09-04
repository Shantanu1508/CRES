"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TemplateName = exports.JsonTemplate = exports.NoteMarketPrice = exports.Servicer = exports.DownloadCashFlow = exports.ServicingLog = exports.TagMasterXIRR = exports.Note = void 0;
var Note = /** @class */ (function () {
    function Note(DealID) {
        this.IsSingleNoteClac = false;
        this.DealID = DealID;
    }
    return Note;
}());
exports.Note = Note;
var TagMasterXIRR = /** @class */ (function () {
    function TagMasterXIRR() {
    }
    return TagMasterXIRR;
}());
exports.TagMasterXIRR = TagMasterXIRR;
var ServicingLog = /** @class */ (function () {
    function ServicingLog() {
    }
    return ServicingLog;
}());
exports.ServicingLog = ServicingLog;
var DownloadCashFlow = /** @class */ (function () {
    function DownloadCashFlow() {
    }
    return DownloadCashFlow;
}());
exports.DownloadCashFlow = DownloadCashFlow;
var Servicer = /** @class */ (function () {
    function Servicer(ServicerMasterID, ServicerDropDate, RepaymentDropDate) {
        this.ServicerMasterID = ServicerMasterID;
        this.ServicerDropDate = ServicerDropDate;
        this.RepaymentDropDate = RepaymentDropDate;
    }
    return Servicer;
}());
exports.Servicer = Servicer;
var NoteMarketPrice = /** @class */ (function () {
    function NoteMarketPrice() {
    }
    return NoteMarketPrice;
}());
exports.NoteMarketPrice = NoteMarketPrice;
var JsonTemplate = /** @class */ (function () {
    function JsonTemplate() {
    }
    return JsonTemplate;
}());
exports.JsonTemplate = JsonTemplate;
var TemplateName = /** @class */ (function () {
    function TemplateName() {
    }
    return TemplateName;
}());
exports.TemplateName = TemplateName;
//# sourceMappingURL=note.model.js.map