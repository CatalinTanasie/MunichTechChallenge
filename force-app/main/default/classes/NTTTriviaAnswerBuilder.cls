/**
 * Created by catalinalexandrutanasie on 19.04.23.
 */

public with sharing class NTTTriviaAnswerBuilder {
    private Trivia_Answer__c record;
    private NTTTriviaAnswerBuilder() {
        this.record = new Trivia_Answer__c();
    }

    private NTTTriviaAnswerBuilder(Trivia_Answer__c answer) {
        this.record = answer;
    }

    public static NTTTriviaAnswerBuilder getBuilder() {
        return new NTTTriviaAnswerBuilder();
    }

    public static NTTTriviaAnswerBuilder getBuilder(Trivia_Answer__c answer) {
        return new NTTTriviaAnswerBuilder(answer);
    }

    public NTTTriviaAnswerBuilder setChatGPTCount(Integer chatGPTCount) {
        this.record.Chat_GPT_Attempts__c = Decimal.valueOf(chatGPTCount);
        return this;
    }

    public NTTTriviaAnswerBuilder setSessionKey(String sessionKey) {
        this.record.Session_Key__c = sessionKey;
        return this;
    }

    public NTTTriviaAnswerBuilder setContestant(String contestant) {
        this.record.Contestant__c = contestant;
        return this;
    }

    public NTTTriviaAnswerBuilder setTriviaAnswerScoreId(Id answerScoreId) {
        this.record.Trivia_Answer_Score__c = answerScoreId;
        return this;
    }

    public NTTTriviaAnswerBuilder setTriviaAnswerScore(Trivia_Answer_Score__c tas) {
        this.record.Trivia_Answer_Score__r = tas;
        return this;
    }

    public NTTTriviaAnswerBuilder setAnswerMap(Map<Id, String> answerMap) {
        this.record.Answers__c = String.valueOf(answerMap);
        return this;
    }

    public NTTTriviaAnswerBuilder setTestContext(Boolean isTestContext) {
        this.record.Is_Test_Run__c = isTestContext;
        return this;
    }

    public Trivia_Answer__c insertRecord() {
        insert this.record;
        return this.record;
    }

    public Trivia_Answer__c updateRecord() {
        upsert this.record;
        return this.record;
    }
}