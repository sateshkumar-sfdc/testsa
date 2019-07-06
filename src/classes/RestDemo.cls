@RestResource(urlMapping='/DemoRestCall/*')
Global with sharing class RestDemo {
    @httpGet
    global static account doGet(){
        RestRequest req = RestContext.request;
        string accName = RestContext.request.params.get('AccountName');
        account acc = [Select id, name, Phone from account where Name =: accName];
        return acc;
    }

}