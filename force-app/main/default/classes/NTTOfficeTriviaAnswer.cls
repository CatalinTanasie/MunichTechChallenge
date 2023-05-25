/**
 * Created by catalinalexandrutanasie on 05.05.23.
 */

global with sharing class NTTOfficeTriviaAnswer {
    @AuraEnabled
    @InvocableVariable
    global String triviaQuestionKey;
    @AuraEnabled
    @InvocableVariable
    global String triviaQuestionAnswer;

    global NTTOfficeTriviaAnswer() {}
}