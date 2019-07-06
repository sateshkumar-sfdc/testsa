public class SetExample {
    public static void setExample(){
        Set<String> hset=new Set<String>();
        hset.add('apple');
        hset.add('Mango');
        hset.add('grapes');
        hset.add('Orange');
        
        hset.add('Fig');
        hset.add('Apple');
        hset.add('Mango');
        hset.add(null);
        hset.add(null);
        //display my elements
        System.debug('Elements of my set '+hset);
        
    }

}