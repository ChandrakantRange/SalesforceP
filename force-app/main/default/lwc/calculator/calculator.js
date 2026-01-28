import { LightningElement , track} from 'lwc';

export default class Calculator extends LightningElement {
    

    @track firstNumber;
    @track secondNumber;
    @track result = 0;

    handleNum1Change(event) {
        this.firstNumber = parseFloat(event.target.value);
    }

    handleNum2Change(event) {
        this.secondNumber = parseFloat(event.target.value);
    }

    handleCalculation(event) {
        const operation = event.target.name;
        if (operation === 'add') {
            this.result = this.firstNumber + this.secondNumber;
        } else if (operation === 'subtract') {
            this.result = this.firstNumber - this.secondNumber;
        } else if (operation === 'multiply') {
            this.result = this.firstNumber * this.secondNumber;
        } else if (operation === 'divide') {
            this.result = this.secondNumber !== 0 ? this.firstNumber / this.secondNumber : 'Error';
        }
    }
}
