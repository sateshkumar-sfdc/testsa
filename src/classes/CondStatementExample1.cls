public class CondStatementExample1 {
    public void addTwo1(integer vOne, Integer vTwo){
        System.debug('=======vOne====:'+vOne);
        System.debug('=======vTwo====:'+vTwo);
        Integer total = vOne + vTwo;
        System.debug('Total Before Conditional sttement : '+total);
        
        if(total >= 10){
            System.debug('===========Total is greater than 10');
        }
    }

}