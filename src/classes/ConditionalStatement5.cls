public class ConditionalStatement5 {
    integer a,b;
    public void method(){
        a=10; b=20;
        System.debug('Before execution');
        do{
            System.debug('condition run ');
            
            a= a+2;
        } while(a>b);
            System.debug('after the condition');
    }

}