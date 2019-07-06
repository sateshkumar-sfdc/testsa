@isTest
public class TestSalesCoachLightning {
    static testMethod void testCustomSelectOptionSubclass() {
        SalesCoachLightning.CustomSelectOption c = new SalesCoachLightning.CustomSelectOption('a', 'b');
        System.assert(c.getLabel() == 'a');
        System.assert(c.getValue() == 'b');
        c.setLabel('c');
        c.setValue('d');
        System.assert(c.getLabel() == 'c');
        System.assert(c.getValue() == 'd');
    }
    
    static testMethod void testSuperSectionSubclass() {
        SalesCoachLightning.SuperSection e = generateSuperSection();
        Sales_Coach_Section__c result1  = e.getSalesCoachSection();
        List<Sales_Coach_Section_Item__c> result2 = e.getSalesCoachSectionItems();
        System.assert(result1.Section_Name__c == 'a1');
        System.assert(result2.get(0).Item_Name__c == 'b1');
    }
    
    static testMethod void MegaObjectSubclass() {
        String description = 'a';
        Boolean render = true;
        List<Sales_Coach_Activity__c> actList = new List<Sales_Coach_Activity__c>();
        List<SalesCoachLightning.SuperSection> secList = new List<SalesCoachLightning.SuperSection>();
        SalesCoachLightning.initializeState('testStage');
        Sales_Coach_Stage__c stageObject = SalesCoachLightning.getStageObject('testStage');
        
        Sales_Coach_Activity__c act = new Sales_Coach_Activity__c(Sales_Coach_Stage__c = stageObject.Id,
                                                                  Ordering_Number__c = 1,
                                                                  Activity_Details__c = 'Deets');
        actList.add(act);
        secList.add(generateSuperSection());
        
        SalesCoachLightning.MegaObject mo = new SalesCoachLightning.MegaObject(description, actList, secList, render);
        System.assert(mo.getStageDescription() == 'a');
        System.assert(mo.getSalesCoachActivities().get(0).Activity_Details__c == 'Deets');
        System.assert(mo.getSalesCoachSections().get(0).getSalesCoachSection().Section_Name__c == 'a1');
        System.assert(mo.getRenderCheck() == true);
    }
    
    static testMethod void testGetOpptyStagesLightning() {
        //Assert that the number of opportunity stages is greater than 0
        List<SalesCoachLightning.CustomSelectOption> result;
        result = (List<SalesCoachLightning.CustomSelectOption>)
            JSON.deserialize(SalesCoachLightning.getOpptyStagesLightning(), 
                             List<SalesCoachLightning.CustomSelectOption>.class);
        System.assert(result.size() > 0);
    }
    
    static testMethod void testGetCurrentOpptyStage() {
        Opportunity op = new Opportunity();
        op.Name='testOpName';
        op.CloseDate = Date.today();
        op.StageName='testStage';
        try {
            insert op;
        } catch(DmlException e) {
            throw new System.DmlException();
        }
        String result = SalesCoachLightning.getCurrentOpptyStage(op.Id);
        System.assert(result == 'testStage');
    }
    
    static testMethod void testEndToEnd() {
        //This tests insert/update/delete and read
        Id stageId = generateStage();
        String result1 = SalesCoachLightning.populateStage('testStage');
        SalesCoachLightning.MegaObject result1Object = 
            (SalesCoachLightning.MegaObject)JSON.deserialize(result1, SalesCoachLightning.MegaObject.class);
        //Verify results
        System.assert(result1Object.getStageDescription() == 'testDescription');
        System.assert(result1Object.getSalesCoachActivities().size() == 1);
        System.assert(result1Object.getSalesCoachSections().size() == 1);
        System.assert(result1Object.getSalesCoachSections().get(0).getSalesCoachSectionItems().size() == 2);
        
        //By adding the same dummy data (without an ID), we can test delete
        stageId = generateStage();
		String result2 = SalesCoachLightning.populateStage('testStage');
        SalesCoachLightning.MegaObject result2Object = 
            (SalesCoachLightning.MegaObject)JSON.deserialize(result2, SalesCoachLightning.MegaObject.class);
        //Verify results after delete (should be the exact same)
        System.assert(result2Object.getStageDescription() == 'testDescription');
        System.assert(result2Object.getSalesCoachActivities().size() == 1);
        System.assert(result2Object.getSalesCoachSections().size() == 1);
        System.assert(result2Object.getSalesCoachSections().get(0).getSalesCoachSectionItems().size() == 2);
        
        //Finally, we update the activity, the section, and the first section item, while deleting the second
        //Start with the activity update
        result2Object.getSalesCoachActivities().get(0).Activity_Details__c = 'new Details';
        
        //Generate Serialized SuperSection update (this updates section, first item, and deletes second)
        Map<String, String> section1 = new Map<String, String>();
        section1.put('Id', (String)result2Object.getSalesCoachSections().get(0).getSalesCoachSection().Id);
        section1.put('Section_Name__c', 'd1');
        section1.put('Section_Ordering__c', '1');
        section1.put('Section_Width__c', '25');
        Map<String, String> tempItem1 = new Map<String, String>();
        tempItem1.put('Id', (String)result2Object.getSalesCoachSections().get(0).getSalesCoachSectionItems().get(0).Id);
        tempItem1.put('Item_Name__c','e1');
        tempItem1.put('Section_Ordering__c','1');
        tempItem1.put('Link_to_Content__c','salesforce.com');
        List<Map<String, String>> sectionItems = new List<Map<String, String>>();
        sectionItems.add(tempItem1);
        Map<String, Object> superSection = new Map<String, Object>();
        superSection.put('salesCoachSection', section1);
        superSection.put('salesCoachSectionItems', sectionItems);
		List<Object> superSectionList = new List<Object>();
		superSectionList.add(superSection);
        
        SalesCoachLightning.saveStage('testStage', 'updatedDescription', JSON.serialize(result2Object.getSalesCoachActivities()),
                                      JSON.serialize(superSectionList));
        
        //Finally we check that the updates have succeeded
        String result3 = SalesCoachLightning.populateStage('testStage');
        SalesCoachLightning.MegaObject result3Object = 
            (SalesCoachLightning.MegaObject)JSON.deserialize(result3, SalesCoachLightning.MegaObject.class);
        System.assert(result3Object.getStageDescription() == 'updatedDescription');
        System.assert(result3Object.getSalesCoachActivities().size() == 1);
        System.assert(result3Object.getSalesCoachSections().size() == 1);
        System.assert(result3Object.getSalesCoachSections().get(0).getSalesCoachSectionItems().size() == 1);
    }
    
