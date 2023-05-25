/**
 * Created by catalinalexandrutanasie on 05.05.23.
 */

public with sharing class NTTChatGPTOperations {

    public static String getChatGPTTriviaResponse(Boolean extractCityNameOnly, String triviaHints, List<String> triviaAnswerChoicesList) {
        NTTChatGPTComponents.NTTChatGPTRequest chatGPTRequest = new NTTChatGPTComponents.NTTChatGPTRequest();
        chatGPTRequest.model = NTTChatGPTConstants.CHAT_GPT_MODEL;
        chatGPTRequest.temperature = NTTChatGPTConstants.CHAT_GPT_TEMPERATURE;
        chatGPTRequest.messages.add(NTTChatGPTOperations.getChatGPTRequestMessageItemForTriviaHints(NTTChatGPTConstants.CHAT_DIALOG_PREFIX + triviaHints));
        NTTChatGPTComponents.NTTChatGPTResponse chatGPTResponse = NTTChatGPTClient.getChatGPTCompletions(chatGPTRequest);
        if (chatGPTResponse.choices != null && chatGPTResponse.choices.size() > 0) {
            for (NTTChatGPTComponents.NTTChatGPTChoice currentResponseChoice : chatGPTResponse.choices) {
                return NTTChatGPTOperations.parseChatGPTResponse(extractCityNameOnly, currentResponseChoice?.message?.content, triviaAnswerChoicesList);
            }
        } else if (chatGPTResponse.error != null && String.isNotBlank(chatGPTResponse.error.message)) {
            return chatGPTResponse.error.message;
        }
        return NTTChatGPTConstants.INCORRECT_CHAT_GPT_GUESS;
    }

    private static NTTChatGPTComponents.NTTChatGPTMessage getChatGPTRequestMessageItemForTriviaHints(String triviaHint) {
        NTTChatGPTComponents.NTTChatGPTMessage requestMessage = new NTTChatGPTComponents.NTTChatGPTMessage();
        requestMessage.role = NTTChatGPTConstants.CHAT_GPT_USER_ROLE;
        requestMessage.content = triviaHint;
        return requestMessage;
    }

    private static String parseChatGPTResponse(Boolean extractCityNameOnly, String chatGPTAnswerContent, List<String> choices) {
        if (String.isNotBlank(chatGPTAnswerContent)) {
            if (extractCityNameOnly) {
                for (String currentCity : choices) {
                    if (chatGPTAnswerContent.containsIgnoreCase(currentCity)) {
                        return currentCity;
                    }
                }
            } else {
                return chatGPTAnswerContent;
            }
        }
        return NTTChatGPTConstants.INCORRECT_CHAT_GPT_GUESS;
    }
}