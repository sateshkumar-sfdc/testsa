({
    doInit : function(component, event) {
        var contactList = component.get("c.getContacts");
        contactList.setCallback(this,function(contactListResponce){
            component.set("v.listContact", contactListResponce.getReturnValue());
            console.log(contactListResponce.getReturnValue());
        });
        $A.enqueueAction(contactList);
    }
})