import { LightningElement, track , api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAccount from '@salesforce/apex/AccountCreate.createAccount';
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import BIRTHDATE_FIELD from "@salesforce/schema/Contact.Birthdate";
import FIRSTNAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LASTNAME_FIELD from "@salesforce/schema/Contact.LastName";
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import OPP_NAME_FIELD from '@salesforce/schema/Opportunity.Name'; 
import STAGENAME_FIELD from "@salesforce/schema/Opportunity.StageName";
import AMOUNT_FIELD from "@salesforce/schema/Opportunity.Amount";
import CLOSEDATE_FIELD from "@salesforce/schema/Opportunity.CloseDate";




export default class CreateAccount extends LightningElement {
   @ track accountId;
   @track contactKey = 0;
   @track oppKey = 0;
    @track name = '';
    @track phone = '';
    @track website = '';
    @track employees = '';
    @track revenue = '';
    

    fields = [FIRSTNAME_FIELD , PHONE_FIELD, BIRTHDATE_FIELD, LASTNAME_FIELD, TITLE_FIELD, EMAIL_FIELD]
    fields1=[OPP_NAME_FIELD , STAGENAME_FIELD, AMOUNT_FIELD, CLOSEDATE_FIELD]
    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleSave() {
    createAccount({
        name: this.name,
        phone: this.phone,
        website: this.website,
        employees: this.employees,
        revenue: this.revenue
    })
       
      
    .then(() => {
        
        this.dispatchEvent(
            
           
            new ShowToastEvent({
                title: 'Success',
                message: 'Account created successfully',
                variant: 'success'
            })
        );
    })
    .catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            })
            
        );
         
    });
}

 

  handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Contact created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
             this.contactKey++;

        this.dispatchEvent(evt);
    }
handleopp(event) {
    const evt = new ShowToastEvent({
        title: 'Opportunity created',
        message: 'Record ID: ' + event.detail.id,
        variant: 'success',
    });
     this.oppKey++;
    this.dispatchEvent(evt);
}

}
