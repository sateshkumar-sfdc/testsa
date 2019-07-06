public with sharing class TestCon {
    @AuraEnabled
    public static List<Contact> getContacts(){
        return [SELECT id,lastname,phone from Contact LIMIT 10];
    }
    
}