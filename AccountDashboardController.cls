public class AccountDashboardController {
    @AuraEnabled
    public static map<string, integer> accountDetails(Id recordId){
        integer count = 0;
        integer oppCount = 0;
        map<string, integer> data = new map<string, integer>();
        list<opportunity> opp = [select id from opportunity where AccountId =:recordId];
        list<task> tasks = [SELECT id, Subject from task where WhatId in :opp];
        oppCount = tasks.size();
        list<task> acc = [SELECT id, Subject from task where WhatId =:recordId];
         count = acc.size();
        integer total = count + oppCount;
        data.put('AccountActivity', count);
        data.put('OppActivity',oppCount);
        data.put('total',total);
        return data;
    }
    
    @AuraEnabled
    public static Map<String,List<Decimal>> oliDetails(String recordId){
        System.debug(RecordId);
        Decimal totalAmount = 0;
        Decimal totalQuantity = 0;
        List<Opportunity> opp = [select id from opportunity where AccountId = :recordId ];
        List<OpportunityLineItem> oliItems = [select id , Product2.Name , Quantity , TotalPrice from OpportunityLineItem where OpportunityId In:opp];
        Map<String,List<Decimal>> oliData = new Map<String,List<Decimal>>();
        for(OpportunityLineItem oli : oliItems){
            totalAmount = totalAmount + oli.TotalPrice;
            totalQuantity = totalQuantity + oli.Quantity;
            List<Decimal> QAlist = oliData.get(oli.Product2.Name);
            if(QAlist == null){
                QAlist = new List<Decimal>();
                QAlist.add(oli.TotalPrice);
                QAlist.add(oli.Quantity);
                oliData.put(oli.Product2.Name , QAlist);
            }else{
                QAlist[0] = QAlist[0]+oli.TotalPrice;
                QAlist[1] = QAlist[1]+oli.Quantity;
                    }
        }   
        List<Decimal> totalQA = new List<Decimal>();
        totalQA.add(totalAmount);
        totalQA.add(totalQuantity);
        oliData.put('TotalQA',totalQA);
        System.debug(oliData);
        return oliData;
    }

}