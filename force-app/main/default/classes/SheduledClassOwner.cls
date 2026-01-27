public class SheduledClassOwner implements Schedulable{
    public void execute (SchedulableContext SC){
        User defaultUser = [SELECT Id FROM User WHERE Id = '005dL00000OsK6MQAV' LIMIT 1];
        id defaultid = defaultUser.id ;
        
        list<Opportunity> opp1= [select id from Opportunity where Ownerid = null] ;
        {
            for (Opportunity opp: opp1){
                opp.OwnerId = defaultid;
            }
        }
    }

}