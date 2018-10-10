({
    init: function (component, event, helper) {
        component.set('v.filters', {});
    },
    scriptsLoaded : function(component, event, helper) {
        helper.loadRanking(component, event, helper, false);
    },
    filtersChange: function(component, event, helper) {
        var filters = event.getParam("data");
        var context = event.getParam("context");
        if(context != component.getName()) {
            component.set('v.filters', filters);
            helper.loadRanking(component, event, helper, true);
        }
    },
})