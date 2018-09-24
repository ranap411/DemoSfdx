public class UpsertMetaDataController{
    public list<Sistema_TnC_Mail_Setting__mdt> TnCMetaData {get;set;}
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<account> acclist{get;set;}
  
    public UpsertMetaDataController(){
     csvFileLines = new String[]{};
     acclist = New List<Account>(); 
        TnCMetaData = [select Id, Label, DeveloperName, Sistema_Email__c from Sistema_TnC_Mail_Setting__mdt];
        system.debug('List of records : '+TnCMetaData );
    }
    
     public void importCSVFile(){
       try{
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue(); 
           for(Integer i=1;i<csvFileLines.size();i++){
               Account accObj = new Account() ;
            string[] csvRecordData = csvFileLines[i].split(',');
                customMetadata =  new Metadata.CustomMetadata();
                customMetadata.fullName = 'Sistema_TnC_Mail_Setting.'+csvRecordData[0];
                customMetadata.label = csvRecordData[0];
                customField = new Metadata.CustomMetadataValue();
                customField.field = 'Sistema_Email__c';
                customField.value = csvRecordData[1];
                customMetadata.values.add(customField);
                system.debug(customField);   
            }   
           
               system.debug(customMetadata);
                mdContainer.addMetadata(customMetadata);
               MetaDataCallBack callback = new MetaDataCallBack();
        
            // Enqueue custom metadata deployment
            system.debug('Container: ' + mdContainer);
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
           //pageReference pg = new pageReference();
        }
        
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
  }
    
   
}