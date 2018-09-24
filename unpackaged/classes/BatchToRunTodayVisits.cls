global class BatchToRunTodayVisits implements Database.Batchable<Sobject>, Database.AllowsCallouts  {
    Date dt = Date.today(); 
global Database.QueryLocator start(Database.BatchableContext bc) {
    
    String query = 'select id, Name, Visit_Latitude__C, Visit_Longitude__c,DateTime__c, Visit_Date__c , Lead__r.Name,OwnerId from Visit__c  Where Visit_Date__c =:dt AND CheckOut__c= false AND Visit_Cancel__c= false order by Visit_Time__c ASC';
    return Database.getQueryLocator(query);    
}
    
    global void execute(Database.BatchableContext bc, List<Visit__c> scope) {
      List<Beat_Plan__c> beatPlans = new List<Beat_Plan__c>();
      List<Visit__c> visitsUpdate = new List<Visit__c>();
      Map<Integer,List<visit__c>> visitmap = new Map<Integer,List<visit__c>>();
      Map<Integer,Beat_Plan__c> beatmap = new Map<Integer,Beat_Plan__c>();
      Integer J=1;
      HTTPRouteCallOut http = new HTTPRouteCallOut();
      System.debug(scope);
     Map<String,List<Visit__c>> visits = new Map<String,List<Visit__c>>();
        for(Visit__c v : scope)
        {
        if (!visits.containsKey(v.OwnerId))
            visits.put(v.OwnerId, new List<Visit__c>());
            
            visits.get(v.OwnerId).add(v); 
        }
       System.debug(visits);     
       
        for(List<Visit__c> visitList : visits.values()) {
       JSONGenerator gen = JSON.createGenerator(true);
       gen.writeStartObject();
       gen.writeFieldName('vehicles');
       gen.writeStartArray();
       gen.writeStartObject();
       gen.writeObjectField('vehicle_id','MP07');
       gen.writeFieldName('start_address');
       gen.writeStartObject();
       gen.writeObjectField('location_id','GWL');
       gen.writeObjectField('lon',78.182831);
       gen.writeObjectField('lat',26.218287);
       gen.writeEndObject();
       gen.writeObjectField('return_to_depot',false);
       gen.writeObjectField('earliest_start',0);
       gen.writeEndObject();
       gen.writeEndArray();
       gen.writeFieldName('services');
       gen.writeStartArray();
       String ownerId = visitList[0].OwnerID;
        for(Visit__c visit : visitList) {
        Long earliest = http.Epoch(visit.DateTime__c);  
        System.debug(earliest);
        gen.writeStartObject();
        gen.writeStringField('id',visit.Id);
        gen.writeStringField('name',visit.Name);
        gen.writeFieldName('address');
        gen.writeStartObject();
       gen.writeObjectField('location_id',visit.Name);
       gen.writeObjectField('lon',visit.Visit_Longitude__c);
       gen.writeObjectField('lat',visit.Visit_Latitude__C);
       gen.writeEndObject();
       gen.writeFieldName('time_windows');
       gen.writeStartArray(); 
       gen.writeStartObject();
       gen.writeObjectField('earliest',earliest); 
       gen.writeObjectField('latest',earliest);   
       gen.writeEndObject();
       gen.writeEndArray();
       gen.writeEndObject();
              }
       gen.writeEndArray();
       gen.writeEndObject();
       String StrreqBody = gen.getAsString(); 
       System.debug(StrreqBody);
      String response = http.callout(StrreqBody);
            System.debug(response);
      JSON2Apex myClass = (JSON2Apex)JSON.deserialize(response, JSON2Apex.class);
           System.debug(myclass);
          // System.debug(myclass.activities);
      JSON2Apex.Solution solution = myclass.solution;
      JSON2Apex.routes routes = solution.routes[0];
       Beat_Plan__c beatPlan = new Beat_Plan__c();
       beatPlan.User__c = ownerId;
       beatPlan.Date__c = dt;
      List<JSON2Apex.activities> activities = routes.activities;
      List<Visit__c> beatvisits = new List<Visit__c>();
          Integer i=1;
            for(JSON2Apex.activities activity : activities){
                if(!activity.type.equals('start')){
               Visit__c visit = new Visit__c();
               visit.Sequence_Number__c = i;
               visit.Id = activity.id;  
              // visitsUpdate.add(visit);
               beatvisits.add(visit);
               i++;
                }
            }       
       
        JSON2Apex.Unassigned unassignedvisits = solution.unassigned;  
        List<String> visitids = unassignedvisits.services;
            for(String visitid : visitids){
               Visit__c visit2 = new Visit__c();
                visit2.Unassigned__c = True;
                visit2.Sequence_Number__c = i;
                visit2.Id = visitid;
              //  visitsUpdate.add(visit2);
                beatvisits.add(visit2);
            }
       
        beatPlans.add(beatPlan);
        beatmap.put(j,beatPlan);
       // visitsUpdate.addAll(beatvisits);
        visitmap.put(j,beatvisits);
         j++;
          }
        insert beatplans;
        System.debug(beatplans[0].Id);
        for(Integer key : beatmap.keySet()){
            if(visitmap.containsKey(key))
            {
              Beat_Plan__c beat = beatmap.get(key);
              List<Visit__c> v = visitmap.get(key);
                for(Visit__c v2 : v){
                    v2.Beat_Plan__c = beat.Id;
                }
               visitsUpdate.addAll(v);
            }
            
        }
        
        update visitsUpdate;
    }
    global void finish(Database.BatchableContext bc) {
        System.debug('Finished executing batch');
        
    }
    
   
}