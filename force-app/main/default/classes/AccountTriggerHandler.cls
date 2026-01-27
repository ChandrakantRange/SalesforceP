# MY First Pull Request

public class AccountTriggerHandler {
    public static void preventDelIfHasRelatedCase (list<Account> oldlist){
        set<id> idset = new set<id>();
        for(account acc: oldlist){
            if(acc.id!= null){
                idset.add(acc.id);
            }
        }
        for( Account acc : [select id , (select id from cases) from account where id in: idset]){
            if(acc.cases.size()>0){
                acc.addError('yopu can not delete account where cases are availble');
            }
        }
    } 

}
