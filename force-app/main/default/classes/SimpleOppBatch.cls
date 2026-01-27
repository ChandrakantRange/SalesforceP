Public class SimpleOppBatch implements Database.Batchable<sObject> {
    
    Public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, AccountId FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId != null]);
    }

    Public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Opportunity opp : scope) {
            accountIds.add(opp.AccountId);
        }

        List<Account> accountsToUpdate = [SELECT Id, Customer_Status__c FROM Account WHERE Id IN :accountIds];
        
        for (Account acc : accountsToUpdate) {
            acc.Customer_Status__c = 'Active';
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    Public void finish(Database.BatchableContext bc) {
  
        Messaging.SingleEmailMessage Email = new Messaging.SingleEmailMessage();
        Email.setToAddresses(new String[] {'chandrakant.range@optimumvalue.co'});
        Email.setSubject('Closed Won Opportunities Updated');
        Email.setPlainTextBody('Accounts related to Closed Won Opportunities.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{Email});
    }
}


/*
 SimpleOppBatch job = new SimpleOppBatch();
Database.executeBatch(job, 200);
*/