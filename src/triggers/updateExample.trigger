trigger updateExample on Account (before update) {
    for(Account a: Trigger.old){
        System.debug ('====>>>Trigger.old Account Name '+a.name);
        System.debug('====>>>Trigger.old Acount Industry '+a.industry);
    }
    System.debug('=====Old Map Closed=====');
    for(Account b: Trigger.new){
        System.debug('====>>>Trigger.new Account Name '+b.name);
        System.debug('====>>>Trigger.new Account Industry '+b.industry);
    }
    System.debug('=====New Map Clossed =====');
    map<Id,Account> oldMap=Trigger.oldMap;
    Map<id,Account> newMap=Trigger.newMap;
    System.debug('===>>>TriggerOldMap :'+oldMap);
    System.debug('===>>>TriggerNewMap :'+newMap);

}