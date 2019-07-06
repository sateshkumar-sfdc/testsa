trigger OppTrigger11 on Opportunity (before insert, before update) {
    for(Opportunity opp : Trigger.new)
    {
        if(opp.stageName == 'prospecting')
        {
            opp.Probability = 25;
        }
    }
    

}