/**
 * Created by miguel.mota on 9/25/18.
 */

@IsTest
private class TriggerTest {
    static testMethod void test() {
        String ObjectName = 'Case';
        sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject();
        insert sObj;
    }
}