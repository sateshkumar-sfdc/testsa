@RestResource(urlMapping = '/demoRest8/*')
global with sharing class RestDemo8 {
    @httpGet
    global static string doGet(){
        /*RestRequest req = RestContext.request;
        String accName = RestContext.request.Params.get('AccountName');
        Account acc = [select id, name, phone from account where name =: accName];*/
        return 'satisk';
    }

}