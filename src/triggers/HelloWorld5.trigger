trigger HelloWorld5 on Lead (before update) {
    for(Lead l : Trigger.new)
    {
        l.FirstName = 'Satish';
        l.Lastname  = 'Kumar';
    }

}