public class TriggerExample1 {
    public static void beforeUpdate(List<Account> accs){
        for(Account a: accs){
            if(a.industry=='Banking'){
                a.addError('Banking Records cannot be modified');
            }
        }
    }
    public static void afterUpdate(List<Account> accs){
        List<Contact> cons=new List<Contact>();
        for(Account a: accs){
            Contact c=new Contact();
            c.AccountId=a.id;
            c.LastName=a.name;
            c.Phone=a.Phone;
            cons.add(c);
        }
        insert cons;
    }

}