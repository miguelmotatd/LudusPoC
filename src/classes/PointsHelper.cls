public with sharing class PointsHelper {

    private final static Integer rankingSize = 10;

    public static Date getEarlierRecordDate() {
        Ludus_Point__c earlierPoint = [SELECT LastModifiedDate FROM Ludus_Point__c ORDER BY LastModifiedDate ASC
            NULLS FIRST LIMIT 1];
        return date.newinstance(earlierPoint.LastModifiedDate.year(), earlierPoint.LastModifiedDate.month(), earlierPoint.LastModifiedDate.day());
    }

    public static List<RankingWrapper> getTopRanking(Integer numberRows){

        List<AggregateResult> pontos = [
                SELECT sum(Points__c) points, User__c
                FROM Ludus_Point__c
                GROUP BY User__c
                ORDER BY sum(Points__c) DESC
                LIMIT :numberRows
            ];

        Map<Id,User> userIds = new Map<Id,User>([SELECT Id, Name FROM User]);

        List<RankingWrapper> ranking = new List<RankingWrapper>();

        for(AggregateResult res : pontos) {
            RankingWrapper wrp = new RankingWrapper();
            wrp.points = Integer.valueOf(res.get('points'));
            wrp.userId = Id.valueOf((String)res.get('User__c'));
            wrp.userName = userIds.get(Id.valueOf((String)res.get('User__c'))).Name;
            ranking.add(wrp);
        }

        return ranking;
    }

    public static List<RankingWrapper> getAllRanking(FilterWrapper filter){

        String query = 'SELECT sum(Points__c) points, User__c FROM Ludus_Point__c ';
        if(filter != null) {
            if(!String.isBlank(filter.year)) {
                query += ' WHERE CALENDAR_YEAR(CreatedDate) = ' + filter.year;
                if(!String.isBlank(filter.month)) {
                    query += ' AND CALENDAR_MONTH(CreatedDate) = ' + filter.month;
                }
            }
        }
        query += ' GROUP BY User__c ORDER BY sum(Points__c) DESC';

        List<AggregateResult> pontos = Database.query(query);

        Map<Id,User> userIds = new Map<Id,User>([SELECT Id, Name FROM User]);

        List<RankingWrapper> ranking = new List<RankingWrapper>();

        for(AggregateResult res : pontos) {
            RankingWrapper wrp = new RankingWrapper();
            wrp.points = Integer.valueOf(res.get('points'));
            wrp.userId = Id.valueOf((String)res.get('User__c'));
            wrp.userName = userIds.get(Id.valueOf((String)res.get('User__c'))).Name;
            ranking.add(wrp);
        }

        return ranking;
    }

    public static List<RankingWrapper> getRuleDistribution(FilterWrapper filter){

        Boolean queryFilter = false;
        String query = 'SELECT sum(Points__c) points, Rule__c FROM Ludus_Point__c ';
        if(filter != null) {
            if(!String.isBlank(filter.year)) {
                query += ' WHERE CALENDAR_YEAR(CreatedDate) = ' + filter.year;
                if(!String.isBlank(filter.month)) {
                    query += ' AND CALENDAR_MONTH(CreatedDate) = ' + filter.month;
                }
                queryFilter = true;
            }
            if(!String.isBlank(filter.userId)) {
                query += (queryFilter ? ' AND ' : ' WHERE ') + 'User__c = \'' + filter.userId + '\'';
            }
        }
        query += ' GROUP BY Rule__c ORDER BY sum(Points__c) DESC';
system.debug(query);
        List<AggregateResult> pontos = Database.query(query);

        Map<Id,Ludus_Rule__c> ruleIds = new Map<Id,Ludus_Rule__c>([SELECT Id, Name FROM Ludus_Rule__c]);

        List<RankingWrapper> ranking = new List<RankingWrapper>();

        for(AggregateResult res : pontos) {
            RankingWrapper wrp = new RankingWrapper();
            wrp.points = Integer.valueOf(res.get('points'));
            wrp.ruleId = Id.valueOf((String)res.get('Rule__c'));
            wrp.ruleName = ruleIds.get(Id.valueOf((String)res.get('Rule__c'))).Name;
            ranking.add(wrp);
        }

        return ranking;
    }

    public class RankingWrapper
    {
        @AuraEnabled public Id userId {get; set;}
        @AuraEnabled public String userName {get; set;}
        @AuraEnabled public Id ruleId {get; set;}
        @AuraEnabled public String ruleName {get; set;}
        @AuraEnabled public Integer points {get; set;}
    }
    public class FilterWrapper
    {
        @AuraEnabled public String year {get; set;}
        @AuraEnabled public String month {get; set;}
        @AuraEnabled public String userId {get; set;}
        @AuraEnabled public Id ruleId {get; set;}
    }
}