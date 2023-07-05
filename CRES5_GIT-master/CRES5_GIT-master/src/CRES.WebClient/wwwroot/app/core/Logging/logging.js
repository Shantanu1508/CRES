"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Logging = void 0;
var loggingService_1 = require("../services/loggingService");
var core_1 = require("@angular/core");
var Logging = /** @class */ (function () {
    function Logging(loggingService) {
        this.loggingService = loggingService;
    }
    Logging.prototype.writeToLog = function (module, logtype, logtext) {
        //var text = module + "||" + logtype + "||" + logtext;
        //this.loggingService.writeToLog(text).subscribe(res => {
        //    if (res.Succeeded) {
        //    }
        //    else {
        //    }
        //});
    };
    Logging = __decorate([
        core_1.Component({
            providers: [loggingService_1.LoggingService]
        }),
        __metadata("design:paramtypes", [loggingService_1.LoggingService])
    ], Logging);
    return Logging;
}());
exports.Logging = Logging;
//# sourceMappingURL=logging.js.map