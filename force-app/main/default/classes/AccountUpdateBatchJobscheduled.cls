public class AccountUpdateBatchJobscheduled implements Schedulable {

    public void execute(SchedulableContext sc) {
        BatchUpdateAccountPhone b = new BatchUpdateAccountPhone(); 
        Database.executeBatch(b, 200);
    }
}
