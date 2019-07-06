//
//
//
trigger ConStatementExample1  on Case (before insert, before update) {
    
    ConStatementExample cse=new ConStatementExample ();
    cse.addTwo(2,3);

}