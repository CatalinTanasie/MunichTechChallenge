/**
 * Created by catalinalexandrutanasie on 19.04.23.
 */

@RestResource(UrlMapping='/OfficeTrivia/*')
global with sharing class NTTOfficeTriviaService {
    @HttpGet
    global static NTTOfficeTriviaServiceComponents.NTTOfficeListQuestionsResponse getTriviaQuestions() {
        return NTTOfficeTriviaServiceOperations.compileRandomizedQuestionList(RestContext.request?.headers);
    }

    @HttpPost
    global static NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse evaluateAnswers() {
        return NTTOfficeTriviaServiceOperations.compileScoreForSessionAnswerSet(
                (NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerRequest)JSON.deserializeStrict(System.RestContext.request.requestBody.toString(),
                NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerRequest.class));
    }
}