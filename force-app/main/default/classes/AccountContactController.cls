public with sharing class AccountContactController {

    @AuraEnabled
    public static Id createAccountWithContacts( String accountName,String phone, String Email,Integer contactCount ) {

        Account acc = new Account(
            Name = accountName,
            Phone = phone,
            Email__c = Email,
            No_Of_Contact__c = contactCount
        );

        insert acc;

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 1; i <= contactCount; i++) {
            contacts.add(new Contact(
                FirstName = acc.Name,
                LastName = 'Contact ' + i,
                AccountId = acc.Id,
                Email = acc.Email__c,
                Phone = acc.Phone
            ));
        }

        insert contacts;

        return acc.Id; 
    }
    
    @InvocableMethod(label='Get Account Id' description='Returns Account Id for Flow')
    public static List<Id> getAccountId(List<Id> accountIds) {
        return accountIds;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContacts(Id accountId) {
        return [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
        ];
    }
}