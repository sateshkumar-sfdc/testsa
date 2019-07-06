trigger cityUpdate on Account (before insert, before update) {
    for(Account acc : Trigger.new) {
        
        if(acc.phone != null){
            String stdcode = acc.Phone.substring(1,4);
            system.debug('stdcode is : '+stdcode);
            
            if (stdcode == '040')
                acc.City__c = 'Hyderabad';
            if (stdcode == '020')
                acc.City__c = 'pune';
            if (stdcode == '080')
                acc.City__c = 'Banglore';
            
        }
    }

}