({
    colorPalette : [
        'rgba(244, 135, 102, 1)',
        'rgba(255, 201, 76, 1)',
        'rgba(71, 187, 237, 1)',
        'rgba(142, 183, 55, 1)',
        'rgba(35, 55, 84, 1)'],

    loadRanking: function (component, event, helper, isUpdate) {
        const action = component.get('c.updateRuleDistribution');
        action.setParams({filters: JSON.stringify(component.get('v.filters'))})
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let labels = [];
                let data = [];
                let colors = [];
                for(let i = 0; i < allValues.length ; ++i) {
                    let val = allValues[i];
                    labels.push(val.ruleName);
                    data.push(val.points);
                    if(i > helper.colorPalette.length - 1) {
                        colors.push(helper.colorPalette[i % helper.colorPalette.length]);
                    }else{
                        colors.push(helper.colorPalette[i]);
                    }
                }
                component.set('v.labels', labels);
                component.set('v.colors', colors);
                component.set('v.data', data);
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

        var labels = component.get('v.labels');

        let i = 0;
        var datasets = [{label: 'Points',
                         data: component.get('v.data'),
                         fill: false,borderWidth: 1.5,
                         backgroundColor: component.get('v.colors'),
                         pointBackgroundColor: "#FFFFFF",pointBorderWidth: 4,pointHoverRadius: 8,pointRadius: 6,pointHitRadius: 10}];


        var ctx = component.find("chart").getElement();
        component.chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio :false,
                onClick: function(event) {
                    var elements = component.chart.getElementAtEvent(event);
                    console.log("elements");
                    console.log(elements);
                    if (elements.length === 1) {
                        /*var year = labels[elements[0]._index];
                        var country = datasets[elements[0]._datasetIndex].label;
                        var chartEvent = $A.get("e.c:LudusChartEvent");
                        chartEvent.setParams({
                            data: {year: year, country: country}
                        });
                        chartEvent.fire();*/
                    }
                }
            }
        });
    },

    updateTable: function(component, event, helper) {
        debugger;
        component.chart.data.datasets[0].data = component.get('v.data');
        component.chart.data.labels = component.get('v.labels');
        component.chart.update();
    },
})