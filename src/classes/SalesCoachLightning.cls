public with sharing class SalesCoachLightning {
    
    //Methods
    @AuraEnabled
    public static String getOpptyStagesLightning() {
        
        //FLS/CRUD Check
        String [] opptyStageFields = new String [] {'MasterLabel', 'SortOrder', 'IsActive'};
            Map<String,Schema.SObjectField> m = Schema.SObjectType.OpportunityStage.fields.getMap();
        for (String fieldToCheck : opptyStageFields) {
            if(!m.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
                return null;
            }
        }
        
        SelectOption[] temp = getOpptyStages();
        List<CustomSelectOption> result = new List<CustomSelectOption>();
        for(SelectOption sOption : temp) {
            CustomSelectOption entry = new CustomSelectOption(sOption.getLabel(), sOption.getValue());
            result.add(entry);
        }
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static String getCurrentOpptyStage(String recordId) {
        //FLS/CRUD Check
        if(!Schema.SObjectType.Opportunity.fields.getMap().get('StageName').getDescribe().isAccessible()) {
            throw new System.NoAccessException();
            return null;
        }
        
        Opportunity oppty;
        try {
            oppty = [select id, StageName from Opportunity where id= : recordId];
        }
        catch(QueryException e) {
            throw new System.QueryException();
            return null;
        }
        return oppty.StageName;
    }
    
    @AuraEnabled
    public static String populateStage(String stage) {
        //This method populates the Stage Description, Activities, and Sections with Items
        
        //Intialize the state if necessary
        initializeState(stage);
        
        //FLS/CRUD Check
        if(!checkCustomObjectReadAccess()) {
            throw new System.NoAccessException();
            return null;
        }
        
        //Now we start building our mega object
        Sales_Coach_Stage__c stageObject = getStageObject(stage);
        List<Sales_Coach_Activity__c> stageActivities = getActivities(stageObject);
        List<SuperSection> stageSections = getSuperSections(stageObject);
        //If we dont have at least one activity and at least one section, do not render
        Boolean renderCheck = true;
        if(stageActivities.size() < 1 || stageSections.size() < 1)
            renderCheck = false;
        
        MegaObject result = new MegaObject(stageObject.Buyer_Stage__c, stageActivities, stageSections, renderCheck);
        
        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static void saveStage(String stage, String stageDetails, String stageActivitiesRaw, String superSectionsRaw) {
        List<Sales_Coach_Activity__c> stageActivities = (List<Sales_Coach_Activity__c>)JSON.deserialize(stageActivitiesRaw, List<Sales_Coach_Activity__c>.class);
        List<Object> stageSectionsUntyped = (List<Object>)JSON.deserializeUntyped(superSectionsRaw);
        Sales_Coach_Stage__c stageObject = getStageObject(stage);
        
        //FLS/CRUD Checks
        if(!checkCustomObjectReadAccess() || !checkCustomObjectUpdateAccess() || !checkCustomObjectCreateAccess() ||
           !checkCustomObjectDeleteAccess()) {
               throw new System.NoAccessException();
           }
        
        saveStageDescription(stageObject, stageDetails);
        saveStageActivities(stageObject, stageActivities);
        saveStageSections(stageObject, stageSectionsUntyped);
    }
    
    //Fetch helpers
    public static SelectOption[] getOpptyStages(){
        SelectOption[] options = new SelectOption[] {};
        String[] oList = new String[] {};
            List<OpportunityStage> OS = [Select MasterLabel from OpportunityStage where IsActive=true order by SortOrder];
        for(OpportunityStage ml:OS)
            oList.add(ml.MasterLabel);
        for( string s : oList )
            options.add( new SelectOption( s.trim(), s.trim() ) );            
        return options;
    }
    
    @TestVisible
    private static Sales_Coach_Stage__c getStageObject(String stage) {
        Sales_Coach_Stage__c stageObject = null;
        try{
            stageObject = [select Name, Id, Buyer_Stage__c, Active__c 
                           from Sales_Coach_Stage__c
                           where Name = : stage Limit 1];
        } catch(QueryException e){
            throw new System.QueryException();
            return null;
        }
        return stageObject;
    }
    
    private static List<Sales_Coach_Activity__c> getActivities(Sales_Coach_Stage__c stageObject) {
        List<Sales_Coach_Activity__c> result = null;
        try{
            result = [select Sales_Coach_Stage__c, Ordering_Number__c, Name, Id, Activity_Details__c
                      from Sales_Coach_Activity__c
                      where Sales_Coach_Stage__c = : stageObject.Id
                      order by Ordering_Number__c];
        } catch(Exception e){
            throw new System.QueryException();
            return null;   
        }
        return result;
    }
    
    private static List<SuperSection> getSuperSections(Sales_Coach_Stage__c stageObject) {
        List<SuperSection> result = new List<SuperSection>();
        try{
            List<Sales_Coach_Section__c> sList = [select Section_Ordering__c, Section_Name__c, 
                                                  Sales_Coach_Stage__c, Name, Id,
                                                  Sales_Coach_Section__c.Sales_Coach_Stage__r.Name, 
                                                  Section_Width__c,
                                                  (select Section_Ordering__c, Sales_Coach_Section__c, 
                                                   Name, Link_to_Content__c, Item_Name__c, Id, 
                                                   Display__c, Products__c 
                                                   from Sales_Coach_Section_Items__r
                                                   order by Section_Ordering__c)  
                                                  from Sales_Coach_Section__c
                                                  where Sales_Coach_Stage__c = : stageObject.Id
                                                  order by Section_Ordering__c];
            for(Sales_Coach_Section__c section : sList){
                if(section.Sales_Coach_section_Items__r.isEmpty()){
                    result.add(new SuperSection(section, null));
                }else{
                    result.add(new SuperSection(section, section.Sales_Coach_section_Items__r));
                }
            }
        }catch(Exception e){
            throw new System.QueryException();
            return null;
        }
        return result;
    }
    
    //DML Helpers
    private static void saveStageDescription(Sales_Coach_Stage__c stageObject, String description) {
        stageObject.Buyer_Stage__c = description;
        try {
            update stageObject;
        } catch(DmlException e) {
            throw new System.DmlException();
        }
    }
    
    private static void saveStageActivities(Sales_Coach_Stage__c stageObject, List<Sales_Coach_Activity__c> stageActivities) {
        List<Sales_Coach_Activity__c> currentActivities = getActivities(stageObject);
        Map<String, Sales_Coach_Activity__c> currentIds = new Map<String, Sales_Coach_Activity__c>();
        Set<String> newIds = new Set<String>();
        Map<String, Sales_Coach_Activity__c> toUpdate = new Map<String, Sales_Coach_Activity__c>(); //List of IDs that should be updated, not inserted
        
        //Get a list of current (in DB) IDs and New (from Lightning) IDs
        for(Sales_Coach_Activity__c temp : currentActivities) {
            currentIds.put(temp.Id, temp);
        }
        for(Sales_Coach_Activity__c temp : stageActivities) {
            if(temp.Id != null)
                newIds.add(temp.Id);
        }
        
        //Delete IDs that are not in the new set and mark records for update
        for(String curId : currentIds.keySet()) {
            if(newIds.contains(curId)) {
                toUpdate.put(curId, currentIds.get(curId));
            }
            else { //Delete
                try {
                    Sales_Coach_Activity__c scActivity = [select id
                                                          from Sales_Coach_Activity__c
                                                          where id = : curId];
                    delete scActivity;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
        }
        
        //Insert and Update
        for(Sales_Coach_Activity__c activity : stageActivities) {
            if(toUpdate.containsKey(activity.Id)) { //Update
                Sales_Coach_Activity__c scActivity = toUpdate.get(activity.Id);
                scActivity.Ordering_Number__c = activity.Ordering_Number__c;
                scActivity.Activity_Details__c = activity.Activity_Details__c;
                try {
                    update scActivity;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
            else { //Insert
                Sales_Coach_Activity__c toAdd = new Sales_Coach_Activity__c(Sales_Coach_Stage__c = stageObject.Id,
                                                                            Ordering_Number__c = activity.Ordering_Number__c,
                                                                            Activity_Details__c = activity.Activity_Details__c);
                try {
                    insert toAdd;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
        }
    }
    
    private static void saveStageSections(Sales_Coach_Stage__c stageObject, List<Object> sectionsUntyped) {
        //Start by parsing everything into a base of Map<String, Object>  
        List<Map<String, Object>> sectionDetails = new List<Map<String, Object>>();
        List<List<Map<String, Object>>> sectionItemsList = new List<List<Map<String, Object>>>();
        for(Object tempSectionUntyped : sectionsUntyped) {
            if(!(tempSectionUntyped instanceof List<Object>)) { //A list means empty Map, ignore
                Map<String, Object> tempMap = (Map<String, Object>)tempSectionUntyped;
                List<Map<String, Object>> tempItems = new List<Map<String, Object>>();
                Map<String, Object> tempDetail = (Map<String, Object>)tempMap.get('salesCoachSection');
                
                //TODO: Handle Empty item list here (Error: Attempting to dereference null object)
                if(tempMap.get('salesCoachSectionItems') != null) {
                    for(Object itemObject : (List<Object>)tempMap.get('salesCoachSectionItems')) {
                        Map<String, Object> curItem = (Map<String, Object>)itemObject;
                        tempItems.add(curItem);
                    }
                }
                sectionDetails.add(tempDetail);
                sectionItemsList.add(tempItems);
            }
        }
        
        //Get a list of current (in DB) IDs and New (from Lightning) IDs
        Map<String, Sales_Coach_Section__c> currentIds = new Map<String, Sales_Coach_Section__c>();
        Set<String> newIds = new Set<String>();
        Map<String, Sales_Coach_Section__c> toUpdate = new Map<String, Sales_Coach_Section__c>();
        List<SuperSection> superSections = getSuperSections(stageObject);
        for(SuperSection tempSuperSection : superSections) {
            currentIds.put(tempSuperSection.getSalesCoachSection().Id, tempSuperSection.getSalesCoachSection());
        }
        for(Map<String, Object> tempSection : sectionDetails) {
            if(tempSection.get('Id') != null)
                newIds.add((String)tempSection.get('Id'));
        }
        
        //Delete IDs that are not in the new set and mark records for update
        for(String curId : currentIds.keySet()) {
            if(newIds.contains(curId)) {
                toUpdate.put(curId, currentIds.get(curId));
            }
            else { //Delete (Master-Detail means we handle children (Items) automatically)
                try {
                    Sales_Coach_Section__c scSection = [select id
                                                        from Sales_Coach_Section__c
                                                        where id = : curId];
                    delete scSection;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
        }
        
        //Insert and Update
        Integer index = 0;
        for(Map<String, Object> sec : sectionDetails) {
            if(sec.get('Section_Name__c') != null) {
                Sales_Coach_Section__c sectionToAddOrUpdate;
                if(toUpdate.containsKey((String)sec.get('Id'))) { //Update
                    sectionToAddOrUpdate = toUpdate.get((String)sec.get('Id'));
                    sectionToAddOrUpdate.Section_Name__c = (String)sec.get('Section_Name__c');
                    sectionToAddOrUpdate.Section_Ordering__c = Decimal.valueOf((String)sec.get('Section_Ordering__c'));
                    sectionToAddOrUpdate.Section_Width__c = Decimal.valueOf((String)sec.get('Section_Width__c'));
                    try {
                        update sectionToAddOrUpdate;
                    } catch(DmlException e) {
                        throw new System.DmlException();
                    }
                }
                else { //Insert
                    sectionToAddOrUpdate = new Sales_Coach_Section__c(
                        Sales_Coach_Stage__c = stageObject.Id,
                        Section_Name__c = (String)sec.get('Section_Name__c'),
                        Section_Ordering__c = Decimal.valueOf((String)sec.get('Section_Ordering__c')),
                        Section_Width__c = Decimal.valueOf((String)sec.get('Section_Width__c')));
                    try {
                        insert sectionToAddOrUpdate;
                    } catch(DmlException e) {
                        throw new System.DmlException();
                    }
                }
                //Now we save the Section Items
                //Get the corresponding superSection
                SuperSection superSectionToModify;
                for(SuperSection tempSuperSection : superSections) {
                    if(tempSuperSection.getSalesCoachSection().Id == sectionToAddOrUpdate.Id) {
                        superSectionToModify = tempSuperSection;
                        break;
                    }
                }
                
                List<Sales_Coach_Section_Item__c> currentItems = null;
                if(superSectionToModify != null && superSectionToModify.getSalesCoachSectionItems() != null)
                    currentItems = superSectionToModify.getSalesCoachSectionItems();
                //Add the items if there are any
                if(sectionItemsList.get(index) != null)
                    saveSectionItems(stageObject, sectionToAddOrUpdate, currentItems, sectionItemsList.get(index));
            }
            index++;
        }
    }
    
    private static void saveSectionItems(Sales_Coach_Stage__c stageObject, Sales_Coach_Section__c sectionObject,
                                         List<Sales_Coach_Section_Item__c> currentItems, List<Map<String, Object>> sectionItems) {
		//Get a list of current (in DB) IDs and New (from Lightning) IDs
        Map<String, Sales_Coach_Section_Item__c> currentIds = new Map<String, Sales_Coach_Section_Item__c>();
        Set<String> newIds = new Set<String>();
        Map<String, Sales_Coach_Section_Item__c> toUpdate = new Map<String, Sales_Coach_Section_Item__c>();
        
        if(currentItems != null) {
            for(Sales_Coach_Section_Item__c temp : currentItems) {
            	currentIds.put(temp.Id, temp);
        	}
        }
        
        if(sectionItems != null) {
            for(Map<String, Object> tempSectionItem : sectionItems) {
                if(tempSectionItem.get('Id') != null)
                    newIds.add((String)tempSectionItem.get('Id'));
            }
        }
        
        //Delete IDs that are not in the new set and mark records for update
        for(String curId : currentIds.keySet()) {
            if(newIds.contains(curId)) {
                toUpdate.put(curId, currentIds.get(curId));
            }
            else { //Delete
                try {
                    Sales_Coach_Section_Item__c scItem = [select id
                                                        from Sales_Coach_Section_Item__c
                                                        where id = : curId];
                    delete scItem;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
        }
        
        //Insert and Update
        for(Map<String, Object> item : sectionItems) {
            if(toUpdate.containsKey((String)item.get('Id'))) { //Update
                Sales_Coach_Section_Item__c scItem = toUpdate.get((String)item.get('Id'));
                scItem.Item_Name__c = (String)item.get('Item_Name__c');
                scItem.Section_Ordering__c = Decimal.valueOf((String)item.get('Section_Ordering__c'));
                scItem.Link_to_Content__c = (String)item.get('Link_to_Content__c');
                try {
                    update scItem;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
            else { //Insert
                Sales_Coach_Section_Item__c toAdd = new Sales_Coach_Section_Item__c(
                    Sales_Coach_Section__c = sectionObject.Id,
                    Item_Name__c = (String)item.get('Item_Name__c'),
                    Section_Ordering__c = Decimal.valueOf((String)item.get('Section_Ordering__c')),
                    Link_to_Content__c = (String)item.get('Link_to_Content__c'));
                try {
                    insert toAdd;
                } catch(DmlException e) {
                    throw new System.DmlException();
                }
            }
        }
    }
    
    //FLS and CRUD Check Helpers
    private static boolean checkCustomObjectReadAccess() {
        String [] sCStageFields = new String [] {'Name', 'Id', 'Buyer_Stage__c', 'Active__c'};
            Map<String, Schema.SObjectField> sCStageMap = Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap();
        for (String fieldToCheck : sCStageFields) {
            if(!sCStageMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        
        String [] sCActivityFields = new String [] {'Sales_Coach_Stage__c', 'Ordering_Number__c', 
            'Id', 'Name', 'Activity_Details__c'};
                Map<String, Schema.SObjectField> sCActivityMap = Schema.SObjectType.Sales_Coach_Activity__c.fields.getMap();
        for (String fieldToCheck : sCActivityFields) {
            if(!sCActivityMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        
        String [] sCSectionFields = new String [] {'Section_Ordering__c', 'Section_Name__c', 'Sales_Coach_Stage__c',
            'Name', 'Id', 'Section_Width__c'};
                Map<String, Schema.SObjectField> sCSectionMap = Schema.SObjectType.Sales_Coach_Section__c.fields.getMap();
        for (String fieldToCheck : sCSectionFields) {
            if(!sCSectionMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        
        String [] sCSectionItemFields = new String [] {'Section_Ordering__c', 'Sales_Coach_Section__c', 'Name',
            'Link_to_Content__c', 'Item_Name__c', 'Id', 'Display__c', 'Products__c'};
                Map<String, Schema.SObjectField> sCSectionItemMap = Schema.SObjectType.Sales_Coach_Section_Item__c.fields.getMap();
        for (String fieldToCheck : sCSectionItemFields) {
            if(!sCSectionItemMap.get(fieldToCheck).getDescribe().isAccessible()) {
                return false;
            }
        }
        
        return true;
    }
    
    private static boolean checkCustomObjectUpdateAccess() {
        String [] sCStageFields = new String [] {'Name', 'Buyer_Stage__c', 'Active__c'};
            Map<String, Schema.SObjectField> sCStageMap = Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap();
        for (String fieldToCheck : sCStageFields) {
            if(!sCStageMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        
        String [] sCActivityFields = new String [] {'Sales_Coach_Stage__c', 'Ordering_Number__c', 'Activity_Details__c'};
            Map<String, Schema.SObjectField> sCActivityMap = Schema.SObjectType.Sales_Coach_Activity__c.fields.getMap();
        for (String fieldToCheck : sCActivityFields) {
            if(!sCActivityMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        
        String [] sCSectionFields = new String [] {'Section_Ordering__c', 'Section_Name__c', 'Sales_Coach_Stage__c',
            'Section_Width__c'};
                Map<String, Schema.SObjectField> sCSectionMap = Schema.SObjectType.Sales_Coach_Section__c.fields.getMap();
        for (String fieldToCheck : sCSectionFields) {
            if(!sCSectionMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        
        String [] sCSectionItemFields = new String [] {'Section_Ordering__c', 'Link_to_Content__c', 'Item_Name__c',
            'Display__c', 'Products__c'};
                Map<String, Schema.SObjectField> sCSectionItemMap = Schema.SObjectType.Sales_Coach_Section_Item__c.fields.getMap();
        for (String fieldToCheck : sCSectionItemFields) {
            if(!sCSectionItemMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                return false;
            }
        }
        
        return true;
    }
    
    private static boolean checkCustomObjectCreateAccess() {
        String [] sCStageFields = new String [] {'Name', 'Buyer_Stage__c', 'Active__c'};
            Map<String, Schema.SObjectField> sCStageMap = Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap();
        for (String fieldToCheck : sCStageFields) {
            if(!sCStageMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        
        String [] sCActivityFields = new String [] {'Sales_Coach_Stage__c', 'Ordering_Number__c', 'Activity_Details__c'};
            Map<String, Schema.SObjectField> sCActivityMap = Schema.SObjectType.Sales_Coach_Activity__c.fields.getMap();
        for (String fieldToCheck : sCActivityFields) {
            if(!sCActivityMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        
        String [] sCSectionFields = new String [] {'Section_Ordering__c', 'Section_Name__c', 'Sales_Coach_Stage__c', 
            'Section_Width__c'};
                Map<String, Schema.SObjectField> sCSectionMap = Schema.SObjectType.Sales_Coach_Section__c.fields.getMap();
        for (String fieldToCheck : sCSectionFields) {
            if(!sCSectionMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        
        String [] sCSectionItemFields = new String [] {'Section_Ordering__c', 'Sales_Coach_Section__c',
            'Link_to_Content__c', 'Item_Name__c', 'Display__c', 'Products__c'};
                Map<String, Schema.SObjectField> sCSectionItemMap = Schema.SObjectType.Sales_Coach_Section_Item__c.fields.getMap();
        for (String fieldToCheck : sCSectionItemFields) {
            if(!sCSectionItemMap.get(fieldToCheck).getDescribe().isCreateable()) {
                return false;
            }
        }
        
        return true;
    }
    
    private static boolean checkCustomObjectDeleteAccess() {
        if(!Sales_Coach_Stage__c.SObjectType.getDescribe().isDeletable()) {
            return false;
        }
        if(!Sales_Coach_Activity__c.SObjectType.getDescribe().isDeletable()) {
            return false;
        }
        if(!Sales_Coach_Section__c.SObjectType.getDescribe().isDeletable()) {
            return false;
        }
        if(!Sales_Coach_Section_Item__c.SObjectType.getDescribe().isDeletable()) {
            return false;
        }
        return true;
    }
    
    //General Helpers
    @TestVisible
    private static void initializeState(String stage) {
        //This method checks to see if the Sales_Coach_Stage__c object exists
        //If not, it creates an Sales_CoachStage__c object
        //FLS/CRUD
        if(!Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap().get('Name').getDescribe().isCreateable() ||
           !Schema.SObjectType.Sales_Coach_Stage__c.fields.getMap().get('Active__c').getDescribe().isCreateable()) {
               throw new System.NoAccessException();
           }
        
        List<Sales_Coach_Stage__c> stageObjects = [select Name from Sales_Coach_Stage__c where Name = : stage];
        
        //We create a new stage object if nothing is returned
        if(stageObjects.isEmpty()) {
            Sales_Coach_Stage__c newStage = new Sales_Coach_Stage__c(Name = stage, Active__c = true);
            try {
                insert newStage;
            } catch(DmlException e) {
                throw new System.DmlException();
            }
            
        }
    }
    
    //Subclasses
    public class CustomSelectOption {
        private String label;
        private String value;
        
        public CustomSelectOption(String lbl, String vl) {
            this.label = lbl;
            this.value = vl;
        }
        
        public String getLabel(){return this.label;}
        public String getValue(){return this.value;}
        public void setLabel(String lbl){this.label = lbl;}
        public void setValue(String vl){this.value = vl;}
    }
    
    public class SuperSection {
        
        private Sales_Coach_Section__c salesCoachSection;
        private List<Sales_Coach_Section_Item__c> salesCoachSectionItems;
        
        public Sales_Coach_Section__c getSalesCoachSection(){return salesCoachSection;}
        public List<Sales_Coach_Section_Item__c> getSalesCoachSectionItems(){return salesCoachSectionItems;}
        
        public SuperSection(Sales_Coach_Section__c pSec, List<Sales_Coach_Section_Item__c> pItems) {
            salesCoachSection = pSec;
            salesCoachSectionItems = pItems;
        }
    }
    
    public class MegaObject {
        private String stageDescription;
        private List<Sales_Coach_Activity__c> salesCoachActivities;
        private List<SuperSection> salesCoachSections;
        private Boolean renderCheck;
        
        public String getStageDescription(){return stageDescription;}
        public List<Sales_Coach_Activity__c> getSalesCoachActivities(){return salesCoachActivities;}
        public List<SuperSection> getSalesCoachSections(){return salesCoachSections;}
        public Boolean getRenderCheck(){return renderCheck;}
        
        public MegaObject(String a, List<Sales_Coach_Activity__c> b, List<SuperSection> c, Boolean d) {
            stageDescription = a;
            salesCoachActivities = b;
            salesCoachSections = c;
            renderCheck = d;
        }
    }
}