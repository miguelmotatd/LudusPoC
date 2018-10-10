public without sharing class RuleEditorHelper {

    private static String endPoint = 'callout:CallMeBack/services/data/v41.0/sobjects';


    public static Map<String, String> getTriggableObjects() {

        Map<String, String> mapObjectMapping = new Map<String, String>();
        HttpRequest req = MetadataAPIService.createHttpRequest(endPoint, 'GET');
        String response = MetadataAPIService.fetchResponse(req);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> objs = (List<Object>) body.get('sobjects');
        for (Object obj : objs) {
            Map<String, Object> objDesc = (Map<String, Object>)(obj);
            String name = (String) objDesc.get('name');
            Boolean isTriggerable = (Boolean) objDesc.get('triggerable');
            if(isTriggerable) {
                mapObjectMapping.put(name, (String) objDesc.get('label'));
            }
        }
        return mapObjectMapping;
    }

    private static Map<String, String> getObjectFieldsByType(String objectName, Schema.DisplayType fieldType) {

        Map<String, String> mapPickListFields = new Map<String, String>();
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{objectName});
        Map<String, Schema.SObjectField> fields = descResult[0].fields.getMap();
        for (Schema.SObjectField field: fields.values()) {
            if(field.getDescribe().type == fieldType) {
                mapPickListFields.put(field.getDescribe().getName(), field.getDescribe().getLabel());
            }
        }
        return mapPickListFields;
    }

    public static Map<String, String> getObjectPicklistFields(String objectName) {
        return getObjectFieldsByType(objectName, Schema.DisplayType.PICKLIST);
    }

    public static Map<String, String> getObjectUserFields(String objectName) {

        Map<String, String> mapUserFields = new Map<String, String>();
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new List<String>{objectName});
        Map<String, Schema.SObjectField> fields = descResult[0].fields.getMap();
        for (Schema.SObjectField field: fields.values()) {
            if(field.getDescribe().type == Schema.DisplayType.REFERENCE && field.getDescribe().getReferenceTo().contains(User.sObjectType)) {
                mapUserFields.put(field.getDescribe().getName(), field.getDescribe().getLabel());
            }
        }
        return mapUserFields;
    }

    public static Map<String, String> getPickListValues(String objectName, String picklistName) {
        Map<String, String> pickListValues = new Map<String, String>();
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{objectName});
        Map<String, Schema.SObjectField> fields = descResult[0].fields.getMap();
        for (Schema.SObjectField field: fields.values()) {
            if(field.getDescribe().getName() == picklistName) {
                List<Schema.PicklistEntry> ple = field.getDescribe().getPicklistValues();
                for( Schema.PicklistEntry pickListVal : ple){
                    pickListValues.put(pickListVal.getValue(), pickListVal.getLabel());
                }
                break;
            }
        }
        return pickListValues;
    }

    public static void createRule(Ludus_Rule__c rule) {
        createApexTrigger(rule.Object__c);
        Database.insert(rule);
    }

    public static void createApexTrigger(String objName)
    {
        if(!TriggersHelper.checkTriggerExists(objName)) {
            TriggersHelper.createApexTrigger(objName);
        }
    }

    public static List<Ludus_Rule__c> getAllRules() {
        return [SELECT Compare_Date_Field__c,Compare_Date_Value__c,Compare_Field_Value__c,Compare_Numeric_Field__c,
                    Compare_Numeric_Value__c,CreatedById,CreatedDate,Field__c,Id,Name,Object__c, Operator__c,
                    Points__c, Type_of_Rule__c,User_Awarded__c
                FROM Ludus_Rule__c];
    }

    public static List<RuleEditorListItem> translateRulesToUI(List<Ludus_Rule__c> rules) {
        List<RuleEditorListItem> uiRules = new List<RuleEditorListItem>();
        for(Ludus_Rule__c rule : rules) {
            RuleEditorListItem uiRule = new RuleEditorListItem();

            uiRule.ruleId = rule.Id;
            uiRule.ruleName = rule.Name;
            uiRule.objectName = rule.Object__c;
            if(rule.Type_of_Rule__c == 'Picklist') {
                uiRule.fieldName = rule.Field__c;
                uiRule.operator = 'Equals';
                uiRule.target = rule.Compare_Field_Value__c;
            } else if(rule.Type_of_Rule__c == 'Numeric') {
                uiRule.fieldName = rule.Compare_Numeric_Field__c;
                uiRule.operator = rule.Operator__c;
                uiRule.target = String.valueOf(rule.Compare_Numeric_Value__c);
            } else if(rule.Type_of_Rule__c == 'Date') {
                uiRule.fieldName = rule.Compare_Date_Field__c;
                uiRule.operator = rule.Operator__c;
                uiRule.target = String.valueOf(rule.Compare_Date_Value__c);
            }
            uiRule.awardedUser = rule.User_Awarded__c;
            uiRule.points = Integer.valueOf(rule.Points__c);

            uiRules.add(uiRule);
        }
        return uiRules;
    }

    public class RuleEditorListItem
    {
        @AuraEnabled public Id ruleId {get; set;}
        @AuraEnabled public String ruleName {get; set;}
        @AuraEnabled public String objectName {get; set;}
        @AuraEnabled public String fieldName {get; set;}
        @AuraEnabled public String operator {get; set;}
        @AuraEnabled public String target {get; set;}
        @AuraEnabled public String awardedUser {get; set;}
        @AuraEnabled public Integer points {get; set;}
    }
}