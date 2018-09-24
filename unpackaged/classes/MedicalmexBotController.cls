public class MedicalmexBotController {
 @AuraEnabled
    public static string postChatText(String chatText){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://shubhampk.herokuapp.com/users/chatBot');
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
   
}