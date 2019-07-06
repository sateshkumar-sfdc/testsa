//
//Trigger for Conditional statement example
//
trigger CondStatementExample1 on Case (before insert, before update) {
    System.debug('=========Trigger Start===========');
    CondStatementExample1 cse = new CondStatementExample1();
    cse.addTwo1(6, 4);
    System.debug('===============Trigger end=========');

}