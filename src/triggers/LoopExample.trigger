//
//
//
trigger LoopExample on Lead (before insert, before update) {
    LoopExample le = new LoopExample();
    le.printStatement ();
    System.debug('===================Start do whileTrigger======================');
    le.printStatementDoWhile(5);
    System.debug ('------------------While-------------------');
    le.printStatementWhile(5);
    System.debug ('------------------For loop-------------------');
    le.printStatementFor(20);
    }

//}