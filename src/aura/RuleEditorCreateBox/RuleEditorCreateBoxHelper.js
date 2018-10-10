({
    handleInitActions: function (component, event, helper) {
        helper.loadObjectOptions(component, event, helper);
        helper.loadTypeOfRuleOptions(component, event, helper);
        helper.loadOperatorOptions(component, event, helper);
    },

    loadObjectOptions: function (component, event, helper) {
        const action = component.get('c.fetchAvailableObjects');
        //action.setParams({ firstName : cmp.get("v.firstName") });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let opts = [];
                opts.push({ label: "--- None ---", value: "", selected: true });
                for(let key in allValues){
                    opts.push({label:allValues[key], value:key});
                }
                component.set("v.objectOptions", opts);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    loadTypeOfRuleOptions: function (component, event, helper) {
            const action = component.get('c.fetchTypeOfRuleValues');
            //action.setParams({ firstName : cmp.get("v.firstName") });
            action.setCallback(this, function(response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const allValues = response.getReturnValue();
                    let opts = [];
                    for(let i = 0; i < allValues.length; ++i){
                        opts.push({label:allValues[i], value:allValues[i]});
                        if(i == 0) component.set("v.typeOfRuleSelectedValue", allValues[i]);
                    }
                    component.set("v.typeOfRuleOptions", opts);
                }
                else if (state === "ERROR") {
                    const errors = response.getError();
                    errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
                }
            });
            $A.enqueueAction(action);
        },

    loadOperatorOptions: function (component, event, helper) {
        const action = component.get('c.fetchOperatorValues');
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let opts = [];
                for(let i = 0; i < allValues.length; ++i){
                    opts.push({label:allValues[i], value:allValues[i]});
                    if(i == 0) component.set("v.operatorSelectedValue", allValues[i]);
                }
                component.set("v.operatorOptions", opts);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    loadObjectPicklists: function (component, event, helper) {
        const action = component.get('c.fetchObjectPicklists');
        action.setParams({ objectName : component.get("v.objectSelectedValue") });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let opts = [];
                opts.push({ label: "--- None ---", value: "", selected: true });
                for(let key in allValues){
                    opts.push({label:allValues[key], value:key});
                }
                component.set("v.picklistOptions", opts);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    loadObjectUserFields: function (component, event, helper) {
        const action = component.get('c.fetchObjectUserFields');
        action.setParams({ objectName : component.get("v.objectSelectedValue") });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const allValues = response.getReturnValue();
                let opts = [];
                opts.push({ label: "--- None ---", value: "", selected: true });
                for(let key in allValues){
                    opts.push({label:allValues[key], value:key});
                }
                component.set("v.userOptions", opts);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    handlePicklistOptionsChanged: function (component, event, helper) {
            const action = component.get('c.fetchPicklistValues');
            action.setParams({ objectName : component.get("v.objectSelectedValue"),
                               fieldName : component.get("v.picklistSelectedValue") });
            action.setCallback(this, function(response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const allValues = response.getReturnValue();
                    let opts = [];
                    opts.push({ label: "--- None ---", value: "", selected: true });
                    for(let key in allValues){
                        opts.push({label:allValues[key], value:key});
                    }
                    component.set("v.fieldCompareOptions", opts);
                }
                else if (state === "ERROR") {
                    const errors = response.getError();
                    errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
                }
            });
            $A.enqueueAction(action);
        },

    handleSaveRule: function (component, event, helper) {
        let field = component.get("v.picklistSelectedValue");
        let ruleObj = {
            Name: component.get("v.ruleName"),
            Compare_Date_Field__c: null,
            Compare_Date_Value__c: null,
            Compare_Field_Value__c: component.get("v.fieldCompareSelectedValue"),
            Compare_Numeric_Field__c: null,
            Compare_Numeric_Value__c: null,
            Field__c: field,
            Object__c: component.get("v.objectSelectedValue"),
            Operator__c: null,
            Points__c: component.get("v.points"),
            Type_of_Rule__c: component.get("v.typeOfRuleSelectedValue"),
            User_Awarded__c: component.get("v.userSelectedValue")
        }

        const action = component.get('c.saveSingleRule');
        action.setParams({ rule : ruleObj });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                //alert('fuck yes');
                helper.fireCreateBoxEvent(component, 'success', null);
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                errors && errors[0] && errors[0].message && console.log("Error message: " + errors[0].message);
                helper.fireCreateBoxEvent(component, 'error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    fireCreateBoxEvent : function(component, status, errorMessage) {
        var cmpEvent = $A.get("e.c:RuleEditorCreateBoxEvent");
        debugger;
        cmpEvent.setParams({
            "status" : status,
            "errorMessage" : errorMessage });
        cmpEvent.fire();
    }



})