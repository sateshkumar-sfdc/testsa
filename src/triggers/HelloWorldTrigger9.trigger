trigger HelloWorldTrigger9 on Account (before insert) {
    //System.debug('Hello World');
    for(Account a : Trigger.new){
        a.Description = 'New Description';
    }

}