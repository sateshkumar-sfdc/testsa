trigger afterUpdate1 on Account (after update) {
    List<Account> accs = [select id,phone from Account where id in: Trigger.old];
    for(Account a: accs) {
        System.debug('Phone No : '+a.Phone);
        a.phone = '123';
    }
    //delete accs;
}