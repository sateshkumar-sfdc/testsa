trigger updateExample1 on Account (before update) {
    List<Account> accs=[select id,name,phone from Account where id in: Trigger.old];
    List<Account> newAccs=[select id,name,phone from Account where id in: Trigger.new];
    for(Account a: accs){
        System.debug('Trigger old : '+a.Name);
        System.debug('Trigger old :  '+a.Phone);
        a.phone = '1234567890';
    }
    for(Account b: newAccs){
        System.debug('Trigger New :'+b.name);
        System.debug('Trigger New :'+b.Phone);
    }

}