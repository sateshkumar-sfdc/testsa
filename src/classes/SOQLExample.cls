//
//
//
public class SOQLExample {
    public void getAccounts(){
        //List<Account> accList = [select id,Name,AccountNumber from Account];
        //List<Account> accList = [select id,Name,AccountNumber from Account where name = 'Edge Communications'];
       // List<Account> accList = [select id,Name,AccountNumber from Account where name LIKE 'Test%'];
      // List<Account> accList = [select id,Name,AccountNumber from Account where name LIKE '%Test%'];
      List<Account> accList = [select id,Name,AccountNumber from Account LIMIT 5];
        
        
        System.debug('==============accList: '+accList);
        for(Account acc: accList) {
            System.debug('-----------------------acc: '+acc);
            System.debug('-----------------------acc Id: '+acc.id);
             System.debug('-----------------------acc Name: '+acc.name);
              System.debug('-----------------------acc Account number: '+acc.AccountNumber);
             Integer numberOfRecords= [Select count() from Account];
             System.debug('total no of records: ' +numberOfRecords);
}
}
}