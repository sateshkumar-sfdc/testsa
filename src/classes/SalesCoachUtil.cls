public with sharing class SalesCoachUtil {
    
    private static Sales_Coach_Role__c salesCoachRole;
    
    //this gets the opurtunity stages from OppurtunityStage which is set by user   
    public static SelectOption[] getOpptyStages(){
        //FLS/CRUD Check
        String [] stageFields = new String [] {'MasterLabel', 'IsActive', 'SortOrder'};
        Map<String,Schema.SObjectField> m = Schema.SObjectType.OpportunityStage.fields.getMap();
        for (String fieldToCheck : stageFields) {
            if(!m.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        SelectOption[] options = new SelectOption[] {};
            options.add( new SelectOption( '-- Select --', '-- Select --' ) );
        String[] oList = new String[] {};
            List<OpportunityStage> OS = [Select MasterLabel from OpportunityStage where IsActive=true order by SortOrder];
        for(OpportunityStage ml:OS)
            oList.add(ml.MasterLabel);
        for( string s : oList )
            options.add( new SelectOption( s.trim(), s.trim() ) );            
        return options;
    }
    
    //test getOpptyStages
    private static testmethod void testSalesCoachRole(){
        System.assert(SalesCoachUtil.getOpptyStages().size()>0);
        TestingUtil tu = new TestingUtil();
        System.assert(SalesCoachUtil.getOpptyStages().size()>0);
    }
    
    private static void populateSalesCoachRole(){
        //FLS/CRUD Check
        String [] roleFields = new String [] {'Id', 'Name'};
        Map<String,Schema.SObjectField> m1 = Schema.SObjectType.UserRole.fields.getMap();
        Map<String,Schema.SObjectField> m2 = Schema.SObjectType.Sales_Coach_Role__c.fields.getMap();
        for (String fieldToCheck : roleFields) {
            if(!m1.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        for (String fieldToCheck : roleFields) {
            if(!m2.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        String userRole;
        
        if(SalesCoachUtil.salesCoachRole == null){
            try{
                userRole = [select id, 
                            name
                            from UserRole
                            where id = : UserInfo.getUserRoleId()].Name;
                SalesCoachUtil.salesCoachRole = [select id, 
                                                 name
                                                 from Sales_Coach_Role__c
                                                 where name = : userRole Limit 1];
                
            }catch(Exception e){
            }
        }
    }
    
    //test populateSalesCoachRole
    private static testmethod void testpopulateSalesCoachRole(){
        SalesCoachUtil.populateSalesCoachRole();
        TestingUtil tu = new TestingUtil();
        SalesCoachUtil.populateSalesCoachRole();
    }
    
    //this is used to get all the fields from user that are picklists 
    //or strings   
    public static Map<String, Schema.SObjectField> getUserFieldsMap(){
        Map<String, Schema.SObjectField> fields = new Map<String, Schema.SObjectField>{};
        Map<String, Schema.SObjectField> M = Schema.SObjectType.User.fields.getMap();
        Set<String> uSet =M.keySet();
        Schema.DescribeFieldResult F;
        for(String s:uSet){
            F=M.get(s).getDescribe();
            if(F.getType()==Schema.Displaytype.STRING || F.getType()==Schema.Displaytype.PICKLIST){
                fields.put(s, M.get(s)); 
            }
        }
        return fields;
    }
    
    //test getUserFieldsMap
    private static testmethod void testgetUserFieldsMap(){
        System.assert(SalesCoachUtil.getUserFieldsMap().size()>=0);
    }
    
    //this gets the opurtunity stages from OppurtunityStage which is set by user   
    public static String[] opptyStageList(){
        //FLS/CRUD Check
        Map<String,Schema.SObjectField> m = Schema.SObjectType.OpportunityStage.fields.getMap();
        if(!m.get('MasterLabel').getDescribe().isAccessible()) {
            throw new System.NoAccessException();
        }
        
        String[] oList = new String[] {};
        List<OpportunityStage> OS = [Select MasterLabel from OpportunityStage];
        for(OpportunityStage ml:OS)
            oList.add(ml.MasterLabel);   	
        return oList;
    }
    
    //test opptyStageList
    private static testmethod void testopptyStageList(){
        TestingUtil tu = new TestingUtil();
        System.assert(SalesCoachUtil.opptyStageList().size()>=0);
    }   
}