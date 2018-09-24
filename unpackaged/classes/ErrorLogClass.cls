/****************************************************************************************
* @Date         July 25th, 2018
* @Description  To insert the error on error object to track the error while sending data to the Admin
* @revision(s)
*
********************************************************************************************/
public class ErrorLogClass {
    
    /**********************************************************************
    * @Description Method to insert the error in the Error Log object
    * @param String, String, String, String, String, String, String, String
    * @return void
    ***********************************************************************/
    public static void LogError(String ErrorMessage, String StackTrace, String SourceClass, String SourceMethod, String ObjectName, String RecordName, String RecordId, string adminId, String JsonRequest, string statusError, integer statusCode ){
        try{
            Error_Log__c errorLog = new Error_Log__C();
            errorLog.Error_Message__c = ErrorMessage;
            errorLog.Stack_Trace__c = StackTrace;
            errorLog.Source_Class__c = SourceClass;
            errorLog.Source_Method__c = SourceMethod;
            errorLog.Object_Name__c = ObjectName;
            errorLog.Record_Name__c = RecordName;   
            errorLog.IsResolved__c = false;
            errorLog.Record_Id__c = RecordId;
            errorLog.Admin_Application_Id__c = adminId;
            errorLog.Status_Code__c = statusCode;
            errorLog.Status_Error__c = statusError;
            errorLog.Json_Request_String__c = String.isNotBlank(JsonRequest) && JsonRequest.length()<32768 ? JsonRequest : 'Please find the attachment for JSON';
            
            insert errorLog;
            
            if ( String.isNotBlank(JsonRequest) && JsonRequest.length() > 32768 ) {
                Attachment theAttachment = new Attachment();
                theAttachment.Body = Blob.valueOf(JsonRequest);
                theAttachment.Name = String.valueOf('JsonRequest.txt');
                theAttachment.ParentId = errorLog.Id; 
                insert theAttachment;
            }
        }
        catch(exception e){
            system.debug(LoggingLevel.ERROR, 'LogError method failed'+e.getMessage());
        }       
    }
}