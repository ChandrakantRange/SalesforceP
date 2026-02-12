public class AccountController {
   @AuraEnabled(cacheable=true)
    public static List<Account> Accountindustry(){
        return [SELECT Industry, Name,	Email__c ,Phone
            FROM Account
            ];
    }

}