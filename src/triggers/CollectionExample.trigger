//
//
//
trigger CollectionExample on Opportunity (before insert, before update) {
    
    CollectionExample ce = new CollectionExample();
    ce.displayList();
    System.debug('*************************************************************************************');
   // CollectionExample ce = new CollectionExample();
    ce.displaySet();
     System.debug('**********************************MAP***************************************************');
   // CollectionExample ce = new CollectionExample();
    ce.displayMap();
}