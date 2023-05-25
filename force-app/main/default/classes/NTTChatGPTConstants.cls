/**
 * Created by catalinalexandrutanasie on 05.05.23.
 */

public with sharing class NTTChatGPTConstants {
    public static final String CHAT_GPT_NAMED_CREDENTIAL_PATH = 'callout:ChatGPT/';
    public static final String CHAT_GPT_COMPLETIONS_METHOD_PATH = 'v1/chat/completions';
    public static final String CHAT_DIALOG_PREFIX = 'Guess the city that the following text is referring to: ';
    public static final String POST_METHOD = 'POST';
    public static final String CHAT_GPT_USER_ROLE = 'user';
    public static final String CHAT_GPT_MODEL = 'gpt-3.5-turbo';
    public static final Decimal CHAT_GPT_TEMPERATURE = 0.7;
    public static final String INCORRECT_CHAT_GPT_GUESS = 'Other / Incorrect';
    public static final String MVP_SEPARATOR = ';';
    public static final String CHAT_GPT_JSON_RESERVED_OBJECT_STRING = '"object":';
    public static final String CHAT_GPT_JSON_RESERVED_TYPE_STRING = '"type":';
    public static final String SALESFORCE_JSON_VALID_OBJECT_STRING = '"object_res":';
    public static final String SALESFORCE_JSON_VALID_TYPE_STRING = '"type_res":';
}