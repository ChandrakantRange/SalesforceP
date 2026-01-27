public class BatchEmailCheck implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(  'SELECT Id, Email, Email_Missing__c FROM Contact WHERE Email = NULL');
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Contact con : (List<Contact>) scope) {
            con.Email_Missing__c = true;   
            contactsToUpdate.add(con);
        }
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Email Check completed successfully.');
    }
}
//////
//
// BatchEmailCheck job = new BatchEmailCheck();
//Database.executeBatch(job, 200);
//