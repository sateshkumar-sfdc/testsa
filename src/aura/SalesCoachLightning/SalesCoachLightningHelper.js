({
    populateStage : function(cmp, stage, helper) {
        var populateAction = cmp.get("c.populateStage");
        populateAction.setParams({'stage': stage});
        populateAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                var megaObject = JSON.parse(response.getReturnValue());
                cmp.set("v.shouldRenderPage", megaObject.renderCheck);
                cmp.set("v.stageDescription", megaObject.stageDescription);
                cmp.set("v.stageActivities", megaObject.salesCoachActivities);
                cmp.set("v.stageSections", megaObject.salesCoachSections);
                helper.hideSpinner(cmp);
            }
            else {
                console.log("Call to get populate stage information failed!");
                cmp.set("v.shouldRenderPage", false);
                cmp.set("v.stageDescription", "");
                cmp.set("v.stageActivities", {});
                cmp.set("v.stageSections", {});
                helper.hideSpinner(cmp);
            }
        });
        $A.enqueueAction(populateAction);
    },
    
    showSpinner : function(cmp) {
        var spinner = cmp.find("pageSpinner");
        $A.util.removeClass(spinner, "hideSpinner");
        $A.util.addClass(spinner, "showSpinner");
    },
    
    hideSpinner: function(cmp) {
        var spinner = cmp.find("pageSpinner");
        $A.util.removeClass(spinner, "showSpinner");
        $A.util.addClass(spinner, "hideSpinner");
    }
})