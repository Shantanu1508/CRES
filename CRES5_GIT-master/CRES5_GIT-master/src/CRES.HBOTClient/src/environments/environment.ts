// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,

  dialogflow: {
    autocomplete: '/search/getautosuggestsearchdata?pageIndex=1&pageSize=10',
    login: '/account/authenticate',
    baseurl:'https://qacres4api.azurewebsites.net/api',
    API_Key:'1b000bfcf8cd6a629f729c22a7bca73c',
    dialogflowbaseurl:"https://hbotdialogflowclientdevqa.azurewebsites.net/dialogflowclient?text="
  }
};
