@RestResource(urlMapping='/SendAccount/*')

 global class restDemo{
 
 @HttpGet
    global static list <account> getAccount (){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        list<account> lst;
        lst = [select Name, Phone from account where Sync__c!=:true];
        return lst;
     }
      
}