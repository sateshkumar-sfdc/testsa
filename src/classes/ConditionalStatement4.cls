public class ConditionalStatement4 {
    integer a,b;
    public void method(){
        a=10; b=20;
        system.debug('Before while execution');
        while(a<b){
            System.debug('While condition');
            a =a+2;
        }
        
        System.debug('Just print after the while');
    }

}