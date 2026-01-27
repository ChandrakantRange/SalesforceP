public class preventDuplicateEmail {
    
    public static void preventDuplicateEmail1 (list<contact> newlist , map<id, contact> oldmap){
        set<string> email = new set <string> ();
        for(contact con : newlist){
            if(con.email != null && oldmap == null){
                email.add(con.email);
            }
            else{
                if(con.email != null && con.email != oldmap.get(con.id).email){
                    email.add(con.email);
                }
            }
        }
        
        
        list<contact> extingcontactlist = new list<contact>([select lastname, email from contact where email in: email]);
        
        set<string> emaillist = new set <string>();
        if(!extingcontactlist.isempty()){
            for(contact con1 : extingcontactlist){
                emaillist.add(con1.email);
            }
        }
        
        for(contact con3: newlist){
            if(emaillist.contains(con3.Email)){
                con3.adderror('duplicate email');
            }
        }
    }
    
   

}