//
//
//
trigger SOQLExample on Account (before insert, before update) {

    SOQLExample se = new SOQLExample();
        se.getAccounts();
        //}
    

}