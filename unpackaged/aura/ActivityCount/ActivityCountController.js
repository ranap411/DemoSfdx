({
	doinit : function(component, event, helper) {
		var action = component.get('c.accountDetails');
         action.setParams({
            "recordId": component.get("v.recordId")
        });
        console.log('Id',component.get("v.recordId"));
        action.setCallback(this,function(response){
            if(response.getReturnValue()!=null){
            component.set('v.users',response.getReturnValue());
            console.log('hello',response.getReturnValue());
            }
      });
     $A.enqueueAction(action);
    }
})