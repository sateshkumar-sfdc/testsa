public class ConStatementExample {
    public void addTwo(Integer vOne, Integer vTwo){
        System.debug('**********************vOne '+vOne);
        System.debug('**********************vTwo '+vTwo);
        Integer Total = vOne+vTwo;
        if(Total>=10){
            System.debug('**************Total Is Greater than eql to 10');
        }else{
            System.debug('Total is less than 10');
        
        }
        }
}