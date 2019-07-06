({
	handleChange : function(component, event, helper) {
        alert('enter');
        let test1 = component.find("mygroup").get("v.value")
        alert('test1 Value : '+test1);
		
	}
})