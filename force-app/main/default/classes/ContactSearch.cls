public class ContactSearch {
    public static list<contact> searchForContacts (string lastname , string  mailingPostalCode){
        list <contact> contacts =[select id, Name From contact WHERE LastName = :lastName AND MailingPostalCode = :mailingPostalCode ];
         return contacts;
    }

}