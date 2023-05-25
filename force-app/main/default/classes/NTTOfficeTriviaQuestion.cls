/**
 * Created by catalinalexandrutanasie on 05.05.23.
 */

global with sharing class NTTOfficeTriviaQuestion {
    @AuraEnabled
    @InvocableVariable
    global List<String> answerChoices;
    @AuraEnabled
    @InvocableVariable
    global List<String> publicImageURLList;
    @AuraEnabled
    @InvocableVariable
    global String triviaHints;
    @AuraEnabled
    @InvocableVariable
    global String questionReference;

    global NTTOfficeTriviaQuestion() {}
}