global class BatchToFillWeeksDays implements Database.Batchable<Sobject> {
    Date dt = Date.today(); 
    Integer yr = dt.year();
    String [] months=new String[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
    
  global Database.QueryLocator start(Database.BatchableContext bc) {
    String query = '';
      return Database.getQueryLocator(query);
  }
    global void execute(Database.BatchableContext context, List<Sobject> scope) {
        List<Week__c> weeksList = new List<Week__c>();
        for(Sobject obj : scope ){
          
        }
        for(Integer i=0;i<months.size();i++){
            Integer numberOfWeeks = getNumberofWeeks(i+1);
        }
    }
  global void finish(Database.BatchableContext context) {
  }
    
    public Integer getNumberOfWeeks(Integer month){
        Integer numberDays = Date.daysInMonth(yr,month);
        Datetime temp = DateTime.newInstance(yr,month,numberDays);
        Datetime temp2 = DateTime.newInstance(yr,month,01);
        Integer NumberOfWeeks = numberDays/7;
        if(temp.format('E')!= 'Sun'){
            NumberOfWeeks = + 1;
        }
        if(temp.format('E') == 'Sat'){
            NumberOfWeeks = + 1;
        }
        return NumberOfWeeks;
    }
}