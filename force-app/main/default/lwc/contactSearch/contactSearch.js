import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchContacts from '@salesforce/apex/SearchContactName.searchContacts';

export default class ContactSearch extends NavigationMixin(LightningElement) {
    @api recordId;
    @track contacts;
    noResults = false;

    handleSearch(event) {
        const searchKey = event.target.value;

        if (!searchKey || searchKey.length < 2) {
            this.contacts = null;
            this.noResults = false;
            return;
        }

        searchContacts({
            accountId: this.recordId,
            searchKey: searchKey
        })
        .then(result => {
            this.contacts = result;
            this.noResults = result.length === 0;
        })
        .catch(error => {
            console.error(error);
        });
    }

    handleContactClick(event) {
        const contactId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contactId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}