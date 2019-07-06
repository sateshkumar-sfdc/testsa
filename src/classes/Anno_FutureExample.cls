public class Anno_FutureExample{
    @future
    public static void getAccounts() {
        List<Account> acclist = [select id,Name from Account];
        }
     }