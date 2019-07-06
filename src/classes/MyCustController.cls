public with sharing class MyCustController {


    public String empName { get; set; }
    
    public String empSal;
    
    public void setEmpSal(String sal) {
        empSal = sal;
        }

    public String getEmpSal() {
        return empSal;
    }

     public PageReference myAction() {
          System.debug('================Inside the MyAction');
                return null;
    }
    
}