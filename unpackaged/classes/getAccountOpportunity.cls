public class getAccountOpportunity {
    @auraEnabled 
    public static Map<Integer,Map<Integer,Integer>> getPresentOpp(String id ){
     Map<Integer,Map<Integer,Integer>> oppNumbers = new Map<Integer,Map<Integer,Integer>>();
        if(id!=null){
    for(aggregateResult  ar :[Select Count(ID) num,CALENDAR_MONTH(CloseDate) month,CALENDAR_YEAR(CloseDate) year From Opportunity Where AccountId =:id Group By CALENDAR_MONTH(CloseDate),CALENDAR_YEAR(CloseDate) Order BY CALENDAR_MONTH(CloseDate) ])
    {
        if(oppNumbers.get((integer) ar.get('year'))==null){
            oppNumbers.put((integer) ar.get('year'),new Map<Integer,Integer>{(integer) ar.get('month') => (integer) ar.get('num') });
            
        }else{
            oppNumbers.get((integer) ar.get('year')).put((integer) ar.get('month'),(integer) ar.get('num'));
        }
    }   
      return oppNumbers;
        }else{
            return null;
        }
          
    }
    
    @AuraEnabled    
    public static String getProductCount(String id ){
        List<Opportunity> opList = [select Id , Name  from Opportunity where  AccountId =: id and CALENDAR_YEAR(CloseDate) in (2018,2017)];
        AggregateResult[] agr = [select count(Id) num , CALENDAR_YEAR(ServiceDate) year , CALENDAR_MONTH(ServiceDate) month from OpportunityLineItem where OpportunityId in : opList group by CALENDAR_YEAR(ServiceDate) , CALENDAR_MONTH(ServiceDate)];
        return(JSON.serialize(agr));
    } 
    
    @AuraEnabled
    public static String getEventCount(String id){
        Map<Id,List<Id>> hr = new Map<Id,List<Id>>();
        List<Contact> contactList = [select Id,Name,Title,Parent_Contact__c from Contact where AccountId =: id];
        AggregateResult[] agr = [select  Count(Id),Feedback__c from event where WhoId In:contactList group by Feedback__c];
        for(Contact c : contactList){
            if(hr.get(c.Id) == null){
                hr.put(c.Id,new List<Id>{});
                if(c.Parent_Contact__c !=null){
                    if(hr.get(c.Parent_Contact__c)!=null){
                        hr.get(c.Parent_Contact__c).add(c.Id);
                    }else{
                        hr.put(c.Parent_Contact__c,new List<Id>{c.Id});
                    }
                }
            }else{
                if(c.Parent_Contact__c!=null){
                    if(hr.get(c.Parent_Contact__c)!=null){
                        hr.get(c.Parent_Contact__c).add(c.Id);
                    }else{
                        hr.put(c.Parent_Contact__c,new List<Id>{c.Id});
                    }
                }
            }
        }
       
        System.debug(json.serialize(hr));
       return json.serialize(hr);
    }
    
    
    public class contacts {
        public string Name;
        public string title;
        public Integer totalmeetings;
        public Integer positive;
        public Integer negative;
        public List<Id> contactids;
       
        public contacts(String Name,String title,Integer totalmeetings,Integer positive,Integer negative,List<Id> contactids){
            this.Name = Name;
            this.title = title;
            this.totalmeetings = totalmeetings;
            this.positive = positive;
            this.negative = negative;
            this.contactids = contactids;
        }
    }
    
}