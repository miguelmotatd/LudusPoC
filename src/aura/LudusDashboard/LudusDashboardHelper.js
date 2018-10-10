({
    months : [{label:'Any',value:"", selected: true},
                {label:'January',value:"1"},
                {label:'February',value:"2"},
                {label:'March',value:"3"},
                {label:'April',value:"4"},
                {label:'May',value:"5"},
                {label:'June',value:"6"},
                {label:'July',value:"7"},
                {label:'August',value:"8"},
                {label:'September',value:"9"},
                {label:'October',value:"10"},
                {label:'November',value:"11"},
                {label:'December',value:"12"}],

    loadMonthYear: function (component, event, helper, isUpdate) {
        const action = component.get('c.retrieveEarlierRecordDate');
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const earlierDate = response.getReturnValue();
                let firstYear = earlierDate.substring(0,4);
                let currentYear = new Date().getFullYear();
                let years = [];
                years.push({ label: "Any", value: "", selected: true });
                for(let i = firstYear; i <= currentYear; ++i) {
                   years.push({label:i, value:i});
                }
                component.set('v.years', years);
                component.set('v.months', helper.months);

            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    handleInitPushTopic: function (component, event, helper) {
        const action = component.get("c.retrieveSesstionId");

        action.setCallback(this, function(response){
            const state = response.getState();

            if(state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.sessionId", response.getReturnValue());
                // Connect to the CometD endpoint
                $.cometd.init({
                   url: '/cometd/38.0',
                   requestHeaders: { Authorization: component.get("v.sessionId")}
                });

                // Subscribe to a topic. JSON-encoded update will be returned
                // in the callback
                $.cometd.subscribe('/topic/PointUpdates', function(message) {
                    console.log(message);
                    let chartEvent = $A.get("e.c:LudusChartEvent");
                    chartEvent.setParams({
                        filters: component.get('v.filters'),
                        context: 'StreamingAPI'
                    });
                    chartEvent.fire();
                });
            }


        });
        $A.enqueueAction(action);
    },

    handleDateChanged: function (component, event, helper) {
        debugger;
        let filters = component.get('v.filters');
        filters.month = component.get('v.monthSelected');
        filters.year = component.get('v.yearSelected');
        component.set('v.filters', filters);

        let chartEvent = $A.get("e.c:LudusChartEvent");
        chartEvent.setParams({
            data: filters,
            context: component.getName()
        });
        chartEvent.fire();
    },

    handleRemoveUserFilter: function(component, event, helper) {
        debugger;
        let filters = component.get('v.filters');
        filters.userName = null;
        filters.userId = null;
        component.set('v.filters', filters);

        let chartEvent = $A.get("e.c:LudusChartEvent");
        chartEvent.setParams({
            data: filters,
            context: component.getName()
        });
        chartEvent.fire();
    }

})