import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchOpportunities from '@salesforce/apex/SearchClass.searchOpportunities';

export default class SearchOpp extends NavigationMixin(LightningElement) {

    @api recordId;
    @track opportunities;
    noResults = false;

    handleSearch(event) {
        const searchKey = event.target.value;

        if (!searchKey || searchKey.length < 2) {
            this.opportunities = null;
            this.noResults = false;
            return;
        }

        searchOpportunities({ searchKey })
            .then(result => {
                this.opportunities = result;
                this.noResults = result.length === 0;
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleOppClick(event) {
        const oppId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: oppId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }
}
