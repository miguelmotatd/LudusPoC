({
    loadRanking: function (component, event, helper, isUpdate) {
        const action = component.get('c.updateTopRanking');
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let labels = [];
                let data = [];
                for(let i = 0; i < allValues.length ; ++i) {
                    let val = allValues[i];
                    labels.push(val.userName);
                    data.push(val.points);
                }
                component.set('v.labels', labels);
                component.set('v.data', data);
                component.set('v.dataLoaded', true);
                if(isUpdate) {
                    helper.updateTable(component, event, helper);
                } else {
                    helper.initTable(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    initTable: function (component, event, helper) {
        if(!component.get('v.chartsJsLoaded')) {
            return;
        }
        var colors = [
            'rgba(23, 48, 91, 1)',
            'rgba(62, 159, 222, 1)',
            'rgba(48, 165, 154, 1)',
            'rgba(132, 220, 214, 1)',
            'rgba(222, 159, 0, 1)',
            'rgba(223, 205, 114, 1)'
        ];

        var labels = component.get('v.labels');//['Miguel','Jaquim','Manel','Zé'];

        let i = 0;
        var datasets = [{label: 'Pontos',
                         data: component.get('v.data'),//[42,37,25,11],
                         fill: false,borderWidth: 1.5,backgroundColor: colors[i++],borderColor: colors[i],pointBackgroundColor: "#FFFFFF",pointBorderWidth: 4,pointHoverRadius: 8,pointRadius: 6,pointHitRadius: 10}];


        var ctx = component.find("chart").getElement();
        component.chart = new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: labels,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio :false,
                tooltips: {enabled: false},
                hover: {mode: null},
            }
        });
    },

    updateTable: function(component, event, helper) {
        debugger;
        component.chart.data.datasets[0].data = component.get('v.data');
        component.chart.data.labels = component.get('v.labels');
        component.chart.update();
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
                    component.set('v.dataLoaded', false);
                });
            }


        });
        $A.enqueueAction(action);
    }
})