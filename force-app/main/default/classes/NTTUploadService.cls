public with sharing class NTTUploadService {
    private static final String MESSAGE_INRUT_VALUES_EMPTY = 'Please, check your file';
    private static final String MESSAGE_UPLOADED_SUCCEESSFULLY = 'The image has been uploaded successfully';
    
    @AuraEnabled
    public static String uploadFile(String fileName, String base64) {
        if (String.isBlank(fileName) || String.isBlank(base64)) return MESSAGE_INRUT_VALUES_EMPTY;

        String contentVersionId = createContentVersion(fileName, base64);
        return MESSAGE_UPLOADED_SUCCEESSFULLY;
    }

    private static String createContentVersion(String fileName, String base64) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.VersionData = EncodingUtil.base64Decode(base64);
        contentVersion.Title = fileName;
        contentVersion.PathOnClient = fileName;
        return insertFile(contentVersion);
    }

    private static String insertFile(SObject sObjectToInsert) {
        try {
            insert sObjectToInsert;
            return sObjectToInsert.Id;
        } catch (DmlException e) {
            throw new UploadServiceException(e.getDmlMessage(0));
        }
    }

    public class UploadServiceException extends Exception {}
}