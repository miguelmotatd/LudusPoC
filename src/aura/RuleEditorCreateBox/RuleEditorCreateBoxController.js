({
    init: function (component, event, helper) {
        helper.handleInitActions(component, event, helper);
    },

    onChangeObjectOptions: function (component, event, helper) {
        if(component.get("v.objectSelectedValue") != "") {
            helper.loadObjectPicklists(component, event, helper);
            helper.loadObjectUserFields(component, event, helper);
        } else {
            //TODO clear other fields
        }
    },

    onChangePicklistOptions: function (component, event, helper) {
        if(component.get("v.fieldSelectedValue") != "") {
            helper.handlePicklistOptionsChanged(component, event, helper);
        } else {
            //TODO clear other fields
        }
    },

    onClickSave: function (component, event, helper) {
        helper.handleSaveRule(component, event, helper);
    },

    onClickCancel: function (component, event, helper) {
        helper.fireCreateBoxEvent(component, 'cancel', null);
    }
})