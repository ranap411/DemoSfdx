global with sharing class WebServiceExecuteBatches{
   WebService static string BatchToRunTodayVisits(){
    //string q = 'soql query';
     BatchToRunTodayVisits b = new BatchToRunTodayVisits();
        ID batchprocessid=Database.executeBatch(b); 
        return batchprocessid;
      //  return null;
   }
}