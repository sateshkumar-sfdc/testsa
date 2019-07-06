//
// This class is to cover loops concept
//
public class LoopExample1 {
    public void printStatement(){
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
        System.debug('Hello SFDC');
    }
    public void printStatementDoWhile(Integer numOfTimes) {
        Integer counter = 1;
        do {
            System.debug('======Hello SFDC Do While ======');  
            counter = counter + 1;
        } while(counter <= numOftimes);
    }
    public void printStatementWhile(integer numOfTimes){
        integer counter =1;
            while(counter <= numOfTimes) {
                System.debug('===========Print While ========');
                counter++;//counter = counter + 1;
            }
    }
    public void printStatementFor(integer numOfTimes){
        
    for (integer counter = 1;counter <= numOftimes;counter++) {
                System.debug('======for Loop Output======');
        //counter++;
    }

}
}