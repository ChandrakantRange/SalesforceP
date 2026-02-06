import { LightningElement, wire, api, track } from 'lwc';
import getRelatedContacts from '@salesforce/apex/AccountContactController.getRelatedContacts';

const COLUMNS = [
    { label: 'First Name', fieldName: 'FirstName' },
    { label: 'Last Name', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];

export default class DisplayContact extends LightningElement {
    @api accountId;
    @track contacts;
    @track error;

    // Flow related
    @track showFlow = true; // always show flow
    columns = COLUMNS;

    @wire(getRelatedContacts, { accountId: '$accountId' })
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    // Flow input variable
    get varAccountId() {
        return [
            { name: 'accountId', type: 'String', value: this.accountId }
        ];
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            // optional: do something when flow finishes
        }
    }
}
