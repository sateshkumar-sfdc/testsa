({
    doInit : function(cmp, evt, helper) {
        helper.showSpinner(cmp);
        helper.resetSectionErrors(cmp);
        var stagesAction = cmp.get("c.getOpptyStagesLightning");
        stagesAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                var stagesObject = JSON.parse(response.getReturnValue());
                cmp.set("v.stages", stagesObject);
                cmp.set("v.selectedStage", stagesObject[0].label);
                helper.loadStageData(cmp, stagesObject[0].label, helper);
            }
            else {
                console.log("Call to get Opportunity Stages Failed!");
                helper.hideSpinner(cmp);
                cmp.set("v.shouldRenderPage", false);
            }
        });
        $A.enqueueAction(stagesAction);
    },
    
    stageChange : function(cmp, evt, helper) {
        helper.changeCurrentState(cmp, helper);
    },
    
    deleteActivity : function(cmp, evt, helper) {
        var idToDelete = helper.getDataId(evt);
        helper.deleteStageActivity(cmp, idToDelete);
    },
    
    saveActivity : function(cmp, evt, helper) {
        var stageActivityModalError = cmp.find("stageActivityModalError");
        var activityOrder = cmp.find("modalActivityOrdering").get("v.value");
        var orderNumber = parseInt(activityOrder);
        var activityDetails = cmp.find("modalActivityDetails").get("v.value");
        var modalMode = cmp.get("v.modalMode");
        var editDetails = cmp.get("v.editDetails");
        
        //Null checks
        if(activityOrder === undefined || activityOrder === null)
            activityOrder = "";
        
        if(activityDetails === undefined || activityDetails === null)
            activityDetails = "";
        
        //Data checks
        if(activityOrder.length == 0 && activityDetails.length > 0) {
            $A.util.addClass(stageActivityModalError, "displayNone");
            if(modalMode === "add")
            	helper.addStageActivity(cmp, "", activityDetails);
            else
                helper.editStageActivity(cmp, "", activityDetails, editDetails.index);
            helper.closeAllModals(cmp);
        }
        else if(!Number.isNaN(orderNumber) && activityDetails.length > 0){
            //Close error if present, add to stageActivities
            $A.util.addClass(stageActivityModalError, "displayNone");
            if(modalMode === "add")
            	helper.addStageActivity(cmp, String(orderNumber), activityDetails);
            else
                helper.editStageActivity(cmp, String(orderNumber), activityDetails, editDetails.index);
            helper.closeAllModals(cmp);
        }
        else { //Open error mesage
            $A.util.removeClass(stageActivityModalError, "displayNone");
        }
    },
    
    newStageActivity : function(cmp, evt, helper) {
        var stageActivityModal = cmp.find("addStageActivityModal");
        var stageActivityBackdrop = cmp.find("addStageActivityBackdrop");
        cmp.set("v.modalMode", "add");
        $A.util.addClass(stageActivityModal, "slds-fade-in-open");
        $A.util.addClass(stageActivityBackdrop, "slds-backdrop--open");
    },
    
    editActivity : function(cmp, evt, helper) {
        var idToEdit = helper.getDataId(evt);
        var stageActivities = cmp.get("v.stageActivities");
        cmp.set("v.modalMode", "edit");
        cmp.set("v.editDetails", {"sectionIndex": -1, "index": idToEdit});
		
        //Set Input Fields
        cmp.find("modalActivityOrdering").set("v.value", stageActivities[idToEdit].Ordering_Number__c);
        cmp.find("modalActivityDetails").set("v.value", stageActivities[idToEdit].Activity_Details__c);
        var stageActivityModal = cmp.find("addStageActivityModal");
        var stageActivityBackdrop = cmp.find("addStageActivityBackdrop");
        $A.util.addClass(stageActivityModal, "slds-fade-in-open");
        $A.util.addClass(stageActivityBackdrop, "slds-backdrop--open");
    },
    
    cancelModal : function(cmp, evt, helper) {
        helper.closeAllModals(cmp);
    },
    
    saveSectionItem : function(cmp, evt, helper) {
        var modalSection = cmp.get("v.sectionItemModalSection");
        var success = helper.saveSection(cmp, modalSection);
        if(success) {
        	cmp.set("v.sectionItemModalSection", "");
        }
    },
    
    showTab : function(cmp, evt, helper) {
        var idToShow = helper.getDataId(evt);
        helper.changeTab(cmp, idToShow);
    },
    
    deleteItem : function(cmp, evt, helper) {
        var dataObject = helper.getSectionPlusData(evt);
        var sectionNumber = dataObject[0];
		var idToDelete = dataObject[1];
        helper.deleteSectionItem(cmp, sectionNumber, idToDelete);
    },
    
    editItem : function(cmp, evt, helper) {
        var dataObject = helper.getSectionPlusData(evt);
        var sectionNumber = dataObject[0];
		var idToEdit = dataObject[1];
        var superSections = cmp.get("v.superSections");
        var sectionItems = superSections[parseInt(sectionNumber)-1].salesCoachSectionItems;
        cmp.set("v.sectionItemModalSection", sectionNumber);
        cmp.set("v.modalMode", "edit");
        cmp.set("v.editDetails", {"sectionIndex": sectionNumber, "index": idToEdit});
		
        //Set Input Fields
        cmp.find("modalItemOrdering").set("v.value", sectionItems[idToEdit].Section_Ordering__c);
        cmp.find("modalItemName").set("v.value", sectionItems[idToEdit].Item_Name__c);
        cmp.find("modalItemURL").set("v.value", sectionItems[idToEdit].Link_to_Content__c);
        helper.openSectionItemModal(cmp);
    },
    
    newSectionItemModal : function(cmp, evt, helper) {
        var sectionNumber = helper.getDataId(evt);
        cmp.set("v.sectionItemModalSection", sectionNumber);
        cmp.set("v.modalMode", "add");
        helper.openSectionItemModal(cmp);
    },
    
    clearSectionInfo : function(cmp, evt, helper) {
        helper.resetSectionErrors(cmp);
        var sectionNumber = helper.getDataId(evt);
        helper.clearSection(cmp, sectionNumber);
    },
    
    prepareSave : function(cmp, evt, helper) {
        helper.resetSectionErrors(cmp);
        helper.updateSuperSections(cmp);
        helper.removeBlankSuperSections(cmp);
        var dataValid = helper.saveDataCheck(cmp);
        if(dataValid) {
            helper.showSpinner(cmp);
            helper.saveStageData(cmp, helper);
            console.log("Success!");
        }
    },
    
    closeSaveSuccessPrompt : function(cmp, evt, helper) {
        var prompt = cmp.find("saveSuccessPrompt");
        var backdrop = cmp.find("saveSuccessBackdrop");
        $A.util.removeClass(prompt, "slds-fade-in-open");
        $A.util.removeClass(backdrop, "slds-backdrop--open");
        helper.changeCurrentState(cmp, helper);
    },

    closeSaveFailurePrompt : function(cmp, evt, helper) {
        var prompt = cmp.find("saveFailurePrompt");
        var backdrop = cmp.find("saveFailureBackdrop");
        $A.util.removeClass(prompt, "slds-fade-in-open");
        $A.util.removeClass(backdrop, "slds-backdrop--open");
    }
})