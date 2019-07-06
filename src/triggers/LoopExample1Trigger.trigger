trigger LoopExample1Trigger on Lead (before insert, before update) {
    LoopExample1 le = new LoopExample1();
    le.printStatement();
    System.debug('=========================Do While================================');
    le.printStatementDoWhile(1);
    System.debug('=========================While================================');
    le.printStatementWhile(1);
    System.debug('=========================For Loop================================');
    le.printStatementFor(1);

}