    //Helpers
    private static testMethod SalesCoachLightning.SuperSection generateSuperSection() {
        SalesCoachLightning.initializeState('testStage');
        Sales_Coach_Stage__c stageObject = SalesCoachLightning.getStageObject('testStage');
        
        //Initialize section and items
        Sales_Coach_Section__c a = new Sales_Coach_Section__c(
            Sales_Coach_Stage__c = stageObject.Id,
            Section_Name__c = 'a1',
            Section_Ordering__c = Decimal.valueOf(1),
            Section_Width__c = Decimal.valueOf(25));
        Sales_Coach_Section_Item__c b = new Sales_Coach_Section_Item__c(
            Sales_Coach_Section__c = a.Id,
            Item_Name__c = 'b1',
            Section_Ordering__c = Decimal.valueOf(1),
            Link_to_Content__c = 'salesforce.com');
        Sales_Coach_Section_Item__c c = new Sales_Coach_Section_Item__c(
            Sales_Coach_Section__c = a.Id,
            Item_Name__c = 'c1',
            Section_Ordering__c = Decimal.valueOf(2),
            Link_to_Content__c = 'salesforce.com');
        
        List<Sales_Coach_Section_Item__c> d = new List<Sales_Coach_Section_Item__c>();
        d.add(b);
        d.add(c);
        
        SalesCoachLightning.SuperSection e = new SalesCoachLightning.SuperSection(a,d);
        return e;
    }
    
    private static testMethod String generateSerializedSuperSectionList() {
        SalesCoachLightning.initializeState('testStage');
        Sales_Coach_Stage__c stageObject = SalesCoachLightning.getStageObject('testStage');
        
        Map<String, String> section1 = new Map<String, String>();
        section1.put('Section_Name__c', 'a1');
        section1.put('Section_Ordering__c', '1');
        section1.put('Section_Width__c', '25');
        Map<String, String> tempItem1 = new Map<String, String>();
        tempItem1.put('Item_Name__c','b1');
        tempItem1.put('Section_Ordering__c','1');
        tempItem1.put('Link_to_Content__c','salesforce.com');
        Map<String, String> tempItem2 = new Map<String, String>();
        tempItem2.put('Item_Name__c','c1');
        tempItem2.put('Section_Ordering__c','2');
        tempItem2.put('Link_to_Content__c','salesforce.com');
        List<Map<String, String>> sectionItems = new List<Map<String, String>>();
        sectionItems.add(tempItem1);
        sectionItems.add(tempItem2);
        Map<String, Object> superSection = new Map<String, Object>();
        superSection.put('salesCoachSection', section1);
        superSection.put('salesCoachSectionItems', sectionItems);
		
		List<Object> superSectionList = new List<Object>();
		superSectionList.add(superSection);        
        return JSON.serialize(superSectionList);
    }
    
    private static testMethod Id generateStage() {
        SalesCoachLightning.initializeState('testStage');
        Sales_Coach_Stage__c stageObject = SalesCoachLightning.getStageObject('testStage');
        List<Sales_Coach_Activity__c> actList = new List<Sales_Coach_Activity__c>();
        Sales_Coach_Activity__c act = new Sales_Coach_Activity__c(Sales_Coach_Stage__c = stageObject.Id,
                                                                  Ordering_Number__c = 1,
                                                                  Activity_Details__c = 'Deets');
        actList.add(act);
        
        SalesCoachLightning.saveStage('testStage', 'testDescription', JSON.serialize(actList), generateSerializedSuperSectionList());
        return stageObject.Id;
    }
}