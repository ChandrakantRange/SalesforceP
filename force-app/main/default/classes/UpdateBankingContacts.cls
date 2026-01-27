public class UpdateBankingContacts implements Queueable {
    public void execute(QueueableContext ctx) {
    List<Contact> contactsToUpdate = [ SELECT Id, Title, AccountId FROM Contact WHERE Account.Industry = 'Banking' ];
        for (contact con:contactsToUpdate ){
            con.title = 'Banking';
        }
        if (!contactsToUpdate.isempty()){
            update contactsToUpdate;
        }
    }   
}