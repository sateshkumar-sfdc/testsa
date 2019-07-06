public class SoqlQuery {
    LIST<Account> accList = [select Id, Name,AccountNumber, AnnualRevenue from account where AnnualRevenue = null];
    
    public void method(){
        	for(Account a:accList){
            a.AnnualRevenue = 50000;
        }
        update accList;
    }
   
}