/**
 * Created by catalinalexandrutanasie on 19.04.23.
 */

public with sharing class NTTTriviaAnswerScoreSelector {
    public static Trivia_Answer_Score__c getScoreSpecForTotalScorePoints(Integer totalScore) {
        for (Trivia_Answer_Score__c tas : [SELECT Score_Points__c, Feedback__c FROM Trivia_Answer_Score__c WHERE Score_Points__c = :totalScore LIMIT 1]) {
            return tas;
        }
        return null;
    }
}