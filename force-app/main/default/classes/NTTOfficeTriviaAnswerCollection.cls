/**
 * Created by catalinalexandrutanasie on 16.05.23.
 */

global with sharing class NTTOfficeTriviaAnswerCollection {
    @AuraEnabled
    @InvocableVariable
    global String triviaSessionKey;

    @AuraEnabled
    @InvocableVariable
    global Integer chatGPTCount;

    @AuraEnabled
    @InvocableVariable
    global List<NTTOfficeTriviaAnswer> triviaAnswers;
    global NTTOfficeTriviaAnswerCollection() {}
}