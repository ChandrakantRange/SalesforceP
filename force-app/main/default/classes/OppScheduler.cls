public class OppScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        OppNextStepBatch Job = new OppNextStepBatch();
        Database.executeBatch(Job, 200);
    }
}
/* String cron = '0 0 2 * * ?'; 
OppScheduler opp1 = new OppScheduler();
System.schedule('Daily Opp NextStep Batch', cron, opp1);
*/