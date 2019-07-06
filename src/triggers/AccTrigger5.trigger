//
// Based on Phone number Forst three degits we need to update the city field.
//
trigger AccTrigger5 on Account (before insert, before update) {
    for (Account acc : Trigger.new){
        
        if(acc.Phone != null)
        {
            string stdcode = acc.phone.substring(1,4);
            System.debug('Std Code is : '+ stdcode);
                    
            if (stdcode == '040')
                acc.city__c = 'hyderabad';
            
            if (stdcode == '020')
                acc.City__c = 'Pune';
            if (stdcode == '080')
                acc.City__c = 'Banglore';
           
        }
        
    }

}