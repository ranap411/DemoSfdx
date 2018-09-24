public with sharing class getStringArray {
    @auraEnabled
    public static List<String> getString_array(){
        return( new String[]{'NAME1' , 'nAME2' , 'nAME 3'});
    }
    
}