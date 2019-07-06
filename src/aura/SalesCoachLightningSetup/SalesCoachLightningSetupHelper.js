({
    loadStageData : function(cmp, stageName, helper) {
        var populateAction = cmp.get("c.populateStage");
        populateAction.setParams({'stage': stageName});
        populateAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                var megaObject = JSON.parse(response.getReturnValue());
                //null checks
                if(!megaObject.stageDescription)
                    megaObject.stageDescription = "";
                if(!megaObject.salesCoachActivities)
                    megaObject.salesCoachActivities = [];
                if(!megaObject.salesCoachSections)
                    megaObject.salesCoachSections = [];
                helper.fillInFields(cmp, megaObject.stageDescription,
                                    megaObject.salesCoachActivities,
                                    megaObject.salesCoachSections);
                helper.hideSpinner(cmp);
                cmp.set("v.shouldRenderPage", true);
            }
            else {
                console.log("Call to get populate stage information failed!");
                //Display error maybe?
                helper.hideSpinner(cmp);
                helper.clearAllData(cmp);
                cmp.set("v.shouldRenderPage", false);
            }
        });
        $A.enqueueAction(populateAction);
    },
    
    fillInFields : function(cmp, stageDescription, stageActivities, stageSections) {
        //Set description and sectionItems
        cmp.set("v.stageActivities", stageActivities);
        var stageDescriptionCmp = cmp.find("stageDescription");
        stageDescriptionCmp.set("v.value", stageDescription);
        var superSections = cmp.get("v.superSections");
        for(var i=0; i<5; i++) {
            if(stageSections[i])
                superSections[i] = stageSections[i];
            else
                superSections[i] = [];
        }
        cmp.set("v.superSections", superSections);
        
        //fill In Tab Inputs
        var sectionNames = cmp.find("sectionName");
        var sectionOrders = cmp.find("sectionOrder");
        var sectionWidths = cmp.find("sectionWidth");
        for(var i=0; i<5; i++) {
            if(stageSections[i] && stageSections[i].salesCoachSection) {
                if(stageSections[i].salesCoachSection.Section_Name__c !== null &&
                   stageSections[i].salesCoachSection.Section_Name__c !== undefined &&
                   stageSections[i].salesCoachSection.Section_Name__c.length > 0)
                    sectionNames[i].set("v.value", stageSections[i].salesCoachSection.Section_Name__c);
                else
                    sectionNames[i].set("v.value", "");
                
                if(stageSections[i].salesCoachSection.Section_Ordering__c !== null &&
                   stageSections[i].salesCoachSection.Section_Ordering__c !== undefined)
                    sectionOrders[i].set("v.value", stageSections[i].salesCoachSection.Section_Ordering__c);
                else
                    sectionOrders[i].set("v.value", "");
                
                if(stageSections[i].salesCoachSection.Section_Width__c !== null &&
                   stageSections[i].salesCoachSection.Section_Width__c !== undefined)
                    sectionWidths[i].set("v.value", stageSections[i].salesCoachSection.Section_Width__c);
                else
                    sectionWidths[i].set("v.value", "");
            }
        }
    },
    
    clearAllData : function(cmp) {
        cmp.set("v.stageActivities", []);
        cmp.find("stageDescription").set("v.value", "");
        var superSections = cmp.get("v.superSections");
        for(var i=0; i<5; i++) {
            superSections[i].salesCoachSection = {};
            superSections[i].salesCoachSectionItems = [];
        }
        cmp.set("v.superSections", superSections);
        for(var i=1; i<=5; i++) {
            var sectionName = cmp.find("sectionName")[i-1];
            var sectionOrder = cmp.find("sectionOrder")[i-1];
            var sectionWidth = cmp.find("sectionWidth")[i-1];
            sectionName.set("v.value", "");
            sectionOrder.set("v.value", "");
            sectionWidth.set("v.value", "");
        }
    },
    
    getDataId : function(evt) {
        var id = evt.target.getAttribute("data-data") ||
            evt.target.parentNode.getAttribute("data-data") ||
            evt.target.parentNode.parentNode.getAttribute("data-data") ||
            evt.target.parentNode.parentNode.parentNode.getAttribute("data-data");
        return id;
    },
    
    getSectionPlusData : function(evt) {
        var data = evt.target.getAttribute("data-data") ||
            evt.target.parentNode.getAttribute("data-data") ||
            evt.target.parentNode.parentNode.getAttribute("data-data") ||
            evt.target.parentNode.parentNode.parentNode.getAttribute("data-data");
        return data.split(',');
    },
    
    deleteStageActivity : function(cmp, idToDelete) {
        if(idToDelete !== undefined && idToDelete !== null) {
            var activityList = cmp.get("v.stageActivities");
            activityList.splice(parseInt(idToDelete), 1);
            cmp.set("v.stageActivities", activityList);
        }
    },
    
    addStageActivity : function(cmp, order, details) {
        var activityList = cmp.get("v.stageActivities");
        if(activityList !== undefined && activityList !== null) {
            //TODO: Do we need to create a new record here?
            activityList.push({"Ordering_Number__c": order, "Activity_Details__c": details});
            cmp.set("v.stageActivities", activityList);
        }
        else {
            activityList = [{"Ordering_Number__c": order, "Activity_Details__c": details}];
            cmp.set("v.stageActivities", activityList);
        }
    },
    
    editStageActivity : function(cmp, order, details, index) {
        var activityList = cmp.get("v.stageActivities");
        if(activityList !== undefined && activityList !== null &&
           activityList[index] !== undefined && activityList[index] !== null) {
            activityList[index].Ordering_Number__c = order;
            activityList[index].Activity_Details__c = details;
            cmp.set("v.stageActivities", activityList);
        }        
    },
    
    closeAllModals : function(cmp) {
        //Start by closing stage activity modal/error and removing all data
        var stageActivityModal = cmp.find("addStageActivityModal");
        var stageActivityBackdrop = cmp.find("addStageActivityBackdrop");
        var stageActivityModalError = cmp.find("stageActivityModalError");
        $A.util.removeClass(stageActivityModal, "slds-fade-in-open");
        $A.util.removeClass(stageActivityBackdrop, "slds-backdrop--open");
        $A.util.addClass(stageActivityModalError, "displayNone");
        cmp.find("modalActivityOrdering").set("v.value", "");
        cmp.find("modalActivityDetails").set("v.value", "");
        
        //Next we close section items modal/toas and remove all data
        var sectionItemModal = cmp.find("addSectionItemModal");
        var sectionItemBackdrop = cmp.find("addSectionItemBackdrop");
        var sectionItemModalError = cmp.find("sectionItemModalError");
        $A.util.removeClass(sectionItemModal, "slds-fade-in-open");
        $A.util.removeClass(sectionItemBackdrop, "slds-backdrop--open");
        $A.util.addClass(sectionItemModalError, "displayNone");
        cmp.find("modalItemOrdering").set("v.value", "");
        cmp.find("modalItemName").set("v.value", "");
        cmp.find("modalItemURL").set("v.value", "");
        cmp.set("v.sectionItemModalSection", "");
        
        //Remove add/edit logic
        cmp.set("v.modalMode", "");
        cmp.set("v.editDetails", {});
    },
    
    changeTab : function(cmp, tabNumber) {
        var tabs = cmp.find("sectionTab");
        var tab1 = tabs[0];
        var tab2 = tabs[1];
        var tab3 = tabs[2];
        var tab4 = tabs[3];
        var tab5 = tabs[4];
        var tabScopes = cmp.find("tabScoped");
        var tabScope1 = tabScopes[0];
        var tabScope2 = tabScopes[1];
        var tabScope3 = tabScopes[2];
        var tabScope4 = tabScopes[3];
        var tabScope5 = tabScopes[4];
        
        $A.util.removeClass(tab1, "slds-active");
        $A.util.removeClass(tab2, "slds-active");
        $A.util.removeClass(tab3, "slds-active");
        $A.util.removeClass(tab4, "slds-active");
        $A.util.removeClass(tab5, "slds-active");
        $A.util.removeClass(tabScope1, "slds-show");
        $A.util.removeClass(tabScope2, "slds-show");
        $A.util.removeClass(tabScope3, "slds-show");
        $A.util.removeClass(tabScope4, "slds-show");
        $A.util.removeClass(tabScope5, "slds-show");
        $A.util.addClass(tabScope1, "slds-hide");
        $A.util.addClass(tabScope2, "slds-hide");
        $A.util.addClass(tabScope3, "slds-hide");
        $A.util.addClass(tabScope4, "slds-hide");
        $A.util.addClass(tabScope5, "slds-hide");
        
        //Set new tab
        var newTab = tabs[parseInt(tabNumber)-1];
        var newTabScope = tabScopes[parseInt(tabNumber)-1];
        $A.util.addClass(newTab, "slds-active");
        $A.util.removeClass(newTabScope, "slds-hide");
        $A.util.addClass(newTabScope, "slds-show");
    },
    
    addSectionItem : function(cmp, sectionNumber, itemOrder, itemName, itemURL) {
        var superSections = cmp.get("v.superSections");
        if(superSections[parseInt(sectionNumber)-1].salesCoachSectionItems !== undefined && 
           superSections[parseInt(sectionNumber)-1].salesCoachSectionItems !== null) {
            superSections[parseInt(sectionNumber)-1].salesCoachSectionItems.push(
                {"Section_Ordering__c": itemOrder, "Item_Name__c": itemName, "Link_to_Content__c": itemURL}
            );
            cmp.set("v.superSections", superSections);
        }
        else {
            //We need to create the structure
            if(superSections[parseInt(sectionNumber)-1].length === undefined ||
               superSections[parseInt(sectionNumber)-1].length === 0)
                superSections[parseInt(sectionNumber)-1] = {};
            if(superSections[parseInt(sectionNumber)-1].salesCoachSection === undefined ||
               superSections[parseInt(sectionNumber)-1].salesCoachSection === null) {
                superSections[parseInt(sectionNumber)-1].salesCoachSection = {};
            }
            superSections[parseInt(sectionNumber)-1].salesCoachSectionItems = [];
            superSections[parseInt(sectionNumber)-1].salesCoachSectionItems.push(
                {"Section_Ordering__c": itemOrder, "Item_Name__c": itemName, "Link_to_Content__c": itemURL}
            );
            cmp.set("v.superSections", superSections);
        }
    },
    
    deleteSectionItem : function(cmp, sectionNumber, idToDelete) {
        var superSections = cmp.get("v.superSections");
        var sectionItems = superSections[parseInt(sectionNumber)-1].salesCoachSectionItems;
        if(sectionItems !== undefined && sectionItems !== null) {
            sectionItems.splice(parseInt(idToDelete), 1);
            cmp.set("v.superSections", superSections);
        }
    },
    
    editSectionItem : function(cmp, sectionNumber, itemOrder, itemName, itemURL, index) {
        var superSections = cmp.get("v.superSections");
        var sectionItems = superSections[parseInt(sectionNumber)-1].salesCoachSectionItems;
        if(sectionItems !== undefined && sectionItems !== null &&
           sectionItems[index] !== undefined && sectionItems[index] !== null) {
            sectionItems[index].Section_Ordering__c = itemOrder;
            sectionItems[index].Item_Name__c = itemName;
            sectionItems[index].Link_to_Content__c = itemURL;
            cmp.set("v.superSections", superSections);
        }
    },
    
    openSectionItemModal : function(cmp) {
        var sectionItemModal = cmp.find("addSectionItemModal");
        var sectionItemBackdrop = cmp.find("addSectionItemBackdrop");
        $A.util.addClass(sectionItemModal, "slds-fade-in-open");
        $A.util.addClass(sectionItemBackdrop, "slds-backdrop--open");
    },
    
    clearSection : function(cmp, sectionNumber) {
        var superSections = cmp.get("v.superSections");
        var salesCoachSection = superSections[parseInt(sectionNumber)-1].salesCoachSection;
        var salesCoachSectionItems = superSections[parseInt(sectionNumber)-1].salesCoachSectionItems;
        
        if(salesCoachSection != undefined && salesCoachSection != null) {
            salesCoachSection.Section_Name__c = "";
            salesCoachSection.Section_Ordering__c = "";
            salesCoachSection.Section_Width__c = "";
        }
        
        if(salesCoachSectionItems != undefined && salesCoachSectionItems != null &&
           salesCoachSectionItems.length > 0) {
            while(salesCoachSectionItems.length > 0)
                salesCoachSectionItems.pop();
        }
        
        cmp.set("v.superSections", superSections);
        
        //Clear Inputs
        var sectionName = cmp.find("sectionName")[parseInt(sectionNumber)-1];
        var sectionOrder = cmp.find("sectionOrder")[parseInt(sectionNumber)-1];
        var sectionWidth = cmp.find("sectionWidth")[parseInt(sectionNumber)-1];
        sectionName.set("v.value", "");
        sectionOrder.set("v.value", "");
        sectionWidth.set("v.value", "");
    },
    
    saveSection : function(cmp, sectionNumber) {
        var sectionItemModalError = cmp.find("sectionItemModalError");
        var modalItemOrder = cmp.find("modalItemOrdering").get("v.value");
        var orderNumber = parseInt(modalItemOrder);
        var modalItemName = cmp.find("modalItemName").get("v.value");
        var modalItemURL = cmp.find("modalItemURL").get("v.value");
        var modalMode = cmp.get("v.modalMode");
        var editDetails = cmp.get("v.editDetails");
        
        //nullChecks
        if(modalItemURL === undefined || modalItemURL === null || modalItemURL.length === 0)
            modalItemURL = "";
        
        if(modalItemName === undefined || modalItemName === null)
            modalItemName = "";
        
        if(modalItemOrder === undefined || modalItemOrder === null)
            modalItemOrder = "";
        
        //Data checks
        if(modalItemOrder.length == 0 && modalItemName.length > 0) {
            $A.util.addClass(sectionItemModalError, "displayNone");
            if(modalMode === "add")
                this.addSectionItem(cmp, sectionNumber , "", modalItemName, modalItemURL);
            else
                this.editSectionItem(cmp, sectionNumber, "", modalItemName, modalItemURL, editDetails.index)
                this.closeAllModals(cmp);
            return true;
        }
        else if(!Number.isNaN(orderNumber) && modalItemName.length > 0){
            //Close error if present, add to stageActivities
            $A.util.addClass(sectionItemModalError, "displayNone");
            if(modalMode === "add")
                this.addSectionItem(cmp, sectionNumber, String(orderNumber), modalItemName, modalItemURL);
            else
                this.editSectionItem(cmp, sectionNumber, String(orderNumber), modalItemName, modalItemURL, editDetails.index)
                this.closeAllModals(cmp);
            return true;
        }
            else { //Open error mesage
                $A.util.removeClass(sectionItemModalError, "displayNone");
                return false;
            }
    },
    
    showSpinner : function(cmp) {
        var spinner = cmp.find("pageSpinner");
        $A.util.removeClass(spinner, "hideSpinner");
        $A.util.addClass(spinner, "showSpinner");
    },
    
    hideSpinner : function(cmp) {
        var spinner = cmp.find("pageSpinner");
        $A.util.removeClass(spinner, "showSpinner");
        $A.util.addClass(spinner, "hideSpinner");
    },
    
    saveDataCheck : function(cmp) {
        var passAllChecks = true;
        var sectionNames = cmp.find("sectionName");
        var sectionOrders = cmp.find("sectionOrder");
        var sectionWidths = cmp.find("sectionWidth");
        var sectionNameErrors = cmp.find("sectionNameError");
        var sectionOrderErrors = cmp.find("sectionOrderError");
        var sectionWidthErrors = cmp.find("sectionWidthError");
        var saveError = cmp.find("saveError");
        var superSections = cmp.get("v.superSections");
        
        for(var i=0; i<5; i++) {
            var order = sectionOrders[i].get("v.value");
            var width = sectionWidths[i].get("v.value");
            
            //Start by checking that numeric fields are actually numbers
            if(order != null && order !== undefined && order.length > 0) {
                var orderNumber = parseInt(order);
                if(isNaN(orderNumber)) {
                    $A.util.removeClass(sectionOrderErrors[i], "displayNone");
                    $A.util.removeClass(saveError, "displayNone");
                    passAllChecks = false;
                }
            }
            
            if(width != null && width !== undefined && width.length > 0) {
                var widthNumber = parseInt(width);
                if(isNaN(widthNumber)) {
                    $A.util.removeClass(sectionWidthErrors[i], "displayNone");
                    $A.util.removeClass(saveError, "displayNone");
                    passAllChecks = false;
                }
            }
            
            //Next check for master-detail violations (items without section name)
            if(superSections[i].salesCoachSectionItems && superSections[i].salesCoachSectionItems.length > 0) {
                var sectionNameValue = sectionNames[i].get("v.value");
                if(sectionNameValue !== null && sectionNameValue !== undefined && sectionNameValue.length === 0) {
                    $A.util.removeClass(sectionNameErrors[i], "displayNone");
                    $A.util.removeClass(saveError, "displayNone");
                    passAllChecks = false;
                }
            }
        }
        return passAllChecks;
    },
    
    resetSectionErrors : function(cmp) {
        var sectionNameErrors = cmp.find("sectionNameError");
        var sectionOrderErrors = cmp.find("sectionOrderError");
        var sectionWidthErrors = cmp.find("sectionWidthError");
        var saveError = cmp.find("saveError");
        for(var i=0; i<5; i++) {
            $A.util.addClass(sectionNameErrors[i], "displayNone");
            $A.util.addClass(sectionOrderErrors[i], "displayNone");
            $A.util.addClass(sectionWidthErrors[i], "displayNone");
        }
        $A.util.addClass(saveError, "displayNone");
    },
    
    updateSuperSections : function(cmp, helper) {
        //Update the super sections with (possibly) new input fields
        var sectionNames = cmp.find("sectionName");
        var sectionOrders = cmp.find("sectionOrder");
        var sectionWidths = cmp.find("sectionWidth");
        var superSections = cmp.get("v.superSections");
        
        //Update values and turn everything into Strings (change null strings to 0 for decimal values)
        for(var i=0; i<5; i++) {
            if(superSections[i].salesCoachSection !== undefined && superSections[i].salesCoachSection !== null) {
                superSections[i].salesCoachSection.Section_Name__c = String(sectionNames[i].get("v.value")); //MANDATORY (Don't transform)
                if(String(sectionOrders[i].get("v.value")).length == 0)
                    superSections[i].salesCoachSection.Section_Ordering__c = "0";
                else
                    superSections[i].salesCoachSection.Section_Ordering__c = String(sectionOrders[i].get("v.value"));
                if(String(sectionWidths[i].get("v.value")).length == 0)
                    superSections[i].salesCoachSection.Section_Width__c = "0";
                else
                    superSections[i].salesCoachSection.Section_Width__c = String(sectionWidths[i].get("v.value"));
                if(superSections[i].salesCoachSectionItems !== undefined && superSections[i].salesCoachSectionItems !== null &&
                   superSections[i].salesCoachSectionItems.length > 0) {
                    for(var j=0; j<superSections[i].salesCoachSectionItems.length;j++) {
                        superSections[i].salesCoachSectionItems[j].Item_Name__c = String(superSections[i].salesCoachSectionItems[j].Item_Name__c); //MANDATORY (Don't transform)
                        if(String(superSections[i].salesCoachSectionItems[j].Section_Ordering__c).length == 0)
                            superSections[i].salesCoachSectionItems[j].Section_Ordering__c = "0";
                        else
                            superSections[i].salesCoachSectionItems[j].Section_Ordering__c = String(superSections[i].salesCoachSectionItems[j].Section_Ordering__c);
                        if(superSections[i].salesCoachSectionItems[j].Link_to_Content__c !== undefined)
                        	superSections[i].salesCoachSectionItems[j].Link_to_Content__c = String(superSections[i].salesCoachSectionItems[j].Link_to_Content__c);
                    	else
                            superSections[i].salesCoachSectionItems[j].Link_to_Content__c = "";
                    }
                }
                else {
                    superSections[i].salesCoachSectionItems = [];
                }
            }
            else {
                //If there is anything in the name input fields, we will have to create the structure
                if(sectionNames[i].get("v.value") !== undefined && String(sectionNames[i].get("v.value")).length > 0) {
                    if(superSections[i].length !== undefined) //This is an empty array, reinitialize to object
                        superSections[i] = {"salesCoachSection": {}, "salesCoachSectionItems": []};
                    superSections[i].salesCoachSection = {};
                    superSections[i].salesCoachSection.Section_Name__c = String(sectionNames[i].get("v.value"));
                    if(String(sectionOrders[i].get("v.value")).length == 0)
                        superSections[i].salesCoachSection.Section_Ordering__c = "0";
                    else
                        superSections[i].salesCoachSection.Section_Ordering__c = String(sectionOrders[i].get("v.value"));
                    if(String(sectionWidths[i].get("v.value")).length == 0)
                        superSections[i].salesCoachSection.Section_Width__c = "0";
                    else
                        superSections[i].salesCoachSection.Section_Width__c = String(sectionWidths[i].get("v.value"));
                }
            }
        }
        cmp.set("v.superSections", superSections);
    },
    
    removeBlankSuperSections : function(cmp, helper) {
        var sectionNames = cmp.find("sectionName");
        var superSections = cmp.get("v.superSections");
        
        for(var i=0; i<5; i++) {
            if(sectionNames[i].get("v.value") === undefined || String(sectionNames[i].get("v.value")).length === 0)
                superSections[i] = {"salesCoachSection": {}, "salesCoachSectionItems": []};
        }
    },
    
    saveStageData : function(cmp, helper) {
        var stageName = cmp.get("v.selectedStage");
        var stageDetails = cmp.find("stageDescription").get("v.value");
        var stageActivities = cmp.get("v.stageActivities");
        var superSections = cmp.get("v.superSections");
        
        var saveAction = cmp.get("c.saveStage");
        saveAction.setParams({
            'stage': stageName,
            'stageDetails': stageDetails,
            'stageActivitiesRaw': JSON.stringify(stageActivities),
            'superSectionsRaw': JSON.stringify(superSections)
        });
        saveAction.setCallback(cmp, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                
                helper.hideSpinner(cmp);
                helper.openSaveSuccessPrompt(cmp);
            }
            else {
                console.log("Error! Could not save stage data!");
                //Display error maybe?
                helper.hideSpinner(cmp);
                helper.openSaveFailurePrompt(cmp);
            }
        });
        $A.enqueueAction(saveAction);
    },
    
    openSaveSuccessPrompt : function(cmp) {
        var prompt = cmp.find("saveSuccessPrompt");
        var backdrop = cmp.find("saveSuccessBackdrop");
        $A.util.addClass(prompt, "slds-fade-in-open");
        $A.util.addClass(backdrop, "slds-backdrop--open");
    },
    
    openSaveFailurePrompt : function(cmp) {
        var prompt = cmp.find("saveFailurePrompt");
        var backdrop = cmp.find("saveFailureBackdrop");
        $A.util.addClass(prompt, "slds-fade-in-open");
        $A.util.addClass(backdrop, "slds-backdrop--open");
    },
    
    changeCurrentState : function(cmp, helper) {
        helper.showSpinner(cmp);
        helper.resetSectionErrors(cmp);
        var selectCmp = cmp.find("stageSelect");
        var stage = selectCmp.get("v.value");
        cmp.set("v.selectedStage", stage);
        helper.clearAllData(cmp);
        cmp.set("v.shouldRenderPage", true);
        helper.loadStageData(cmp, stage, helper);
    }
})