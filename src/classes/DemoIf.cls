public class DemoIf {
    public static void testIf(integer userAge){
        //integer userAge = 25;
        
        if(userAge <= 18){
            System.debug('User is younger than 18 or equal');
        }else{
            System.debug('User is older than 18');
        }
    }

}