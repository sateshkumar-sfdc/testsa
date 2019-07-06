({
	doInit : function(cmp, evt, helper) {
        helper.showSpinner(cmp);
        //Guard: This component should only be used on Opportunities
        var recordId = cmp.get("v.recordId");
        if(recordId.substring(0,3) !== "006") {
            cmp.set("v.entityError", true);
            return;
        }
        
        //helper.initMockData(cmp, evt, helper);
        var stagesAction = cmp.get("c.getOpptyStagesLightning");
        stagesAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                var stagesObject = JSON.parse(response.getReturnValue());
                cmp.set("v.stages", stagesObject);
            }
            else {
                console.log("Call to get opportunity stages failed!");
                helper.hideSpinner(cmp);
                cmp.set("v.shouldRenderPage", false);
            }
        });
        $A.enqueueAction(stagesAction);
        
        var currentStageAction = cmp.get("c.getCurrentOpptyStage");
        currentStageAction.setParams({'recordId': recordId});
        currentStageAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                var currentStageString = response.getReturnValue();
                cmp.set("v.selectedStage", currentStageString);
                cmp.find("stageSelect").set("v.value", currentStageString);
                helper.populateStage(cmp, currentStageString, helper);
            }
            else {
                console.log("Call to get current opportunity stage failed!");
                helper.hideSpinner(cmp);
            }
        });
        $A.enqueueAction(currentStageAction);
    },
    
    stageChange : function(cmp, evt, helper) {
        cmp.set("v.shouldRenderPage", true);
        var stage = cmp.find("stageSelect").get("v.value");
        cmp.set("v.selectedStage", stage);
        helper.showSpinner(cmp);
        helper.populateStage(cmp, stage, helper);
    },
})