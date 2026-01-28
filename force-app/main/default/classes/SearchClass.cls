public class SearchClass {

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> searchOpportunities(String searchKey) {

        return [
            SELECT Id, Name, StageName
            FROM Opportunity
            WHERE Name LIKE :('%' + searchKey + '%')
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}
