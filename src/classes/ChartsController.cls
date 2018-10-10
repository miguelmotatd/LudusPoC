public with sharing class ChartsController {

    @AuraEnabled
    public static List<PointsHelper.RankingWrapper> updateTopRanking(String numberRows) {
        return PointsHelper.getTopRanking(Integer.valueOf(numberRows));
    }

    @AuraEnabled
    public static List<PointsHelper.RankingWrapper> updateGlobalRanking(String filters) {
        PointsHelper.FilterWrapper filtersObj;
        if(filters != null) {
            filtersObj = (PointsHelper.FilterWrapper) JSON.deserialize(filters, PointsHelper.FilterWrapper.class);
        }
        return PointsHelper.getAllRanking(filtersObj);
    }

    @AuraEnabled
    public static String retrieveSesstionId() {
        return UserInfo.getSessionId();
    }

    @AuraEnabled
    public static Date retrieveEarlierRecordDate() {
        return PointsHelper.getEarlierRecordDate();
    }

    @AuraEnabled
    public static List<PointsHelper.RankingWrapper> updateRuleDistribution(String filters) {
        PointsHelper.FilterWrapper filtersObj;
        if(filters != null) {
            filtersObj = (PointsHelper.FilterWrapper) JSON.deserialize(filters, PointsHelper.FilterWrapper.class);
        }
        return PointsHelper.getRuleDistribution(filtersObj);
    }

}