/**
 * Created by catalinalexandrutanasie on 09.05.23.
 */

public with sharing class NTTShowQuestionController {
    @AuraEnabled (Cacheable=true)
    public static String askChatGPTForTriviaAnswer(Boolean extractCityNameOnly, String triviaHints, List<String> triviaAnswerChoicesList) {
        return NTTChatGPTOperations.getChatGPTTriviaResponse(extractCityNameOnly, triviaHints, triviaAnswerChoicesList);
    }
}