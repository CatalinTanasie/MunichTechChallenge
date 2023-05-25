global with sharing class NTTOfficeTriviaEvaluateAnswers {

    public static String OFFICE_TRIVIA = '/services/apexrest/OfficeTrivia';

    @InvocableMethod(label='Evaluate Answers' description='Evaluate Answers from office trivia' category='Office Trivia')
    global Static List<NTTOfficeTriviaFeedback> evaluateAnswers(List<NTTOfficeTriviaAnswerCollection> triviaAnswerCollectionList) {
        NTTOfficeTriviaAnswerCollection triviaAnswerCollection = triviaAnswerCollectionList.get(0);
        Map<string, string> tokenMap = NTTOfficeTriviaClient.getAccessToken();
        NTTOfficeTriviaFeedback officeTriviafeedback = new NTTOfficeTriviaFeedback();
        HttpRequest httpRequest = new HttpRequest();

        Http h = new Http();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setHeader('Authorization', 'Bearer ' + tokenMap.get('access_token'));
        httpRequest.setEndpoint(tokenMap.get('instance_url') + OFFICE_TRIVIA);
        Map<String, String>triviaKeyAnswerMap = getMapFromList(triviaAnswerCollection.triviaAnswers);
        NTTOfficeTriviaAnswerRequest triviaReq = new NTTOfficeTriviaAnswerRequest(triviaAnswerCollection.triviaSessionKey, triviaAnswerCollection.chatGPTCount, triviaKeyAnswerMap);
        system.debug('### Request' + JSON.serialize(triviaReq));


        httpRequest.setBody(JSON.serialize(triviaReq));
        List<NTTOfficeTriviaFeedback> officetrivialist = new List<NTTOfficeTriviaFeedback>();
        try {
            HTTPResponse res = h.send(httpRequest);
            System.debug('### Response: ' + res.getBody());
            if (res.getStatusCode() == 200) {
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        officeTriviaFeedback = (NTTOfficeTriviaFeedback) parser.readValueAs(NTTOfficeTriviaFeedback.class);
                        officetrivialist.add(officeTriviaFeedback);
                        system.debug(officeTriviaFeedback);

                    }
                }
            }
        } catch (Exception e) {
            system.debug(e);
        }
        return officetrivialist;
    }

    public static Map<String, String> getMapFromList(List<NTTOfficeTriviaAnswer> triviaAnswer) {
        Map<String, String>triviaKeyMap = new Map<String, String>();
        for (NTTOfficeTriviaAnswer tr : triviaAnswer) {
            triviaKeyMap.put(tr.triviaQuestionKey, tr.triviaQuestionAnswer);
        }
        return triviaKeyMap;
    }


    global class NTTOfficeTriviaAnswerRequest {
        global String triviaSessionKey;
        global Integer chatGPTCount;
        global Map<String, String> answerMap;

        global NTTOfficeTriviaAnswerRequest(String triviaSessionKey, Integer chatGPTCount, Map<String, String> answerMap) {
            this.triviaSessionKey = triviaSessionKey;
            this.chatGPTCount = chatGPTCount;
            this.answerMap = answerMap;
        }

    }


}