/**
 * Created by catalinalexandrutanasie on 27.04.23.
 */

public with sharing class NTTContentDistributionSelector {
    public static List<ContentDistribution> getPublicLinksForContent(Set<Id> contentDocumentIdSet) {
        return [SELECT ContentDocumentId, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentDocumentId IN :contentDocumentIdSet];
    }
}