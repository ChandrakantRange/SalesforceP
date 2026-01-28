import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME from '@salesforce/schema/Account.Name';
import PHONE from '@salesforce/schema/Account.Phone';
import WEBSITE from '@salesforce/schema/Account.Website';
import NumberOfEmployees from '@salesforce/schema/Account.NumberOfEmployees';
import Email from '@salesforce/schema/Account.Email';


export default class CreateAccountForm extends LightningElement {

    accountFields = [NAME, PHONE, WEBSITE, NumberOfEmployees , Email];

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        
        
    }
}
