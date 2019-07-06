({
    
 onWorkAccepted : function(component, event, helper) {
        console.log("Work accepted.");
        var workItemId = event.getParam('workItemId');
        var workId = event.getParam('workId');
        console.log(workItemId);
        console.log(workId);
     var action = component.get("c.updateOpportunityOwner");
     action.setParams({ workItemId : workItemId });
     action.setCallback(this,function(actionResult) {
         
     });
     $A.enqueueAction(action);
     $A.get("e.force:refreshView").fire()
     

       
    }
    



    
})