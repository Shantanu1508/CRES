"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NoteObject = void 0;
var note_1 = require("./note");
var NoteAdditionalList_1 = require("./NoteAdditionalList");
var NoteObject = /** @class */ (function () {
    function NoteObject() {
        this._note = new note_1.Note('');
        this._noteextralist = new NoteAdditionalList_1.NoteAdditionalList();
    }
    return NoteObject;
}());
exports.NoteObject = NoteObject;
//# sourceMappingURL=NoteObject.js.map