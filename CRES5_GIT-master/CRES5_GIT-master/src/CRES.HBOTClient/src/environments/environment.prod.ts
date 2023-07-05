export const environment = {
  production: true,
  dialogflow: {
    autocomplete: '/search/getautosuggestsearchdata?pageIndex=1&pageSize=10',
    login: '/account/authenticate',

    //Integration hbot environment key and Url
  //  dialogflowbaseurl:"https://hbotdialogflowclientintegration.azurewebsites.net/dialogflowclient?text=",
  //  baseurl: 'https://integrationcres4api.azurewebsites.net/api',
  //  API_Key: 'sqJ93jewll1olTCBMHWi9U1oYOL1uKEo'
    
    ////qa hbot environment key and Url
    dialogflowbaseurl:"https://hbotdialogflowclientdevqa.azurewebsites.net/dialogflowclient?text=",
    baseurl: 'https://qacres4api.azurewebsites.net/api',
    API_Key:'1b000bfcf8cd6a629f729c22a7bca73c'
  }
};
