public class beatGoogle{
public string user{get;set;}
public List < Double > latlist {get; set;}
public List < Double > longlist {get; set;}
public beatGoogle(){
  
  list<User> rm_list =[select id , Name from User where UserRole.Name='CEO'];
    system.debug(rm_list);
   user = JSON.serialize(rm_list);
   system.debug(latlist);

}
@RemoteAction
 public static list<Double> beat(String json_data){
 Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
 system.debug(temp);
 double latlist ;
 decimal longlist ;
 list<double> way = new list<double>();
 list<double> wapts = new list<double>();
 list<double> allrecord = new list<double>();
 
 String id = String.valueof(temp.get('Id'));
 Beat_Plan__c bt=[select id, Start_Latitude__c, Start_Longitude__c from Beat_Plan__c where user__r.id =:id AND Date__c=:Date.today()];
    latlist = bt.Start_Latitude__c;
    longlist=bt.Start_Longitude__c;
wapts.add(latlist);
wapts.add(longlist);
     string btid=bt.id;
 list<Visit__c> vt_list = [select id , visit_Latitude__c , Visit_Longitude__c , Sequence_Number__C from Visit__c where Beat_Plan__r.id =:btid];
     system.debug(vt_list);
     if(vt_list.size()!=null){
     for(Visit__c vt : vt_list)
     {
        wapts.add(vt.Visit_Latitude__c ) ;
        wapts.add(vt.Visit_Longitude__c);
     }
     }
     system.debug(wapts);
  return (wapts);

 }

}