public class FirstClass {
    Public Integer i;
    Public String s;
    Public firstClass(){
        
        i = 10;
        s ='satish';
        system.debug('Integer i Value : '+i);
        System.debug('String s Value : '+s);
        
    }
    public void method1(){
        System.debug('Integer Value i : '+i);
        System.debug('String Value s : '+s);
    }
    public void method2(integer i, integer j){
        //integer k = i + j;
        System.debug('Total Value of i + j is : '+(i+j));
    }
}