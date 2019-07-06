public with sharing class SalesCoachRedirect {
    
    private final Opportunity opp;
    
    public SalesCoachRedirect(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }
    
    public PageReference goToSalesCoach() {
        PageReference salesCoachPage = new PageReference('/apex/SalesCoachV2?id='+((String)opp.Id));
        salesCoachPage.setRedirect(true);
        return salesCoachPage;
    }
}