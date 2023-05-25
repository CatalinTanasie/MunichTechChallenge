global with sharing class NTTOfficeTriviaServiceComponents {

    global class NTTOfficeListQuestionsResponse {
        global String triviaSessionKey;
        global List<NTTOfficeListQuestionsResponseItem> triviaQuestionList;
    }

    global class NTTOfficeListQuestionsResponseItem {
        global List<String> answerChoices;
        global List<String> publicImageURLList;
        global String triviaHints;
        global String questionReference;
        global NTTOfficeFault fault;
    }

    global class NTTOfficeTriviaAnswerRequest {
        global String triviaSessionKey;
        global Integer chatGPTCount;
        global Map<String,String> answerMap;
    }

    global class NTTOfficeTriviaAnswerResponse {
        global Integer score;
        global String feedback;
        global NTTOfficeFault fault;
    }

    global class NTTOfficeFault {
        global String exceptionCode;
        global String exceptionMessage;
    }
}