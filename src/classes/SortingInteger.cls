public class SortingInteger {
    public static void sortingInteger(){
        List<Integer> myList=new List<Integer>{100,34,80,79};
        system.debug('My list has following items '+myList); //100,34,80,79
        System.debug('My List index 0 ' +myList.get(0)); //100
        System.debug('My List Index 1 ' +myList.get(1)); //34
        System.debug('My list Index 2 ' +myList.get(2)); //80
        System.debug('my list index 3 ' +myList.get(3)); //79
        myList.sort();                                              //sorting the order
        System.debug('My List has folloing after sort '+myList); //34,79,80,100
        
        System.debug('My List after index 0 ' +myList[0]); // 34
        System.debug('My List after Index 1 ' +myList.get(1)); //79
        System.debug('My list after Index 2 ' +myList.get(2)); //80
        System.debug('my list after index 3 ' +myList.get(3)); //100
    }

}