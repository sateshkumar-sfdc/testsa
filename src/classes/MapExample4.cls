public class MapExample4 {
    public static void mapExample4(){
        Map<Integer,String> hmap=new Map<Integer,String>();
        hmap.put(12,'Chaitanya');
        hmap.put(2,'Rahul');
        hmap.put(7,'Singh');
        hmap.put(49,'Ajeet');
        hmap.put(3,'Anuj');
        System.debug('all the elements in my Map '+hmap);
        String var=hmap.get(2);
        system.debug('Value of the var '+var);
        String var1=hmap.get(49);
        System.debug('Value of the Var1 '+var1);
        System.debug('Size of the Map '+hmap.size());
        hmap.clear();
         System.debug('Size of the Map '+hmap.size());
        
        
    }

}