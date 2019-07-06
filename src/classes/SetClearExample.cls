public class SetClearExample {
    public static void setClearEample(){
        Set<String> hset=new Set<String>();
            hset.add('test1');
            hset.add('Test2');
            hset.add('test3');
            hset.add('test4');
            hset.add('test4');
            hset.add('test5');
            
            System.debug('element in My set ' +hset);
            System.debug('size of set ' +hset.size());
            hset.clear();
            System.debug('element in My set ' +hset);
            System.debug('size of set ' +hset.size());
            
            
            
        }
    }