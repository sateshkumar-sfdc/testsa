public class MapExample2 {
    public static void mapExa2(){
        Map<String, String> myStrings=new Map<String, String>{'a'=>'apple','b'=>'boy'};
            System.debug('map value for key value  a' +myStrings.get('a'));
      	  	System.debug('map value for key value  b' +myStrings.get('b'));
            System.debug('Map values for key ' +myStrings);
    }

}