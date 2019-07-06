trigger afterUpdate on Account (after update) {
    for(Account a: Trigger.new){
        System.debug('Trigger.New : Account Name : '+a.name);
        System.debug('Trigger.New : Account Phone : '+a.Phone);
    }
    for(Account b: Trigger.old){
        System.debug('Trigger.old : Account Name : '+b.name);
        System.debug('Trigger.old : Account Phone : '+b.Phone);
    }

}