public with sharing class HandlerChatBot {
    @AuraEnabled
    public static string postChatText(String chatText){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://shubhampk.herokuapp.com/chatBot');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"chatText":"' + chatText + '"}'); 
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug(response.toString());
            /* System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus()); */
        } else {
            System.debug(response.getBody());
        }  
        System.debug(response.getBody());
        return response.getBody();
     
    }
    
    @AuraEnabled
    public static String createCase(String issue_type , String description,String articleid,String chat){
        User uObj = [Select id , Profile.UserLicense.Name from User where Id=: UserInfo.getUserId()];
        System.debug('##'+uObj.Profile.UserLicense.Name);
          System.debug(articleid);
         //System.debug(chat);
       
        Case c = new Case();
        if(description.isNumeric()){
            c.Type = issue_type ;
            c.Status='Closed';
            c.Type = 'Password Reset';
            c.Created_by_BoT__c = true;
            c.Rating__c =  Integer.valueof(description.trim());
          //  c.Bot_Chat__c = chat;
            insert c;
        }else{
        c.Type = issue_type;
        c.Description = description;
        c.Type = 'Password Reset';
        c.Created_by_BoT__c = true;
      //   c.Bot_Chat__c = chat;
        insert c;
        }
        if(articleid!=NULL){
            CaseArticle ca = new CaseArticle();
            ca.CaseId = c.Id;
            ca.KnowledgeArticleId =articleid;
            insert ca;   
        }
        
        return JSON.serialize([select CaseNumber,Id from case where id =:c.Id]);
    }
    
    @AuraEnabled
    public static String getRecordTypes(){
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        return JSON.serialize(RT);
    }
    
    @AuraEnabled
    public static String getPickListValues(){
        Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        return JSON.serialize(ple);
    }
    
    @AuraEnabled 
    public static String getArticlesLinks(String issue_type , String description){
        List<KnowledgeArticleVersion> articles = [Select id , Title  from KnowledgeArticleVersion where Title=:issue_type];
        return JSON.serialize(articles);
    }
}