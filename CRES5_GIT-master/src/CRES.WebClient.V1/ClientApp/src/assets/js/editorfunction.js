var pythonMode = ace.require("ace/mode/python").Mode;
this.editor = ace.edit('editor');
this.editor.setTheme("ace/theme/sqlserver");
this.editor.setShowPrintMargin(false);
this.editor.session.setMode(new pythonMode());
editor.getSession().on('change', function () {
    update();
});
this.editor.setOptions({
    enableBasicAutocompletion: false,
    enableSnippets: false,
    enableLiveAutocompletion: false,
    fontSize: 18,
    showPrintMargin: false,
    highlightActiveLine: true,
    wrap: true,
  showLineNumbers: true

});

$('#editor').css({ 'visibility': 'visible' });

function setData() {
    this.editor.getSession().getDocument().setValue(localStorage.getItem('editorData'));
    this.editor.resize();
    this.editor.scrollToLine(0);
}

function getData() {
    localStorage.setItem('editorOut', this.editor.getSession().getValue())
    console.log('Editor11');
}


function update() {
    //set value to show this has changed    
    localStorage.setItem("EditorValueChanged", "true");
}




