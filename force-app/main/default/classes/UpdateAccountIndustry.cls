public class UpdateAccountIndustry implements Queueable  {
    public void execute(QueueableContext ctx){
        list<account > account1 = [select id , industry from account where industry= 'banking'];
        for (account acc: account1){
         acc.Description = 'Updated by Queueable';
        }
            if (!account1.isempty()){
                update account1 ; 
            }
        System.enqueueJob(new UpdateBankingContacts());
    }
   
}