public with sharing class TestingUtil {
    public String opId;
    public String scsId;
    public String scsecId;
    public String scsecItemId;
    public String actId;
    
    public TestingUtil(){
        opId = makeTestableOp();
        scsId = makeSalesCoachStage();
        scsecId = makeSalesCoachSections();
        scsecItemId = makeSecItem();
        actId = makeActivities();
        ApexPages.currentPage().getParameters().put('id', this.opId);
    }
    
    private String makeTestableOp(){
        //FLS/CRUD Check
        String [] opFields = new String [] {'Name', 'CloseDate', 'StageName'};
            Map<String, Schema.SObjectField> opFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : opFields) {
            if(!opFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return null;
            }
        }
        
        Opportunity op = new Opportunity();
        op.Name='testOpName';
        op.CloseDate = Date.today();
        op.StageName='testStage';
        insert op;
        return op.Id;
    }
    
    private String makeSalesCoachStage(){
        //FLS/CRUD Check
        String [] stageFields = new String [] {'Name', 'Buyer_Stage__c', 'Active__c'};
            Map<String, Schema.SObjectField> stageFieldMap = Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap();
        for (String fieldToCheck : stageFields) {
            if(!stageFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return null;
            }
        }
        
        Sales_Coach_Stage__c scs = new Sales_Coach_Stage__c();
        scs.Name='testStage';
        scs.Buyer_Stage__c='testBuyStage';
        scs.Active__c=true;
        insert scs;
        return scs.Id;
    }
    
    private String makeSalesCoachSections(){
        //FLS/CRUD Check
        String [] sectionFields = new String [] {'Section_Ordering__c', 'Section_Name__c', 'Sales_Coach_Stage__c',
            									 'Section_Width__c'};
            Map<String, Schema.SObjectField> sectionFieldMap = Schema.SObjectType.Sales_Coach_Section__c.fields.getMap();
        for (String fieldToCheck : sectionFields) {
            if(!sectionFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return null;
            }
        }
        
        Sales_Coach_Section__c scsec =  new Sales_Coach_Section__c();
        scsec.Section_Ordering__c =1.0;
        scsec.Section_Name__c='testSection';
        scsec.Sales_Coach_Stage__c=scsId;
        scsec.Section_Width__c=33.0;
        insert scsec;
        return scsec.Id;
    }
    
    private String makeSecItem(){
        //FLS/CRUD Check
        String [] itemFields = new String [] {'Section_Ordering__c', 'Sales_Coach_Section__c', 'Link_to_Content__c',
            								  'Item_Name__c', 'Display__c', 'Products__c'};
            Map<String, Schema.SObjectField> itemFieldMap = Schema.SObjectType.Sales_Coach_Section_Item__c.fields.getMap();
        for (String fieldToCheck : itemFields) {
            if(!itemFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return null;
            }
        }
        
        Sales_Coach_Section_Item__c secItem = new Sales_Coach_Section_Item__c();
        secItem.Section_Ordering__c=1.0;
        secItem.Sales_Coach_Section__c=scsecId;
        secItem.Link_to_Content__c='http://www.google.com';
        secItem.Item_Name__c='testItem';
        secItem.Display__c=true;
        secItem.Products__c='';
        insert secItem;
        return secItem.Id;
    }
    
    private String makeActivities(){
        //FLS/CRUD Check
        String [] activityFields = new String [] {'Sales_Coach_Stage__c', 'Ordering_Number__c', 'Activity_Details__c'};
            Map<String, Schema.SObjectField> activityFieldMap = Schema.SObjectType.Sales_Coach_Activity__c.fields.getMap();
        for (String fieldToCheck : activityFields) {
            if(!activityFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return null;
            }
        }
        
        Sales_Coach_Activity__c sca = new Sales_Coach_Activity__c();
        sca.Sales_Coach_Stage__c=scsId;
        sca.Ordering_Number__c=1.0;
        sca.Activity_Details__c='testActivity';
        insert sca;
        return sca.Id;
    }
    
}