$( document ).ready(function() {
    $('#mymodal').modal({
        keyboard: false,
        show: true
    });
    // Jquery draggable
    $('#modal-dialog').draggable({
        handle: ".modal-header"

    });
    document.getElementById("modal-dialog").style.left = "10px";
    document.getElementById("modal-dialog").style.top = "0px";
});