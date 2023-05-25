/**
 * Created by catalinalexandrutanasie on 04.04.23.
 */

public with sharing class NTTClassifyImageAction {
    @InvocableMethod(label='Classify Images' description='Stub for adding the image classification logic (Einstein Image Classification API callout) in the flow' category='Einstein Image Classification')
    public static List<String> classifyImage(List<ID> ids) {
        String accessToken = NTTEinsteinVisionAccess.getAccessToken();
        List<ContentVersion> contentversionList =[SELECT VersionData from ContentVersion where ContentDocumentId IN: ids ] ;
       
       List< NTTEinsteinVision.Prediction>visionPredictionList =  NTTEinsteinVision.predictBlob( contentversionList[0].VersionData,  accessToken, 'beerPredictor');

        return null;
    }
}