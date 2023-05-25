/**
 * Created by catalinalexandrutanasie on 04.05.23.
 */

public with sharing class NTTChatGPTClient {
    public static NTTChatGPTComponents.NTTChatGPTResponse getChatGPTCompletions(NTTChatGPTComponents.NTTChatGPTRequest chatRequestMessage) {
        Http chatService = new Http();
        HttpRequest chatRequest = new HttpRequest();
        chatRequest.setMethod(NTTChatGPTConstants.POST_METHOD);
        System.debug(JSON.serializePretty(chatRequestMessage));
        chatRequest.setBody(JSON.serializePretty(chatRequestMessage));
        chatRequest.setEndpoint(NTTChatGPTConstants.CHAT_GPT_NAMED_CREDENTIAL_PATH + NTTChatGPTConstants.CHAT_GPT_COMPLETIONS_METHOD_PATH);
        HttpResponse chatResponse = chatService.send(chatRequest);
        return (NTTChatGPTComponents.NTTChatGPTResponse)JSON.deserializeStrict(
                NTTChatGPTComponents.replaceReservedKeywordsBeforeDeserialization(chatResponse.getBody()),
                NTTChatGPTComponents.NTTChatGPTResponse.class);
    }
}