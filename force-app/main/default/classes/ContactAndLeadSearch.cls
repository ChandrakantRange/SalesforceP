public class ContactAndLeadSearch {
    public static List<List<sObject>>searchContactsAndLeads(String searchName){
        List<List<sObject>> searchResults = [FIND :searchName IN NAME FIELDS RETURNING Contact(Id, Name), Lead(Id, Name)];
        
     
        return searchResults;
        
    }

}