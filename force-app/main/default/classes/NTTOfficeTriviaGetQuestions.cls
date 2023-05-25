global with sharing class NTTOfficeTriviaGetQuestions {
    public static String SERVER_API = 'https://login.salesforce.com';
    public static String OFFICE_TRIVIA = '/services/apexrest/OfficeTrivia';
    public NTTOfficeTriviaGetQuestions() {

    }
    @InvocableMethod(label='Get Questions' description='get questions from office trivia endpoint' category='Office Trivia')
    global Static List<NTTOfficeTriviaQuestionCollection> getQuestionsfromServer(List<Boolean> isTestRun){
        Map<string,string> tokenMap = NTTOfficeTriviaClient.getAccessToken();
        HttpRequest httpRequest = new HttpRequest();

        Http h = new Http();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Test-Run',String.valueOf(isTestRun.get(0)));
        httpRequest.setHeader('Contestant', 'Team 9');
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120000);
        httpRequest.setHeader('Authorization','Bearer ' + tokenMap.get('access_token'));
        httpRequest.setEndpoint(tokenMap.get('instance_url')+OFFICE_TRIVIA);
        system.debug('send');
        List<NTTOfficeTriviaQuestion> nttOfficeTriviaApexList = new List<NTTOfficeTriviaQuestion> ();
        NTTOfficeTriviaQuestionCollection questionCollection = new NTTOfficeTriviaQuestionCollection();
        questionCollection.triviaQuestions = nttOfficeTriviaApexList;
        try {
            HTTPResponse res = h.send(httpRequest);
            system.debug(res.getBody());
            if (res.getStatusCode() == 200) {
                JSONParser parser = JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    System.debug('### current token name: ' + parser.getCurrentName());
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while (parser.nextToken() != null) {

                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                NTTOfficeTriviaQuestion officeTriviaApex = (NTTOfficeTriviaQuestion)parser.readValueAs(NTTOfficeTriviaQuestion.class);
                                nttOfficeTriviaApexList.add(officeTriviaApex);
                            }
                        }
                    } else if (parser.getCurrentName() == 'triviaSessionKey') {
                        questionCollection.triviaSessionKey = (String)parser.readValueAs(String.class);
                    }
                }

            }
        }
        catch(Exception e){
            system.debug(e);
        }
        return new List<NTTOfficeTriviaQuestionCollection> {questionCollection};

    }

    global class NTTOfficeListQuestionsResponseItem {
        @InvocableVariable
        global List<String> answerChoices;
        @InvocableVariable
        global List<String> publicImageURLList;
        @InvocableVariable
        global String triviaHints;
        @InvocableVariable
        global String questionReference;

        global NTTOfficeListQuestionsResponseItem(String questionReference, List<String> answerChoices, List<String> publicImageURLList, String triviaHints) {
            this.answerChoices = answerChoices;
            this.publicImageURLList = publicImageURLList;
            this.triviaHints = triviaHints;
            this.questionReference = questionReference;
        }
    }




}