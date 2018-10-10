({
    fetchData: function (component) {
        const action = component.get('c.fetchAllRules');
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                debugger;
                component.set("v.data", allValues);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);

    }
})