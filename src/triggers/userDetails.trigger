trigger userDetails on Opportunity (before insert) {
    
    //Bulk inserts
    for(Opportunity o: Trigger.new){
        //if condition for stsge Name
        If(o.StageName == 'Needs Analysis'){
            o.Description = 'For Needs Analasys value';
        }
        
    }

}