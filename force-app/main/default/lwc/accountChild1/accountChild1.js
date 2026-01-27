import { LightningElement } from 'lwc';

export default class AccountChild1 extends LightningElement {
searchtextChild;

    handleChange(event) {

        this.searchtextChild = event.target.value;    
}

handleClick (event)
{
 const searchevent =  new CustomEvent('getsearchevent', {detail: this.searchtextChild });
 this.dispatchEvent(searchevent);
}

}