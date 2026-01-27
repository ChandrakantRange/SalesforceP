public class AccountHandler {
    public static Account insertNewAccount (String accountName) {
        
        Account newAccount = new Account(Name = accountName);
            newAccount.BillingCountry='india';
        
        try {
       
            insert newAccount;
            
            return newAccount;
        } catch (DmlException e) {
           
            System.debug('DML Exception occurred: ' + e.getMessage());
            return null;
        }
    }

}