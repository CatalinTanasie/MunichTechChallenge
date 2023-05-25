/**
 * Created by catalinalexandrutanasie on 19.04.23.
 */

public with sharing class NTTOfficeSelector {
    public static Map<Id, Office__c> getOfficeReferenceMap(Boolean isTestContextRun) {
        Map<Id, Office__c> officeMap = new Map<Id, Office__c> ();
        for (Office__c currentOffice : [SELECT Name, City__c, Locations_List__c, Trivia__c FROM Office__c WHERE Is_Test_Run__c = :isTestContextRun]) {
            officeMap.put(currentOffice.Id, currentOffice);
        }
        return officeMap;
    }
}