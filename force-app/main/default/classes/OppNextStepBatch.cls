public class OppNextStepBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([ SELECT Id, Name, StageName, NextStep__c  FROM Opportunity  WHERE StageName != 'Closed Won' ]);   }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        list <Opportunity> opp2 = new list<Opportunity>();
        for (Opportunity opp : scope) {
            opp.NextStep__c = 'Call the person';  
        }
        update opp2;
    }

    public void finish(Database.BatchableContext bc) {
        System.enqueueJob(new OppMailQueue());
    }
}