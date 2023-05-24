/**
 * Created by catalinalexandrutanasie on 10.05.23.
 */

import { LightningElement, <!--other stuff--> } from 'lwc';
import WIN_IMAGE from '@salesforce/resourceUrl/winImage';
import LOSE_IMAGE from '@salesforce/resourceUrl/loseImage';
import TEST_IMAGE from '@salesforce/resourceUrl/testImage';

export default class ShowResults extends LightningElement {

    get isTestRun() {
        return this._isTestRun;
    }

    @api set isTestRun(value) {
        this._isTestRun = value;
    }

    @track _isTestRun = true;

    @track resultImage;
    @track errorMessage;
    @track showError = false;

    connectedCallback() {
        if (this.triviaScore != null && this.triviaFeedback != null) {
            if (this.isTestRun) {
                this.resultImage = TEST_IMAGE;
            } else if (this.triviaScore >= 10) {
                this.resultImage = WIN_IMAGE;
            } else {
                this.resultImage = LOSE_IMAGE;
            }
        } else {
            this.errorMessage = 'An error occurred in processing the response. Please check the WS response or flow.';
            this.showError = true;
        }
    }
}

