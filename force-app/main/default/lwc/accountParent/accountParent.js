import { LightningElement } from 'lwc';

export default class AccountParent extends LightningElement {
searchtext;
    handleSearchEvent(event)
    {
          this.searchtext=event.detail;
    }
}