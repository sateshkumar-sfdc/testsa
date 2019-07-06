public class ConditionalStatement {
    integer a,b;
    
    public void method(){
        a = 25; b = 20;
        System.debug('beofre condition');
        if(a > b){
            // If condition block trigger
            System.debug('Condition Satisfied');
        }
        else {
            // Else block active
            System.debug('not Matching the condition');
        }
    }

}