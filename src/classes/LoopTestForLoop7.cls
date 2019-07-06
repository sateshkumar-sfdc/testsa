public class LoopTestForLoop7 {
    public static void loopForloop7(){
        List<integer> MyList = new List<integer>{10,100,1000,10000};
        
        for(integer j =0; j<=MyList.size()-1; j++){
            System.debug('my List '+MyList[j]);
            System.debug('my List '+MyList.get(j));
        }
    }

}