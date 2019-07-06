public class AddClass3 {
    public AddClass3(){
        System.debug('===========Inside the Constructor. =======');
    }
    public static void addTwo1(Integer vOne, Integer vTwo){
        Integer total = vOne + vTwo;
        System.debug('=========vOne====='+vOne);
        System.debug('=========vTwo====='+vTwo);
        System.debug('=========total===='+total);
    }
    public integer addThree1(integer vOne, Integer vTwo, Integer vThree ){
        integer total = vOne + vTwo + vThree;
        System.debug('=========vOne====='+vOne);
        System.debug('=========vTwo====='+vTwo);
        System.debug('=========vThree====='+vThree);
        System.debug('=========total===='+total);
        System.debug('=========total===='+total);
        return total;
        
        
    }
    public void addFour1(integer vOne, Integer vTwo, Integer vThree, Integer vFour ){
        integer total = vOne + vTwo + vThree + vFour;
        System.debug('=========vOne====='+vOne);
        System.debug('=========vTwo====='+vTwo);
        System.debug('=========vThree====='+vThree);
        System.debug('=========vFour====='+vFour);
        System.debug('=========total===='+total);
        //return total;

}
}