global class ExBatch implements Database.Batchable<Account> {
    global Iterable<Account> start(Database.BatchableContext bc ){
        List<Account> al = [ select Id , Name from Account];
        return al ;
    }    
    
    global void execute(Database.BatchableContext bc , list<Account> al ){
        for( Account ac : al ){
            ac.Name = 'Yash' ;
        }
        update al ;
    }
    global void finish(Database.BatchableContext bc ){
        
    }
}