trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
    list<task> ta= new list <task>();
    for (Opportunity opp: trigger.new){
        if(opp.StageName == 'Closed Won'){
            task  t = new task();
            t.Subject='Follow Up Test Task';
            t.WhatId=opp.Id;
            t.Status='Not Started';
            t.Priority='high';
            
           ta.add(t);
        }
        
    }
    if(!ta.isEmpty()){
        insert ta;
    }
         
}