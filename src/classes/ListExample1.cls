public class ListExample1 {
    public static void listExample1(){
        List<String> obj=new List<String>();
        obj.add('Ajeet');
        obj.add('Harry');
        obj.add('Steve');
        System.debug('my friends'+obj);
        obj.add(0,'Rahul');
        obj.add(1,'Justin');
        obj.add('Harry');
        
         System.debug('New list of friends'+obj);
        obj.remove(1);
         System.debug('Final list of friends'+obj);
        
    }

}