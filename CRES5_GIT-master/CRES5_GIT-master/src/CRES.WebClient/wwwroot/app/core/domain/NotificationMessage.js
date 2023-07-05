"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationMessage = void 0;
var NotificationMessage = /** @class */ (function () {
    function NotificationMessage(message, date, count, UserId, groud) {
        this.Message = message;
        this.Sent = new Date(date);
        this.Count = count;
        this.UserId = UserId;
        this.groud = this.groud;
    }
    return NotificationMessage;
}());
exports.NotificationMessage = NotificationMessage;
//# sourceMappingURL=NotificationMessage.js.map