public class GoogleMap {
    public String add {get; set;}
    public List < Double > latlist {get; set;}
    public List < Double > longlist {get; set;}
    public String vt {get;set;}
    public string bt {get;set;}
    public string km {get;set;}
    public class TimeParse{
    public String visit_time;
    public String visit_id;
    public String new_date;
    public String reason ;
    public string cash;
    public String docs;
    public string visit_cancel;
    }
    public GoogleMap() {
        getLocation();
        latlist = new List < Double > ();
        longlist = new List < Double > ();
        String s = String.valueOf(System.today());
        Restrict_Kilometers__c mc = Restrict_Kilometers__c.getInstance();
        km = string.valueof(mc.Restrict_Kilometers__c);
        system.debug(km);
        system.debug(km);
       List < Visit__c > vt_list = [select id, Name, Unassigned__c ,Visit_Latitude__C, Visit_Longitude__c, Visit_Time__c , Visit_Date__c , Account__r.Name,Account__r.Phone, Account__r.BillingCity, Account__r.BillingStreet, Account__r.BillingState, Account__r.BillingCountry, Lead__r.Name , Lead__r.Phone ,Lead__r.Street,Lead__r.City,Lead__r.State,Lead__r.PostalCode,Lead__r.Country , Sequence_Number__c from Visit__c where OwnerId =: UserInfo.getUserID() AND Visit_Date__c =:Date.today() AND CheckOut__c= false AND Visit_Cancel__c= false order by Sequence_Number__c ASC limit 100];
        for (Visit__c v: vt_list) {
            latlist.add(v.Visit_Latitude__C);
            longlist.add(v.Visit_Longitude__c);
        }
        vt = JSON.serialize(vt_list);
        
        List<Beat_Plan__c> Beat = [select id from Beat_Plan__c where User__c =: UserInfo.getUserID() AND Date__c=: Date.today()];
        bt = JSON.serialize(Beat);
        system.debug(bt);
}

    public void getLocation() {
        List < user > leads = new List < user > ();
        leads = [select id, Address from user where id =: UserInfo.getUserID() limit 100];
        for (user lead: leads) {
            add = lead.Address.getStreet() + ' , ' + lead.Address.getCity() + ' , ' + lead.Address.getState() + ' , ' + lead.Address.getCountry();

        }
    }
    @RemoteAction
    public static void  updateTime(String json_data){
        TimeParse TP = (TimeParse)JSON.deserialize(json_data,TimeParse.class);
        System.debug(TP.visit_time+'-----'+TP.visit_id+TP.reason+'-------'+TP.new_date);
        String[] arr = TP.visit_time.split(':'); 
        String[] arr_1 = TP.new_date.split('/');
        Date dt = Date.newInstance(Integer.valueof(arr_1[2]) , Integer.valueof(arr_1[1]) , Integer.valueof(arr_1[0]));
        Visit__c visit = new Visit__c();
        if(dt == Date.today()){
          visit.Visit_Time__c = Time.newInstance(integer.valueof(arr[0]),integer.valueof(arr[1]) , 00 , 00);
          visit.Reason__c=TP.reason;
          visit.Id = TP.visit_id;
          visit.Visit_Date__c= dt;
        }else{
          visit.Visit_Time__c = Time.newInstance(integer.valueof(arr[0]),integer.valueof(arr[1]) , 00 , 00);
          visit.Reason__c=TP.reason;
          visit.Id = TP.visit_id;
          visit.Visit_Date__c= dt;
          visit.Beat_Plan__c = null;
        }
        
        update visit;
        
    }
    
      @RemoteAction
    public static void checkIn(String json_data){
        Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
        Visit__c visit = new Visit__c(CheckIn__c = Boolean.valueof(temp.get('checked_in')) , Id = String.valueof(temp.get('Id')));
        update visit;
        
    }
    @RemoteAction
    public static void checkOut(String json_data){
    Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
    Visit__c visit = new Visit__c(Id = String.valueof(temp.get('id')) , CheckOut__c = Boolean.valueof(temp.get('checked_out')) , Visit_Cancel__c = Boolean.valueof(temp.get('visit_cancel')) , Document_Recieved__c = Boolean.valueof(temp.get('docs_recieved')) , Comments__c = String.valueof(temp.get('comment')), Cash_Recieved__c= Boolean.valueof(temp.get('cash_recieved')),Unassigned__c = false );
    update visit;
    }
    @RemoteAction
    public static void cancelVisit(String json_data){
   Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
    Visit__c visit = new Visit__c(Id = String.valueof(temp.get('visit_id')) ,  Visit_Cancel__c = Boolean.valueof(temp.get('visit_cancel'))  );
    update visit;
    }
    
    @RemoteAction
    public static void StartMyDay(String json_data){
    DateTime dt=System.now();
    String dtStr=dt.format('HH:mm');
    string[] arr= dtStr.split(':');
    Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
    Beat_Plan__c beat = new Beat_Plan__c(Id = String.valueof(temp.get('Beat_id')), Start_latitude__c = Double.valueof(temp.get('UserLat')),Start_longitude__c = Double.valueof(temp.get('UserLong')),Start_Time__c =Time.newInstance(integer.valueof(arr[0]),integer.valueof(arr[1]) , 00 , 00));
    
     update beat;
    } 
    @RemoteAction
    public static void EndMyDay(String json_data){
    system.debug(json_data);
    DateTime dt=System.now();
    String dtStr=dt.format('HH:mm');
    string[] arr= dtStr.split(':');
    Map<string , Object> temp = (Map<string , Object>)JSON.deserializeUntyped(json_data);
    Beat_Plan__c beat = new Beat_Plan__c(Id = String.valueof(temp.get('Beat_id')), End_latitude__c = Double.valueof(temp.get('UserLat')),End_longitude__c = Double.valueof(temp.get('UserLong')),End_Time__c =Time.newInstance(integer.valueof(arr[0]),integer.valueof(arr[1]) , 00 , 00));
    system.debug(beat);
    update beat;
    } 
    
    @RemoteAction
    public static void UpdateSequence(List<map<string , Object>> json_array ){
    System.debug(json_array);
    list<Visit__c> visit_update_list = new list<Visit__c>();
    list<Beat_Plan__c> bt_update = new list<Beat_Plan__c>();
    for( Integer i = 0 ; i <json_array.size()-1 ; i++){
      visit_update_list.add( new Visit__c( Id = String.valueof(json_array[i].get('id')) , Sequence_Number__c = Integer.valueof(json_array[i].get('sequence')) ));
    }
    integer len = json_array.size()-1;
    bt_update.add( new Beat_Plan__c(Id = String.valueof(json_array[len].get('bid')), Sequence_Changed__c = true ));
    system.debug(visit_update_list);
    system.debug(bt_update);
    update visit_update_list ;
    update bt_update;
    }
}