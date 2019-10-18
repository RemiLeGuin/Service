/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Test class for the utility class for the Case standard object whithin the Service package.
*/
@IsTest
private class Service_CaseUtilities_Test {

    /**
    * @description Test the constants fetching Service record type IDs.
    */
    @IsTest
    private static void getRecordTypesId_Test() {
        Id recordTypeId_MajorAccounts = Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS;
        Id recordTypeId_PublicDeals = Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS;
        Id recordTypeId_Restitutions = Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS;
        Id recordTypeId_Services = Service_CaseUtilities.RECORDTYPEID_SERVICES;

        Map<Id, Schema.RecordTypeInfo> caseRecordTypeInfosById = Schema.SObjectType.Case.getRecordTypeInfosById();
        System.assertEquals('Service_MajorAccounts', caseRecordTypeInfosById.get(recordTypeId_MajorAccounts).getDeveloperName(),
                            'The ID does not refer to the Service_MajorAccounts record type');
        System.assertEquals('Service_PublicDeals', caseRecordTypeInfosById.get(recordTypeId_PublicDeals).getDeveloperName(),
                            'The ID does not refer to the Service_PublicDeals record type');
        System.assertEquals('Service_Restitutions', caseRecordTypeInfosById.get(recordTypeId_Restitutions).getDeveloperName(),
                            'The ID does not refer to the Service_Restitutions record type');
        System.assertEquals('Service_Services', caseRecordTypeInfosById.get(recordTypeId_Services).getDeveloperName(),
                            'The ID does not refer to the Service_Services record type');
    }

    /**
    * @description Test the constant fetching Queues' Developer Name by ID.
    */
    @IsTest
    private static void getQueueDeveloperNamesById_Test() {
        Map<Id, String> queuesDeveloperNameById = Service_CaseUtilities.SERVICEQUEUEDEVELOPERNAMESBYID;
        Map<Id, Group> queuesById = new Map<Id, Group> ([SELECT Id, Type FROM Group WHERE Type = 'Queue']);
        if (queuesDeveloperNameById != null && !queuesDeveloperNameById.isEmpty()) {
            for (Id queueId : queuesDeveloperNameById.keySet()) {
                System.assertEquals('Queue', queuesById.get(queueId).Type, 'The Map ID does not belong to a Queue');
            }
        }
    }

    /**
    * @description Test the constant fetching Queues' ID by Developer Name.
    */
    @IsTest
    private static void getQueueIdsByDeveloperName_Test() {
        Map<String, Id> queueIdsByDeveloperName = Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME;
        Map<String, String> groupTypesByDeveloperName = new Map<String, String> ();
        for (Group queue : [SELECT DeveloperName, Type FROM Group WHERE Type = 'Queue']) {
            groupTypesByDeveloperName.put(queue.DeveloperName, queue.Type);
        }
        if (queueIdsByDeveloperName != null && !queueIdsByDeveloperName.isEmpty()) {
            for (String queueDeveloperName : queueIdsByDeveloperName.keySet()) {
                System.assertEquals('Queue', groupTypesByDeveloperName.get(queueDeveloperName),
                                    'The ID corresponding to the Map DeveloperName does not belong to a Queue');
            }
        }
    }

}