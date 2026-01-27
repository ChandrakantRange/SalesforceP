@isTest
public class ContactSerchTest {
    
    @testSetup
    static void setupData() {
        Contact con = new Contact(
            FirstName = 'Jay',
            LastName  = 'Jor',
            Phone     = '95649845',
            MailingPostalCode = '565965'
        );
        insert con;
    }
    
    @isTest
    static void testSearchForContacts_Found() {
        Test.startTest();
        List<Contact> results = ContactSearch.searchForContacts('Jor', '565965');
        Test.stopTest();
        
    }
    
    @isTest
    static void testSearchForContacts_NotFound() {
        Test.startTest();
        List<Contact> results = ContactSearch.searchForContacts('Jor', '999999');
        Test.stopTest();
        
        
    }
}