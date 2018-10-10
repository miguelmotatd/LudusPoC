({
    init: function (component, event, helper) {
        helper.loadMonthYear(component, event, helper);
        component.set('v.filters',{month:null,year:null});
    },

    initPushTopic: function(component, event, helper) {
        helper.handleInitPushTopic(component, event, helper);
    },
    dateChanged: function(component, event, helper) {
        helper.handleDateChanged(component, event, helper);
    },
    filtersChange: function(component, event, helper) {
        var filters = event.getParam("data");
        var context = event.getParam("context");
        if(context != component.getName()) {
            debugger;
            component.set('v.filters', filters);
        }
    },
    onRemoveUserFilter: function(component, event, helper) {
        helper.handleRemoveUserFilter(component, event, helper);
    }
})