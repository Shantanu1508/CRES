"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MsgSpeech = exports.Message = void 0;
var Message = /** @class */ (function () {
    function Message(content, sentBy, messageID, enableLoading) {
        this.content = content;
        this.sentBy = sentBy;
        this.messageID = messageID;
        this.enableLoading = enableLoading;
    }
    return Message;
}());
exports.Message = Message;
var MsgSpeech = /** @class */ (function () {
    function MsgSpeech(Speech, Type, status, intentName) {
        this.Speech = Speech;
        this.Type = Type;
        this.status = status;
        this.intentName = intentName;
    }
    return MsgSpeech;
}());
exports.MsgSpeech = MsgSpeech;
//# sourceMappingURL=BotMessage.js.map