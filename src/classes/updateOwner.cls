public class updateOwner {

    @AuraEnabled
    public static List<Opportunity__c> updateOpportunityOwner(Id workItemId){
        system.debug('Test ----' + workItemId);
        List<Opportunity__c> opptList = [SELECT id, name, owner.id,Test_name__c,owner.name from Opportunity__c where id =:workItemId];
        List<Opportunity> originalOppUpdate = new List<Opportunity>();

        //opportunity o = new opportunity();
        for(opportunity__C op : opptList)
        {
           opportunity o = new opportunity();
		   o.Id = op.Test_name__c;
           o.OwnerId = op.owner.Id; 
            originalOppUpdate.add(o);
         
        }
        if(originalOppUpdate.size()>0)
        {
            update originalOppUpdate;
        }
        System.debug('query result'+opptList);
        return opptList ;
       
        
    }

}