global class BatchHignPriority implements Database.Batchable<sObject>, Database.Stateful {

    global Set<Id> contactId = new Set<Id>();

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Priority, ContactId FROM Case WHERE Priority = 'High']);
    }

    public void execute(Database.BatchableContext bc, List<Case> case2){
        List<Case> case1 = new List<Case>();

        for (Case c : case2) {
            c.Status = 'Low'; 
            case1.add(c);

            if (c.ContactId != null) {
                contactId.add(c.ContactId);
            }
        }

        if (!case1.isEmpty()) {
            update case1;
        }
    }
    

    public void finish(Database.BatchableContext bc){
            System.enqueueJob(new queueContactPriority(contactId));
    }
}