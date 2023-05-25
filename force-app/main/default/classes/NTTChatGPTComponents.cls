/**
 * Created by catalinalexandrutanasie on 05.05.23.
 */

public with sharing class NTTChatGPTComponents {
    public class NTTChatGPTRequest {
        public String model { get; set; }
        public List<NTTChatGPTMessage> messages {
            get {
                if (messages == null) {
                    messages = new List<NTTChatGPTMessage>();
                }
                return messages;
            }
            set;
        }
        public Decimal temperature { get; set; }
    }

    public class NTTChatGPTResponse {
        public String id { get; set; }
        public String object_res { get; set; }
        public Long created { get; set; }
        public String model {get; set;}
        public List<NTTChatGPTChoice> choices { get; set; }
        public NTTChatGPTUsage usage { get; set; }
        public NTTChatGPTError error {get; set;}
    }

    public class NTTChatGPTError {
        public String message {get; set;}
        public String code {get; set;}
        public String type_res {get; set;}
        public String param {get; set;}
    }

    public class NTTChatGPTChoice {
        public Integer index { get; set; }
        public NTTChatGPTMessage message { get; set; }
        public String finish_reason { get; set; }
    }

    public class NTTChatGPTUsage {
        public Integer prompt_tokens { get; set; }
        public Integer completion_tokens { get; set; }
        public Integer total_tokens { get; set; }
    }

    public class NTTChatGPTMessage {
        public String role { get; set; }
        public String content { get; set; }
    }

    public static String replaceReservedKeywordsBeforeDeserialization(String unprocessedJson) {
        System.debug('### Raw response: ' + unprocessedJson);
        return unprocessedJson.replace(NTTChatGPTConstants.CHAT_GPT_JSON_RESERVED_OBJECT_STRING, NTTChatGPTConstants.SALESFORCE_JSON_VALID_OBJECT_STRING)
                .replace(NTTChatGPTConstants.CHAT_GPT_JSON_RESERVED_TYPE_STRING, NTTChatGPTConstants.SALESFORCE_JSON_VALID_TYPE_STRING);
    }
}