/**
 * Created by catalinalexandrutanasie on 19.04.23.
 */

public with sharing class NTTOfficeTriviaServiceOperations {

    private static final String MULTIVALUE_PICKLIST_SEPARATOR = ';';
    private static final String TEST_RUN_HEADER_KEY = 'Test-Run';
    private static final String TRUE_VAL = 'true';
    private static final String DML_ERROR_CODE = 'DML_ERR';
    private static final String DML_ERROR_MESSAGE = 'An error occurred while trying to process and save your response. Please make sure the format of the request is valid.';
    private static final String NO_KEY_PROVIDED_ERROR_CODE = 'NO_KEY_PROVIDED';
    private static final String NO_KEY_PROVIDED_ERROR_MESSAGE = 'Please provide a the session key obtained in the response with the trivia questions list.';
    private static final String INVALID_KEY_PROVIDED_ERROR_CODE = 'INVALID_KEY_PROVIDED';
    private static final String INVALID_KEY_PROVIDED_ERROR_MESSAGE = 'Please provide a VALID session key obtained in the response with the trivia questions list. The current one matched no record in the system.';
    private static final String UNKNOWN_TEAM_NAME = 'Team Anonymous';
    private static final String CONTESTANT_HEADER_KEY = 'Contestant';

    public static NTTOfficeTriviaServiceComponents.NTTOfficeListQuestionsResponse compileRandomizedQuestionList(Map<String, String> requestHeadersMap) {
        NTTOfficeTriviaServiceComponents.NTTOfficeListQuestionsResponse response = new NTTOfficeTriviaServiceComponents.NTTOfficeListQuestionsResponse();
        Map<Id, Office__c> officeReferenceMap = NTTOfficeSelector.getOfficeReferenceMap(NTTOfficeTriviaServiceOperations.isTestContext(requestHeadersMap));
        List<Office__c> officeTriviaList = officeReferenceMap.values();
        Map<Id, List<String>> officeImagesPublicUrlMap = NTTOfficeTriviaServiceOperations.getPublicImageURLMapForOfficeSet(officeReferenceMap.keySet());
        Office__c currentOffice;
        Integer currentOfficeIndex;
        do {
            currentOfficeIndex = NTTOfficeTriviaServiceOperations.getRandomIndex(officeTriviaList.size());
            currentOffice = officeTriviaList.get(currentOfficeIndex);
            response.triviaQuestionList.add(new NTTOfficeTriviaServiceComponents.NTTOfficeListQuestionsResponseItem(
                    EncodingUtil.base64Encode(Blob.valueOf(currentOffice.Id)),
                    NTTOfficeTriviaServiceOperations.getRandomizedAnswerList(currentOffice.Locations_List__c.split(MULTIVALUE_PICKLIST_SEPARATOR)),
                    officeImagesPublicUrlMap.containsKey(currentOffice.Id) ? officeImagesPublicUrlMap.get(currentOffice.Id) : null,
                    currentOffice.Trivia__c));
            officeTriviaList.remove(currentOfficeIndex);
        } while (!officeTriviaList.isEmpty());
        response.triviaSessionKey = EncodingUtil.base64Encode(Crypto.generateAesKey(128));
        NTTOfficeTriviaServiceOperations.provisionTriviaAnswerAndSession(response.triviaSessionKey,
                NTTOfficeTriviaServiceOperations.getContestantTeamName(requestHeadersMap),
                NTTOfficeTriviaServiceOperations.isTestContext(requestHeadersMap));
        return response;
    }

    public static NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse compileScoreForSessionAnswerSet(NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerRequest triviaAnswerRequest) {
        try {
            Trivia_Answer__c triviaAnswer;
            if (String.isBlank(triviaAnswerRequest.triviaSessionKey)) {
                return new NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse(
                        new NTTOfficeTriviaServiceComponents.NTTOfficeFault(NTTOfficeTriviaServiceOperations.NO_KEY_PROVIDED_ERROR_CODE,
                                NTTOfficeTriviaServiceOperations.NO_KEY_PROVIDED_ERROR_MESSAGE));
            } else {
                triviaAnswer = NTTTriviaAnswerSelector.getProvisionedAnswerForSessionKey(triviaAnswerRequest.triviaSessionKey);
                if (triviaAnswer == null) {
                    return new NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse(
                            new NTTOfficeTriviaServiceComponents.NTTOfficeFault(NTTOfficeTriviaServiceOperations.INVALID_KEY_PROVIDED_ERROR_CODE,
                                    NTTOfficeTriviaServiceOperations.INVALID_KEY_PROVIDED_ERROR_MESSAGE));
                } else {
                    Map<Id, String> decodedAnswerMap = NTTOfficeTriviaServiceOperations.translateEncodedAnswerMap(triviaAnswerRequest.answerMap);
                    Integer totalAnswerScore = NTTOfficeTriviaServiceOperations.compileAnswerScore(decodedAnswerMap, triviaAnswer.Is_Test_Run__c);
                    Trivia_Answer_Score__c triviaAnswerScore = NTTTriviaAnswerScoreSelector.getScoreSpecForTotalScorePoints(totalAnswerScore);
                    return new NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse(NTTTriviaAnswerBuilder.getBuilder(triviaAnswer)
                            .setAnswerMap(decodedAnswerMap)
                            .setTriviaAnswerScoreId(triviaAnswerScore?.Id)
                            .setChatGPTCount(triviaAnswerRequest.chatGPTCount)
                            .setTriviaAnswerScore(triviaAnswerScore)
                            .updateRecord());
                }
            }

        } catch (DmlException dEx) {
            return new NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse(
                    new NTTOfficeTriviaServiceComponents.NTTOfficeFault(NTTOfficeTriviaServiceOperations.DML_ERROR_CODE,
                            NTTOfficeTriviaServiceOperations.DML_ERROR_MESSAGE));
        } catch (Exception ex) {
            return new NTTOfficeTriviaServiceComponents.NTTOfficeTriviaAnswerResponse(
                    new NTTOfficeTriviaServiceComponents.NTTOfficeFault(ex.getTypeName(),
                            ex.getMessage()));
        }
    }

    private static void provisionTriviaAnswerAndSession(String triviaSessionKey, String teamName, Boolean isTestContext) {
        NTTTriviaAnswerBuilder.getBuilder()
                .setTestContext(isTestContext)
                .setSessionKey(triviaSessionKey)
                .setContestant(teamName)
                .insertRecord();
    }

    private static List<String> getRandomizedAnswerList(List<String> officeLocationsList) {
        List<String> randomizedAnswerList = new List<String> ();
        Integer currentAnswerIndex;
        do {
            currentAnswerIndex = NTTOfficeTriviaServiceOperations.getRandomIndex(officeLocationsList.size());
            randomizedAnswerList.add(officeLocationsList.get(currentAnswerIndex));
            officeLocationsList.remove(currentAnswerIndex);
        } while (!officeLocationsList.isEmpty());
        return randomizedAnswerList;
    }

    private static Integer getRandomIndex(Integer max) {
        return Math.mod(Math.round(Math.random() * max + 1), max);
    }

    private static Map<Id, String> translateEncodedAnswerMap(Map<String, String> encodedAnswerMap) {
        Map<Id, String> decodedAnswerMap = new Map<Id, String> ();
        for (String currentEncodedKey : encodedAnswerMap.keySet()) {
            decodedAnswerMap.put(String.valueOf(EncodingUtil.base64Decode(currentEncodedKey).toString()), encodedAnswerMap.get(currentEncodedKey));
        }
        return decodedAnswerMap;
    }

    private static Integer compileAnswerScore(Map<Id, String> decodedAnswerMap, Boolean isTestRun) {
        Integer totalAnswerScore = 0;
        Map<Id, Office__c> officeReferenceMap = NTTOfficeSelector.getOfficeReferenceMap(isTestRun);
        for (Id currentAnswerId : officeReferenceMap.keySet()) {
            totalAnswerScore += decodedAnswerMap.containsKey(currentAnswerId)
                    && decodedAnswerMap.get(currentAnswerId) == officeReferenceMap.get(currentAnswerId).City__c ? 1 : 0;
        }
        return totalAnswerScore;
    }

    private static Map<Id, List<String>> getPublicImageURLMapForOfficeSet(Set<Id> officeIdSet) {
        Map<Id, List<String>> returnedMap = new Map<Id, List<String>> ();
        List<String> currentPublicURLList;
        Map<Id, Id> contentDocumentOfficeMap = new Map<Id, Id> ();
        for (ContentDocumentLink currentCDLink : NTTContentDocumentLinkSelector.getContentDocumentLinksForRecordSet(officeIdSet)) {
            contentDocumentOfficeMap.put(currentCDLink.ContentDocumentId, currentCDLink.LinkedEntityId);
        }
        for (ContentDistribution currentCDistribution : NTTContentDistributionSelector.getPublicLinksForContent(new Set<Id>(contentDocumentOfficeMap.keySet()))) {
            if (!returnedMap.containsKey(contentDocumentOfficeMap.get(currentCDistribution.ContentDocumentId))) {
                currentPublicURLList = new List<String> ();
                returnedMap.put(contentDocumentOfficeMap.get(currentCDistribution.ContentDocumentId), currentPublicURLList);
            } else {
                currentPublicURLList = returnedMap.get(contentDocumentOfficeMap.get(currentCDistribution.ContentDocumentId));
            }
            currentPublicURLList.add(currentCDistribution.DistributionPublicUrl);
        }
        return returnedMap;
    }

    private static Boolean isTestContext(Map<String, String> requestHeadersMap) {
        return requestHeadersMap == null
                || requestHeadersMap.isEmpty()
                || !requestHeadersMap.containsKey(NTTOfficeTriviaServiceOperations.TEST_RUN_HEADER_KEY)
                || String.isEmpty(requestHeadersMap.get(NTTOfficeTriviaServiceOperations.TEST_RUN_HEADER_KEY))
                || requestHeadersMap.get(NTTOfficeTriviaServiceOperations.TEST_RUN_HEADER_KEY) == NTTOfficeTriviaServiceOperations.TRUE_VAL;
    }

    private static String getContestantTeamName(Map<String, String> requestHeadersMap) {
        if (requestHeadersMap != null
                && !requestHeadersMap.isEmpty()
                && requestHeadersMap.containsKey(NTTOfficeTriviaServiceOperations.CONTESTANT_HEADER_KEY)
                && String.isNotBlank(requestHeadersMap.get(NTTOfficeTriviaServiceOperations.CONTESTANT_HEADER_KEY))) {
            return requestHeadersMap.get(NTTOfficeTriviaServiceOperations.CONTESTANT_HEADER_KEY);
        }
        return NTTOfficeTriviaServiceOperations.UNKNOWN_TEAM_NAME;
    }
}