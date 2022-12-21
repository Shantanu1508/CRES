"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RuleType = exports.ScenarioUserMap = exports.Scenariosearch = exports.Scenario = void 0;
var Scenario = /** @class */ (function () {
    function Scenario(AnalysisID) {
        this.AnalysisID = AnalysisID;
        this.LstScenarioUserMap = new Array();
    }
    return Scenario;
}());
exports.Scenario = Scenario;
var Scenariosearch = /** @class */ (function () {
    function Scenariosearch() {
    }
    return Scenariosearch;
}());
exports.Scenariosearch = Scenariosearch;
var ScenarioUserMap = /** @class */ (function () {
    function ScenarioUserMap(AnalysisID) {
        this.AnalysisID = AnalysisID;
    }
    return ScenarioUserMap;
}());
exports.ScenarioUserMap = ScenarioUserMap;
var RuleType = /** @class */ (function () {
    function RuleType() {
    }
    return RuleType;
}());
exports.RuleType = RuleType;
//# sourceMappingURL=Scenario.js.map