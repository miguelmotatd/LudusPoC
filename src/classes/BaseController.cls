public with sharing virtual class BaseController {
    @AuraEnabled
    public static String retrieveSesstionId() {
        return UserInfo.getSessionId();
    }
}