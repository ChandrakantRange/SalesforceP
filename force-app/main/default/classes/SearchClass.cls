public with sharing class SearchClass {
    public static list<Opportunity> SearchClass(string stage , string name) {
        list<Opportunity> opp= [select id, name, stageName from Opportunity where stageName = :stage and name = :name];
        return opp;
        
    }
}