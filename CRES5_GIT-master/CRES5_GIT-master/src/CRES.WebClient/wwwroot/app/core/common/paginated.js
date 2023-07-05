"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Paginated = void 0;
var Paginated = /** @class */ (function () {
    function Paginated(pageSize, pageIndex, totalCount) {
        this._pageSize = 0;
        this._pageIndex = 0;
        this._totalCount = 0;
        this._pageSize = pageSize;
        this._pageIndex = pageIndex;
        this._totalCount = totalCount;
    }
    Paginated.prototype.pagePlus = function (count) {
        return +this._pageIndex + count;
    };
    Paginated.prototype.search = function (i) {
        this._pageIndex = i;
    };
    ;
    return Paginated;
}());
exports.Paginated = Paginated;
//# sourceMappingURL=paginated.js.map