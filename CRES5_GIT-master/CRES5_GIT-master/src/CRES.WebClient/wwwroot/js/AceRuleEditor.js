var pythonMode = ace.require("ace/mode/json").Mode;
this.editor = ace.edit('editor');
this.editor.setTheme("ace/theme/twilight");
this.editor.setShowPrintMargin(false);
this.editor.session.setMode(new pythonMode());
editor.getSession().on('change', function () {
    update()
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
    this.editor.resize()
}

function getData() {
    localStorage.setItem('editorOut', this.editor.getSession().getValue())
}


function update() //writes in <div> with id=output
{
    var val = editor.getSession().getValue();
    var divecho = document.getElementById("output");
    divecho.innerHTML = val;

}




