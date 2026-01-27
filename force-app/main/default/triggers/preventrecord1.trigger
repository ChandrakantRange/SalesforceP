trigger preventrecord1 on Account (before update) {
     for(Account acc:trigger.new) {
         
         if(acc.CreatedDate<System.today()-6){
              acc.addError('You cannot updateaccount created 7 days back');
         }
         
     }
}