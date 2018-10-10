({
    init: function (component, event, helper) {
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Delete', name: 'delete' }
        ];

        component.set('v.columns', [
            { label: 'Name',        fieldName: 'ruleName',      type: 'text' },
            { label: 'Object',      fieldName: 'objectName',    type: 'text' },
            { label: 'Field',       fieldName: 'fieldName',     type: 'text' },
            { label: 'Operator',    fieldName: 'operator',      type: 'text' },
            { label: 'Compare',     fieldName: 'target',        type: 'text' },
            { label: 'Award User',  fieldName: 'awardedUser',   type: 'text' },
            { label: 'Points',      fieldName: 'points',        type: 'number'},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        helper.fetchData(component);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'show_details':
                alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':

                break;
        }
    },

    handleCreateBoxEvent : function(component, event, helper) {
        const status = event.getParam("status");

        if(status === 'success') {
            helper.fetchData(component);
        }
    }
})