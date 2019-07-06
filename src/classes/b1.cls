global class b1 implements database.Batchable<sobject> {
    global final string query;
    global final string s_object;
    global final string field;
    global final string field_value;
    
    global b1(string q, string s, string f, string v){
        query = q;
        s_object =s;
        field = f;
        field_value = v;
    }
    global database.querylocator start(database.BatchableContext BC){
        return database.getQueryLocator(query);
    }  
    global void execute(database.BatchableContext BC, List<sobject> batch){
        for (sobject o : batch){
            o.put(field, field_value);
        }
        update batch;
        }
    global void finish(database.BatchableContext BC){
        }
        }