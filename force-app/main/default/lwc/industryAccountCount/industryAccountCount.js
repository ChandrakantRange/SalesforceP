import { LightningElement , wire} from 'lwc';
import Accountindustry from '@salesforce/apex/AccountController.Accountindustry';


const columns = [
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Account Name', fieldName: 'Name', type: 'text' },
    { label: 'Account Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Account Email', fieldName: 'Email__c', type: 'email' } 
];

export default class IndustryAccountCount extends LightningElement {
    data;
    error;
  

    columns = columns;

    @wire(Accountindustry)
    wiredAccounts({ error, data }) {
        if (data) {
            // Map data to make it compatible with the datatable
            this.data = data.map(record => {
                return {
                    Industry: record.Industry ? record.Industry : 'NO Industry on Record',
                    Name: record.Name ? record.Name : 'No Name',
                     Email__c: record.Email__c ? record.Email__c : 'No Email',
                     Phone : record.Phone ? record.Phone : 'No Phone'
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
}





