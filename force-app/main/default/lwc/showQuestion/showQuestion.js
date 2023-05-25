import { LightningElement, api, track } from 'lwc';
import askQuestion from '@salesforce/apex/NTTShowQuestionController.askChatGPTForTriviaAnswer';
import CHAT_LOGO from '@salesforce/resourceUrl/ChatGPTIcon';

export default class ShowQuestion extends LightningElement {
    get question() {
        return this._question;
    }
    @api
    set question(value) { 
        let data = {...value};
        data.publicImageURLList = data.publicImageURLList[0];
        this._question = data;
    }

    get answer() {
        return this._answer;
    }

    @api
    set answer(value) {
        this._answer = value;
    }

    @api set chatGPTCount(value) {
        this._chatGPTCount = value;
    }

    get chatGPTCount() {
        return this._chatGPTCount;
    }

    @track chatGPTAnswer;
    @track _chatGPTCount;
    @track isChatButtonAllowed = true;
    @track displayLoadingIcon = false;
    @track chatQueryPerformed = false;
    @track errors;

    _question;
    _answer;
    selectedAnswer = {};
    blueColor = 'rgb(65, 148, 249)';
    whiteColor = 'rgb(255,255,255)';
    orangeColor = 'rgb(255, 165, 0)';
    chatColor = 'rgba(99,172,155,255)';

    chatGPTIcon = CHAT_LOGO;

    selectAnswer(event) {
        if (Object.keys(this.selectedAnswer).length > 0) {
            this.setDefaultStyle(this.selectedAnswer.element);
        }
        const answerChoice = event.target.dataset.id;
        this.selectedAnswer.value = answerChoice;
        this.selectedAnswer.element = this.template.querySelector(`[data-id="${answerChoice}"]`);
        this.setSelectedStyle(event.target);
        this.answer = answerChoice;
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
        if (this.chatQueryPerformed == false) {
            this.displayLoadingIcon = true;
           askQuestion({extractCityNameOnly : false,
                triviaHints : this.question.triviaHints,
                triviaAnswerChoicesList : this.question.answerChoices})
               .then(result => {
                   this.displayLoadingIcon = false;
                   this.chatGPTAnswer = result;
                   this.chatQueryPerformed = true;
                   this.chatGPTCount++;
               })
               .catch(error => {
                   this.error = error;
                   console.log('Error: ' + error);
                   this.chatGPTAnswer = error;
                   this.displayLoadingIcon = false;
               });
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