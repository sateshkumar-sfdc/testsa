//
// Account demo Trigger -> Phone number field make it as Mandatory
//
trigger accountTrigger11 on Account (before insert, before update ) {
    for (Account acc : Trigger.new)
    {
        if(acc.Phone == null)
        {
            acc.Phone = '2345678912';
            
                            
        }
    }
    

}