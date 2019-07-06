trigger ConStatementExample on Case (before insert, before update) {
ConStatementExample csc=new ConStatementExample();
csc.addTwo(11,12);

}