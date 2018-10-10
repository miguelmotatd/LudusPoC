/**
 * Created by miguel.mota on 9/19/18.
 */

public with sharing class GamificationEngine {

    private static List<Ludus_Point__c> points = new List<Ludus_Point__c>();

    public static void handleCRUD(String objectName, Map<Id, sObject> newObjects, Map<Id, sObject> oldObjects){
        system.debug('ja foste');
        List<Ludus_Rule__c> rules = [SELECT Compare_Date_Field__c,Compare_Date_Value__c,Compare_Field_Value__c,
                                            Compare_Numeric_Field__c,Compare_Numeric_Value__c,Field__c,Id,
                                            Object__c,Operator__c,Points__c,Type_of_Rule__c,User_Awarded__c
                                        FROM Ludus_Rule__c
                                        WHERE Object__c = :objectName];

        for(Ludus_Rule__c rule : rules) {
            for(String key : newObjects.keySet()){
                checkRuleOnObject(rule, newObjects.get(key), oldObjects.get(key));
            }
        }

        if(!points.isEmpty()) Database.upsert(points, Ludus_Point__c.Compound_Key__c);
    }


    private static void checkRuleOnObject(Ludus_Rule__c rule, sObject newSObject, sObject oldSObject) {
        if(rule.Type_of_Rule__c == 'Picklist') {
            String field = rule.Field__c;
            String target = rule.Compare_Field_Value__c;
            String userAwarded = rule.User_Awarded__c;

            String oldValue = String.valueOf(oldSObject.get(field));
            String newValue = String.valueOf(newSObject.get(field));
            String objectId = String.valueOf(newSObject.get('Id'));
            String userId = String.valueOf(newSObject.get(userAwarded));

            if(oldValue != newValue && newValue == target) {
                awardPoints(rule, objectId, userId);
            }

        } else if(rule.Type_of_Rule__c == 'Numeric') {

        } else if(rule.Type_of_Rule__c == 'Date') {

        }
    }

    private static void awardPoints(Ludus_Rule__c rule, String originId, String userId){
        Ludus_Point__c point = new Ludus_Point__c();
        point.Origin__c = originId;
        point.Origin_Type__c = rule.Object__c;
        point.Rule__c = rule.Id;
        point.User__c = userId;
        point.Points__c = rule.Points__c;
        point.Compound_Key__c = rule.Id + '|' + originId;
        points.add(point);
    }

}