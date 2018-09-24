public with sharing class LineDashBoard {
    @auraenabled
    public static List<aggregateResult> getAllItems(Id recordId){
        List<aggregateResult> lis = [select count(Id) num  , calendar_month(Date__c)  month , calendar_year(Date__c)  year from item__c where Account__c = :recordId group by calendar_month(Date__c) , calendar_year(Date__c)];
        return lis;
    }
}