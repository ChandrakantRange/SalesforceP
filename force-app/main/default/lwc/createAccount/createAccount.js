import { LightningElement, track } from 'lwc';
import createAccountWithContacts 
    from '@salesforce/apex/AccountContactController.createAccountWithContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateAccount extends LightningElement {
    @track accountName = '';
    @track phone = '';
    @track Email = '';
    @track contactCount;

    accountId; 

    handleChange(event) {
        this[event.target.name] = event.target.value;
    }

    handleCreate() {
        createAccountWithContacts({
            accountName: this.accountName,
            phone: this.phone,
            Email: this.Email,
            contactCount: this.contactCount
        })
        .then(result => {
            this.accountId = result; 

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account and Contacts created successfully',
                    variant: 'success'
                })
            );
            this.resetFields();
        })
        .catch(error => {
            this.showError(error);
        });
    }

    resetFields() {
        this.accountName = '';
        this.phone = '';
        this.Email = '';
        this.contactCount = '';
    }

    showError(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            })
        );
    }
}
