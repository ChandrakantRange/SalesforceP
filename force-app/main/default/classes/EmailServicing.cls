public class EmailServicing implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        try {
            String plainBody = email.plainTextBody != null ? email.plainTextBody : '';
            String originalEmail = '';
            String originalName = '';
            String firstName = '';
            String lastName = '';
            String mobileNumber ='';

          
            for (String line : plainBody.split('\n')) {
                if (line.toLowerCase().startsWith('from:')) {
                  
                    Integer lt = line.indexOf('<');
                    Integer gt = line.indexOf('>');

                    if (lt > -1 && gt > -1) {
                        originalEmail = line.substring(lt+1, gt).trim();
                        originalName  = line.substring(5, lt).trim(); 
                    } else {
                        originalEmail = line.substring(5).trim();
                    }
                    break;
                }
            }

           
            if (String.isBlank(originalEmail)) {
                originalEmail = email.fromAddress;
                originalName  = email.fromName;
            }

         
            if (!String.isBlank(originalName)) {
                List<String> parts = originalName.split(' ', 2);
                firstName = parts.size() > 1 ? parts[0] : '';
                lastName  = parts.size() > 1 ? parts[1] : parts[0];
            } else {
                lastName = 'Unknown Sender';
            }
            Pattern phonePattern = Pattern.compile('\\b\\d{10}\\b'); 
            Matcher phoneMatcher = phonePattern.matcher(plainBody);
            if (phoneMatcher.find()) {
                mobileNumber = phoneMatcher.group(0);
            }


            Lead l1 = new Lead();
            l1.FirstName = firstName;
            l1.LastName  = lastName;  
            l1.Email     = originalEmail;
            L1.SICCode__c=EMAIL.SUBJECT;
            l1.Description = plainBody; 
            l1.MobilePhone= mobileNumber;
            L1.Company='DEGF';

            insert l1;

        } catch (Exception e) {
            System.debug('Error inserting Lead: ' + e.getMessage());
        }

        return result;
    }
}