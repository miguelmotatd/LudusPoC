public with sharing class TriggersHelper {

    private static String endPoint = 'callout:CallMeBack/services/data/v41.0/sobjects';
    public static String triggerBody = 'trigger %TRIGGERNAME% on %OBJNAME% (after insert, after update) {' + '\n'
        + '\t' + 'GamificationEngine.handleCRUD(\'%OBJNAME%\', Trigger.newMap, Trigger.oldMap);' + '\n' + '}';

    public static Boolean checkTriggerExists(String objName) {
        String triggerName = objName + '_LudusTrigger';
        List<ApexTrigger> triggers = [SELECT Id FROM ApexTrigger WHERE Name = :triggerName];
        return !triggers.isEmpty();
    }

    public static String createApexTrigger(String objName) {
        HttpRequest req = MetadataAPIService.createHttpRequest(endPoint+'/ApexTrigger','POST');
        req.setBody(generateCreateTriggerRequest(objName));
        String response = MetadataAPIService.fetchResponse(req);
        system.debug(response);
        return response;
    }

    private static String generateCreateTriggerRequest(String objName){

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('Name', objName + '_LudusTrigger');
        gen.writeStringField('TableEnumOrId', objName);
        gen.writeStringField('Body', triggerBody.replace('%OBJNAME%', objName).replace('%TRIGGERNAME%',objName + '_LudusTrigger'));
        gen.writeEndObject();

        return gen.getAsString();
    }
}