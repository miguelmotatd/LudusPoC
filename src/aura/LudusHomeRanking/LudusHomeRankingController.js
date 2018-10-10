({
    init: function (component, event, helper) {

    },
	scriptsLoaded : function(component, event, helper) {
	    helper.loadRanking(component, event, helper, false);
        component.set('v.chartsJsLoaded', true);
	},
    initPushTopic : function(component, event, helper) {
        helper.handleInitPushTopic(component, event);
        component.set('v.streamingApiLoaded', true);
    },
    dataChange : function(component, event, helper) {
        if(!component.get('v.dataLoaded')){
            helper.loadRanking(component, event, helper, true);
        }
    }
})