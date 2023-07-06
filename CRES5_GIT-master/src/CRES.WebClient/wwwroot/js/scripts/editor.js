/**
 * Editor: Holds the editor and its operations
 */


function Editor () {
  
  this.mode = 'ace/mode/python';
  this.editor = ace.edit('editor',this.mode);
  this.editor.setTheme("ace/theme/monokai");
  // Inititalize fileManager
  this.fileManager = new FileManager();
  // Start event listeners
  editorUI.startEventListeners();
}

/**
 * Editor's file operations
 */
Editor.prototype.addFile = function (filename) {
  var self = this;
  var check = this.fileManager.addFile(filename, function () {
    return ace.createEditSession('',this.mode);
  });

  if (check) {
    editorUI.createFile(filename);
    this.selectFile(filename);
  }
};

Editor.prototype.removeFile = function (filename) {
  return this.fileManager.removeFile(filename);
};

Editor.prototype.setValueSession = function(data){
  this.editor.getSession().getDocument().setValue(data);
}

Editor.prototype.getValueSession = function(){
  this.editor.getSession().getValue();
}

Editor.prototype.renameFile = function (oldFilename, newFilename) {
  return this.fileManager.renameFile(oldFilename, newFilename);
};

Editor.prototype.selectFile = function (filename) {
  var session = this.fileManager.selectFile(filename);
  if (session) {
    this.editor.setSession(session);
    editorUI.selectFile(filename);
  }
};

window.editor = new Editor();
