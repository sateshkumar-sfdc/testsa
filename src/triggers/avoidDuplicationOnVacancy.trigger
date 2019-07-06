//
// Avoid Duplication on Vacancy
//
trigger avoidDuplicationOnVacancy on Vacancy__c (before insert, before update) {
    for(Vacancy__c vac: trigger.new)
    {
        // Display Vacancy Record
        System.debug('Vacancy Name is ' + vac.name);
        integer RecordCount = [select count() from Vacancy__c where Name = : vac.Name];
        if(RecordCount>0)
        {
            //Display the error Message
            vac.Name.AddError('The vacancy already been published, please try to post a different vacancy');
        }
    }
    

}