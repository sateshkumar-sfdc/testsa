//
//
//
public class CollectionExample {

    public void displayList(){
        List<Integer> li=new List<Integer>();
        li.add(1);
        li.add(2);
        li.add(3);
        li.add(5);
        li.add(4);
        li.add(6);
        li.add(6);
        System.debug('.............................List Li '+li);
        for(Integer val: li) {
            system.debug('____________val: ' +val);
        }
}

 public void displaySet(){
        Set<Integer> se=new Set<Integer>();
        se.add(1);
        se.add(2);
        se.add(3);
        se.add(4);
        se.add(5);
        se.add(6);
        se.add(6);
        System.debug('.............................List se: '+se);
        for(Integer val: se) {
            system.debug('____________val: ' +val);
        }
}

 public void displayMap(){
        Map<Integer, String> ma=new Map<Integer, String>();
        ma.put(1,'Ani');
        ma.put(2, 'Ash');
        ma.put(3, 'Cha');
        ma.put(4, 'Dee');
        ma.put(5, 'Mad');
        ma.put(6, 'sat');
        ma.put(6, 'sat');
        System.debug('.............................Map ma: '+ma);
        Set<Integer> kset = ma.keySet();
        System.debug('.............................Set ma: '+kset);
       for(Integer ke: kset) {
           system.debug('____________val: ' +ke);
           String value = ma.get(ke);
           System.debug('============Value: '+value);
        }
  }
  }