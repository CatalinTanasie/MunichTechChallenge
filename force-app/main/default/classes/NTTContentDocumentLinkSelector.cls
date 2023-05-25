/**
 * Created by catalinalexandrutanasie on 26.04.23.
 */

public with sharing class NTTContentDocumentLinkSelector {
    public static List<ContentDocumentLink> getContentDocumentLinksForRecordSet(Set<Id> currentRecordIdSet) {
        return [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :currentRecordIdSet];
    }
}