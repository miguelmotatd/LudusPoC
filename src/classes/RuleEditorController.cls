public class RuleEditorController extends BaseController {
    @AuraEnabled
    public static Map<String,String> fetchAvailableObjects() {
        return RuleEditorHelper.getTriggableObjects();
    }

    @AuraEnabled
    public static Map<String,String> fetchObjectPicklists(String objectName) {
        return RuleEditorHelper.getObjectPicklistFields(objectName);
    }

    @AuraEnabled
    public static Map<String,String> fetchObjectUserFields(String objectName) {
        return RuleEditorHelper.getObjectUserFields(objectName);
    }

    @AuraEnabled
    public static Map<String,String> fetchPicklistValues(String objectName, String fieldName) {
        return RuleEditorHelper.getPickListValues(objectName, fieldName);
    }

    @AuraEnabled
    public static List<String> fetchTypeOfRuleValues() {
        Map<String, String> mapValues = RuleEditorHelper.getPickListValues('Ludus_Rule__c', 'Type_of_Rule__c');
        return mapValues.values();
    }

    @AuraEnabled
    public static List<String> fetchOperatorValues() {
        Map<String, String> mapValues = RuleEditorHelper.getPickListValues('Ludus_Rule__c', 'Operator__c');
        return mapValues.values();
    }

    @AuraEnabled
    public static void saveSingleRule(Ludus_Rule__c rule) {
        RuleEditorHelper.createRule(rule);
    }

    @AuraEnabled
    public static List<RuleEditorHelper.RuleEditorListItem> fetchAllRules() {
        return RuleEditorHelper.translateRulesToUI(RuleEditorHelper.getAllRules());
    }

}