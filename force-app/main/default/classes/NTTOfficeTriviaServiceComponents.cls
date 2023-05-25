global with sharing class NTTOfficeTriviaServiceComponents {

    global class NTTOfficeListQuestionsResponse {
        global String triviaSessionKey;
        global List<NTTOfficeListQuestionsResponseItem> triviaQuestionList {
            get {
                if (triviaQuestionList == null) {
                    triviaQuestionList = new List<NTTOfficeListQuestionsResponseItem> ();
                }
                return triviaQuestionList;
            }
            set;
        }
    }

    global class NTTOfficeListQuestionsResponseItem {
        global List<String> answerChoices;
        global List<String> publicImageURLList;
        global String triviaHints;
        global String questionReference;
        global NTTOfficeFault fault;

        global NTTOfficeListQuestionsResponseItem(String questionReference, List<String> answerChoices, List<String> publicImageURLList, String triviaHints) {
            this.answerChoices = answerChoices;
            this.publicImageURLList = publicImageURLList;
            this.triviaHints = triviaHints;
            this.questionReference = questionReference;
        }
    }

    global class NTTOfficeTriviaAnswerRequest {
        global String triviaSessionKey;
        global Integer chatGPTCount;
        global Map<String,String> answerMap;
    }

    global class NTTOfficeTriviaAnswerResponse {
        private final String TEST_FEEDBACK = 'This is a test. Normally, here you would see feedback based on your score.';

        global Integer score;
        global String feedback;
        global NTTOfficeFault fault;

        global NTTOfficeTriviaAnswerResponse(Trivia_Answer__c triviaAnswer) {
            this.score = Integer.valueOf(triviaAnswer.Trivia_Answer_Score__r.Score_Points__c);
            this.feedback = triviaAnswer.Is_Test_Run__c ? this.TEST_FEEDBACK : triviaAnswer.Trivia_Answer_Score__r.Feedback__c;
        }

        global NTTOfficeTriviaAnswerResponse(NTTOfficeFault fault) {
            this.fault = fault;
        }
    }

    global class NTTOfficeFault {
        global String exceptionCode;
        global String exceptionMessage;

        global NTTOfficeFault(String code, String message) {
            this.exceptionCode = code;
            this.exceptionMessage = message;
        }
    }
}