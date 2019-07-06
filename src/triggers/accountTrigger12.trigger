trigger accountTrigger12 on Account (before insert, before update) {
    for(Account acc : Trigger.new){
        if(acc.Phone != null)
        {
            string stdcode = acc.Phone.substring(1,4);
            system.debug('Std code is :'+stdcode);
            
            if (stdcode == '040')
            acc.city__c = 'Hyderabad';
            if (stdcode == '020')
             acc.city__c = 'Pune';
             if (stdcode == '080')
             acc.city__c = 'Banglore';
             }
    
    }

}