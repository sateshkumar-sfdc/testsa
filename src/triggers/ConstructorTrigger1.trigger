trigger ConstructorTrigger1 on Contact (before insert, before update) {
    AddClass3 aC = new AddClass3();
    //aC.AddClass3();
    AddClass3.addTwo1(1, 2);
    System.debug('-----------------------------------');
    aC.addThree1(1, 2, 3);
    Integer result = aC.addThree1(1, 2, 3);

    System.debug('=========result: '+result);
     aC.addFour1(1, 4, 5,7);
    
}