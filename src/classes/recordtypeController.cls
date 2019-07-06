public class recordtypeController {
    public static Map<Id, String> recordtypemap {get;set;}
         
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Account.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            System.debug('$$$$$$$$$$$$$$$$$$$$ '+ rt.getName()+ rt.isAvailable());
            if(rt.getName() != 'Master' & rt.getName() != 'PrePaid Customer' & rt.isAvailable() == true)
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }     

}