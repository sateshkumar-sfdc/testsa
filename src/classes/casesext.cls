public class casesext {

    public casesext(ApexPages.StandardSetController controller) {

    }
    public PageReference NewTest(){
   PageReference Page = new PageReference ('/apex/CasesSave');
    return page;
    }

}