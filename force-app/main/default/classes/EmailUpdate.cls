public class EmailUpdate {
    public static void email2(){
        
        List<Account> acc = [SELECT Id, Name, Email__c FROM Account];
        
        
        List<Account> accountsToUpdate = new List<Account>();
        
        
        for (Account acc1 : acc) {
            
            if (String.isBlank(acc1.Email__c)) {
                
                acc1.Email__c = 'Education123@gmail.com';
                
                accountsToUpdate.add(acc1);
            }
        }
        
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        
    }
    
}