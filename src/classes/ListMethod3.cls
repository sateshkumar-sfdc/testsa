public class ListMethod3 {
    public static void listMethod3(){
        List<String> myList=new List<String>{'one','three','two','four'};
        system.debug('The list of all elements'+myList);
        system.debug('Size of the list '+myList.size());
        myList.add('Eleven');
        system.debug('Size of the list '+myList.size());
        System.debug('new list'+myList);
        System.debug('Element at index 1'+myList[1]);
        System.debug('Eleemnt at index using get'+myList.get(1));
        myList.add('Hello');
        myList.add('satish');
        System.debug('Total Size '+myList.size());
            }
    }