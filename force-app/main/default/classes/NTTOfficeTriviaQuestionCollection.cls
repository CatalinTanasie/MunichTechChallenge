/**
 * Created by catalinalexandrutanasie on 16.05.23.
 */

global with sharing class NTTOfficeTriviaQuestionCollection {
    @AuraEnabled
    @InvocableVariable
    global List<NTTOfficeTriviaQuestion> triviaQuestions;
    @AuraEnabled
    @InvocableVariable
    global String triviaSessionKey;

    global NTTOfficeTriviaQuestionCollection() {}
}