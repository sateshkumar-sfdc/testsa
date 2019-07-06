trigger userDetails1 on Opportunity (before insert) {
    //Bulk inserts
    for(Opportunity o:Trigger.new){
        //If Conditions
        if(o.StageName == 'Needs Analysis'){
            o.description = 'this is trigger test criteria';
        }
    }

}