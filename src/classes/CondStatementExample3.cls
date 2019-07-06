public class CondStatementExample3 {
    public void addTwo3(integer vOne, integer vTwo) {
        System.debug('=====vOne=====: '+vOne);
        System.debug('=====Vtwo=====: '+vTwo);
        integer total = vOne + vTwo;
        
        if (total >= 10){
            System.debug('======Total is greater than 10');
            if (vOne >= 5){
                System.debug('+++++++vOne Is greater thank equal to 5');
            } else {
                System.debug('+++++++vTwo is greater than 5');
            }
        } else {
            System.debug('======Total is less than 10');
        }
    }

}