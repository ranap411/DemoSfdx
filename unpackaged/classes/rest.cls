@RestResource(urlMapping='/ShowAccount1/*')
global class rest{
 
@HttpGet
global static list <account> getAccount (){
RestResponse res = RestContext.response;
list<account> lst;
lst = [select Name, Phone from account];
system.debug(res);
return lst;
 }
@HttpPost
global static string putAccount(string Name, string Phone, string Id){
  account acc = new account();
  acc.Name=Name;
  acc.Phone=Phone;
  acc.ExId__c = id;
  insert acc;
  return acc.Id;   
}
    
@HttpDelete
global static void deleteAccount(){
RestRequest req=RestContext.request;
RestResponse res = RestContext.response;
string Id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
  Account del = [select name,Phone from account where ExId__c = :Id];
  delete del;
}

@HttpPatch 
    global static void updateAccount(String Id, String Name,String Phone){
        Account ac = [select Name , Phone from account where ExId__c = :Id];
        ac.Name = Name ;
        ac.Phone = Phone ;
        update ac ;
    }   
}