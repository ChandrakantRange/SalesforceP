trigger preventrecord on Account (before update) {
    for (account acc: trigger.old){
        account oldacc= trigger.oldmap.get(acc.id);{
            if(oldacc.CreatedDate > system.today()-7 ){
            oldacc.adderror('you can not delete record');
        

        }
        
        
    }
    
}
}