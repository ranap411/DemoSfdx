public class HTTPRouteCallOut {
    public string callout(String reqBody ){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://graphhopper.com/api/1/vrp/optimize?key=7150bed0-b9f6-4432-b5e4-f88939507925');
        req.setMethod('POST');
        req.setBody(reqBody);
        //req.setBody('{"username":"Salesforce","site":"ceat"}');
        req.setHeader('Content-Type', 'application/json');  
        try
        {
            res = http.send(req);
        }
        catch(System.CalloutException e)
        {
            System.debug('Callout error: '+ e);
        } 
        RouteWrapper route = (RouteWrapper)JSON.deserialize((string)res.getBody(), RouteWrapper.class);
         String jobid = route.job_id;
        System.debug(res.getBody());
        System.debug(jobid);
          HttpRequest req2 = new HttpRequest();
          req2.setMethod('GET');
          req2.setEndpoint('https://graphhopper.com/api/1/vrp/solution/'+jobid+'?key=7150bed0-b9f6-4432-b5e4-f88939507925');
        HttpResponse res2 = new HttpResponse();   
        res2 = http.send(req2);
       String response = res2.getBody();
        return response;
    }
    public class RouteWrapper
{
     public String job_id;
}
    public Long Epoch(DateTime dt){
        Long sec = dt.getTime()/1000;
        return sec;
    }
}