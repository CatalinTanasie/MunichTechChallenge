import { LightningElement <!--and some others--> } from 'lwc';
import askQuestion from <!--use NTTShowQuestionController-->;
import CHAT_LOGO from '@salesforce/resourceUrl/ChatGPTIcon';

export default class ShowQuestion extends LightningElement {

    /**
    Add relevant variables
    */
    @track errors;

    @something
    displayLoadingIcon;

    [[someVariable]] = {};
    blueColor = 'rgb(65, 148, 249)';
    whiteColor = 'rgb(255,255,255)';
    orangeColor = 'rgb(255, 165, 0)';
    chatColor = 'rgba(99,172,155,255)';

    chatGPTIcon = CHAT_LOGO;

    someFunction(event) {
        if (Object.keys([[someVariable]]).length > 0) {
            this.setDefaultStyle(this.[[someVariable]].element);
        }
        /** Now select the answer */

        /** Navigating to next screen */
        if (this.availableActions.find(action => action === 'Next')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    setMouseOverColors(event) {
        if (this.selectedAnswer.value === event.target.dataset.id) return;
        event.target.style.backgroundColor = this.blueColor;
        event.target.style.borderColor = this.whiteColor;
        event.target.style.color = this.whiteColor;
    }

    setMouseOverColorsChat(event) {
        event.target.style.backgroundColor = this.chatColor;
        event.target.style.borderColor = this.whiteColor;
        event.target.style.color = this.whiteColor;
    }

    setMouseLeaveColors(event) {
        if (this.selectedAnswer.value === event.target.dataset.id) return;
        this.setDefaultStyle(event.target);
    }

    setMouseLeaveColorsChat(event) {
        event.target.style.backgroundColor = this.whiteColor;
        event.target.style.borderColor = this.chatColor;
        event.target.style.color = this.chatColor;
    }

    setDefaultStyle(target) {
        target.style.backgroundColor = this.whiteColor;
        target.style.borderColor = this.blueColor;
        target.style.color = this.blueColor;
    }

    setSelectedStyle(target) {
        target.style.backgroundColor = this.orangeColor;
        target.style.borderColor = this.orangeColor;
        target.style.color = this.whiteColor;
    }

    @api
    askChatGPT(event) {
        /**Ask ChatGPT */
        }
        /**
        if (this._remainingChatGPTCount <= 0) {
            this.isChatButtonAllowed = false;
        }*/
    }
/**
    connectedCallback() {
        this.isChatButtonAllowed = this.remainingChatGPTCount > 0;
    }*/
}