trigger afterUpdate31 on Account (before update, after update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        TriggerExample1.beforeUpdate(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        TriggerExample1.afterUpdate(Trigger.new);
    }

}