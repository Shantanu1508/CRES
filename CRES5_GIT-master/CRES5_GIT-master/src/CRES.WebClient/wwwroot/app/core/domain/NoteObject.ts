import {Note} from "./note";
import {NoteAdditionalList} from "./NoteAdditionalList";

export class NoteObject {
    constructor() {
        this._note = new Note('');
        this._noteextralist = new NoteAdditionalList();
    }

    _note: Note;
    _noteextralist: NoteAdditionalList;
}