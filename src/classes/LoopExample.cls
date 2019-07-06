//
// this class is explain to cover the loops concepts.
//
public class LoopExample {

    public void printStatement (){
        system.debug('***************Hello SFDC');
        system.debug('***************Hello SFDC');
        system.debug('***************Hello SFDC');
    }
    public void printStatementDoWhile(Integer numOfTimes){
        Integer counter =1;
        do{
            system.debug('***************Hello SFDC');
            counter = counter+1;
            }while(counter<=numOfTimes);
        }
   public void printStatementWhile(Integer numOfTimes){
       integer counter = 1;
           while(counter <= numOfTimes){
               System.debug('%%%%%%%%%%%%%%%%%%%Hello%%%%%%%%%%%%%%%%%%%%%%%%');
              counter++; // counter = counter+1;
               }
               }
    public void printStatementFor(integer numOfTimes){
    
        
            for(integer counter = 1;counter <= numOfTimes; counter++)
            {
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&Super&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                //counter++;
       
    }
}
}