@RestResource(urlMapping='/GetAccountRecord/*')
global with sharing class RestAccount1 {
	@httpGet
	global static account doGet() {
		RestRequest req = restContext.request;
		RestResponse res = restContext.response;
		String AccName = restContext.request.params.get('AccName');
		Account result = [Select Id, Name, Website from Account where Id = : AccName];
		Return result;
	}

}