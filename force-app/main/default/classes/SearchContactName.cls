public class SearchContactName {
    
     @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(Id accountId, String searchKey) {
        if (String.isBlank(searchKey)) {
            return new List<Contact>();
        }

        return [
            SELECT Id, Name, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
            AND Name LIKE :('%' + searchKey + '%')
            ORDER BY Name
            LIMIT 20
        ];
    }

}