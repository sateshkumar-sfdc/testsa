public class SortingExample {
    public static void sortingExample(){
        List<String> colors=new List<String>{'yello','Red','Green'};
            System.debug('My elements are in the list are '+colors);
        
        system.debug('color at index 0 ' +colors.get(0));
        System.debug('Color at index 1 ' +colors.get(1));
        System.debug('Color At index 2 ' +colors.get(2));
        colors.sort();
        system.debug('color at index 0 after sorting ' +colors.get(0));
        System.debug('Color at index 1 after sorting ' +colors.get(1));
        System.debug('Color At index 2 after sorting ' +colors.get(2));
    }

}