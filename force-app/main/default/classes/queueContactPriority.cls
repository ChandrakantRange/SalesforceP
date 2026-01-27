Public class queueContactPriority implements Queueable {
    Set<Id> contactIds;

    public queueContactPriority(Set<Id> contactIds) {
        this.contactIds = contactIds;
    }

    Public void execute(QueueableContext bc) {
        List<Contact> contactsToUpdate = [SELECT Id, High_Priority_Case__c FROM Contact  WHERE Id IN :contactIds ];

        for (Contact c : contactsToUpdate) {
            c.High_Priority_Case__c = true;
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}