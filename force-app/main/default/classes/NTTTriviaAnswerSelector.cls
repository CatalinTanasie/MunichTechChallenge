/**
 * Created by catalinalexandrutanasie on 16.05.23.
 */

public with sharing class NTTTriviaAnswerSelector {
    public static Trivia_Answer__c getProvisionedAnswerForSessionKey(String sessionKey) {
        for (Trivia_Answer__c triviaAnswer : [SELECT Is_Test_Run__c FROM Trivia_Answer__c WHERE Session_Key__c = :sessionKey LIMIT 1]) {
            return triviaAnswer;
        }
        return null;
    }
}