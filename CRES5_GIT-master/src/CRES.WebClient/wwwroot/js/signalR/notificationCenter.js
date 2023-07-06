$(function () {
 
    // Declare a proxy to reference the hub.
    //$("#displayNotification").click();
    var connection = $.hubConnection();

    var pathArray = location.href.split('/');
    var protocol = pathArray[0];
    var host = pathArray[2];
    var url = protocol + '//' + host;
    
    //alert('url' + url);

    if (url.toLowerCase() == "http://localhost:4977")
    {
        connection.url = "http://localhost:52527/signalr";
    }
    else
    {
        connection.url = "http://cres5pushnotification.azurewebsites.net/signalr";
    }
    //else if (url.toLowerCase() == "http://acore.azurewebsites.net")
    //{
    //    connection.url = "http://acorepushnotification.azurewebsites.net/signalr";
    //}
    //else if (url.toLowerCase() == 'http://qacres4.azurewebsites.net') {
    //    connection.url = "http://qapushnotification.azurewebsites.net/signalr";
    //}
    

    //connection.url = url + "/signalr";
    //alert('connection.url' + connection.url);
    //Local
    //connection.url = "http://localhost:52527/signalr";

    //Acore
    //connection.url = "http://acorepushnotification.azurewebsites.net/signalr";

    var contosoChatHubProxy = connection.createHubProxy('chatHub');

    contosoChatHubProxy.on('addMessage', function (userName, message)
    {
        var _pushNotification = message.split('|*|');
        $('#ptitle').html(_pushNotification[1]);
        $("#displayNotification").click()
        console.log(userName + ' ' + message);
    });


    connection.start()
        .done(function () {
            console.log('Now connected, connection ID=' + connection.id);
            $("#btnSendNotification").bind("click", function (event, elementId) {
                contosoChatHubProxy.invoke('SendToOtherUsers', '', elementId);
            });

        })
        .fail(function () { console.log('Could not connect'); });
});