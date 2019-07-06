trigger accountTrigger on Account (before insert, before update) {
        for(Account acc:trigger.new)
            {
                if(acc.phone != null)
                    {
                        String stdcode = acc.phone.substring(1,4);
                        system.debug('Std Code is ' +stdcode);
                        if(stdcode=='040')
                        acc.city__c='Hyderabad';
                        if(stdcode == '020')
                        acc.city__c='Pune';
                        if(stdcode == '080')
                        acc.city__c='Banglore';
                        }
                        }
                       
    
                

}