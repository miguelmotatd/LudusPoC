public with sharing class PushTopicManager {
    public static void createUpdateCasePushTopic(){
        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = 'CaseUpdates';
        pushTopic.Query = 'SELECT Id, CaseNumber, Subject, Status FROM Case';
        pushTopic.ApiVersion = 38.0;
        pushTopic.NotifyForOperationCreate = true;
        pushTopic.NotifyForOperationUpdate = true;
        pushTopic.NotifyForOperationUndelete = true;
        pushTopic.NotifyForOperationDelete = true;
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
    }

    public static void pointsPushTopic(){
        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = 'PointUpdates';
        pushTopic.Query = 'SELECT Id,Name,Origin_Type__c,Origin__c,Points__c,Rule__c,User__c FROM Ludus_Point__c';
        pushTopic.ApiVersion = 38.0;
        pushTopic.NotifyForOperationCreate = true;
        pushTopic.NotifyForOperationUpdate = true;
        pushTopic.NotifyForOperationUndelete = true;
        pushTopic.NotifyForOperationDelete = true;
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
    }
}