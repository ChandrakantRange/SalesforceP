public class OppMailQueue implements Queueable {
    
    public void execute(QueueableContext ctx) {
        List<Opportunity> opps = [SELECT Id, Name, NextStep, LastModifiedDate FROM Opportunity WHERE LastModifiedDate = TODAY  ];

        if (opps.isEmpty()) 
            return;

        String body = 'Opportunities updated today:';
        for (Opportunity o : opps) {
            body += '- ' + o.Name + ' | Next Step: ' + o.NextStep__c + '';
        }

        Messaging.SingleEmailMessage Email = new Messaging.SingleEmailMessage();
        Email.setToAddresses(new String[] { 'chandrakant.range@optimumvalue.co' }); 
        Email.setSubject('Daily Opportunity NextStep Update');
        Email.setPlainTextBody(body);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ Email });
    }
}