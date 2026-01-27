@isTest
public class EmailServicingTest {

    @isTest
    static void testInboundEmail_LeadCreation() {
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        email.fromAddress = 'johndoe@test.com';
        email.fromName = 'John Doe';
        email.subject = 'Hot Lead';
        email.plainTextBody =
            'From: John Doe <johndoe@test.com>\n' +
            'Please contact me regarding your services.\n' +
            'Mobile: 9876543210\n';
        
        
        
       
        EmailServicing handler = new EmailServicing();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, envelope);

        
        Lead insertedLead = [SELECT Id, FirstName, LastName, Email, SICCode__c, Description, MobilePhone, Company
                             FROM Lead
                             WHERE Email = :email.fromAddress limit 1
                            ];}
       
          @isTest
        static void testInboundEmail_NoPhoneNumber() {
            Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope1 = new Messaging.InboundEnvelope();

            email1.fromAddress = '';
        email1.fromName = '';
        email1.subject = '';
        email1.plainTextBody = '' ;

             EmailServicing handler1 = new EmailServicing();
        Messaging.InboundEmailResult result1 = handler1.handleInboundEmail(email1, envelope1);

        
        Lead insertedLead1 = [SELECT Id, FirstName, LastName, Email, SICCode__c, Description, MobilePhone, Company
                             FROM Lead
                             WHERE Email = :email1.fromAddress limit 1
                            ];
        }

    
}