import { LightningElement } from 'lwc';

export default class Calculator extends LightningElement {
    firstNumber = 0;
    secondNumber = 0;
    result = 0;

    handleChange(event) {
        const field = event.target.dataset.field;
        this[field] = parseFloat(event.target.value);
    }

    handleAdd() {
        this.result = this.firstNumber + this.secondNumber;
    }

    handleSubtract() {
        this.result = this.firstNumber - this.secondNumber;
    }

    handleMultiply() {
        this.result = this.firstNumber * this.secondNumber;
    }

    handleDivide() {
        this.result =
            this.secondNumber !== 0
                ? this.firstNumber / this.secondNumber
                : 'Cannot divide by zero';
    }
}
