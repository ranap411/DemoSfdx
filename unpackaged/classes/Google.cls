public with sharing class Google {
	@AuraEnabled
    public static List<Visit__c> getVisits(){
        System.debug(1);
        return [select id,Visit_Latitude__c,Visit_Longitude__c from Visit__c];
    }
   
    @AuraEnabled
    public static List<User> getUsersList(){
        System.debug(2);
  return [select id , Name from User where userRole.name = 'CEO'];
     }
    
    
    @AuraEnabled
    public static String beat(String userid){
     system.debug(userid);
      List<visitsData> visitsList = new List<visitsData>();
 String id = userid;
 Beat_Plan__c bt=[select id, Start_Latitude__c, Start_Longitude__c from Beat_Plan__c where user__r.id =:id AND Date__c=:Date.today()];
     visitsData beat = new visitsData();
     beat.latitude = bt.Start_Latitude__c;
     beat.longitude = bt.Start_Longitude__c;
      visitsList.add(beat);
     string btid=bt.id;
 list<Visit__c> vt_list = [select id , visit_Latitude__c , Visit_Longitude__c , Sequence_Number__C , CheckIn__c, CheckOut__c,Lead__r.Name from Visit__c where Beat_Plan__r.id =:btid order by Sequence_Number__C ];
     system.debug(vt_list);
     if(vt_list.size()!=null){
     for(Visit__c vt : vt_list)
     {
        visitsData visit = new visitsData ();
         visit.Id = vt.Id;
         visit.latitude = vt.Visit_Latitude__c;
         visit.longitude = vt.Visit_Longitude__c;
         visit.checkIn = vt.CheckIn__c;
         visit.checkOut = vt.CheckOut__c;
         visit.LeadName = vt.Lead__r.Name;
         visitsList.add(visit);
     }
     }
     system.debug(visitsList);
      String visits = JSON.serialize(visitsList);
     return (visits);
    

 }
    public class visitsData{
        public string Id{get;set;}
        public double latitude{get;set;}
        public double longitude{get;set;}
        public boolean checkIn{get;set;}
        public boolean checkOut{get;set;}
        public String  LeadName{get;set;}
    }
}