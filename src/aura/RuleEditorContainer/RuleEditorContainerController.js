({
    newRuleClicked: function (component, event, helper) {
         debugger;
         component.set("v.showNewRuleModal", true);
    },

    handleCreateBoxEvent : function(component, event) {
        debugger;
        const status = event.getParam("status");
        const errorMessage = event.getParam("errorMessage");

        if(status === 'success' || status === 'cancel') {
            component.set("v.showNewRuleModal", false);
        }
    }

})