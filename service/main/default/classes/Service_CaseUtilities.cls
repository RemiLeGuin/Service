/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Utility class for the Case standard object whithin the Service package.
*/
public with sharing class Service_CaseUtilities {

    public static final Map<String, Schema.RecordTypeInfo> caseRecordTypeInfosByDeveloperName = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName();
    public static final Id RECORDTYPEID_MAJORACCOUNTS = caseRecordTypeInfosByDeveloperName.get('Service_MajorAccounts').getRecordTypeId();
    public static final Id RECORDTYPEID_PUBLICDEALS = caseRecordTypeInfosByDeveloperName.get('Service_PublicDeals').getRecordTypeId();
    public static final Id RECORDTYPEID_RESTITUTIONS = caseRecordTypeInfosByDeveloperName.get('Service_Restitutions').getRecordTypeId();
    public static final Id RECORDTYPEID_SERVICES = caseRecordTypeInfosByDeveloperName.get('Service_Services').getRecordTypeId();

    public static final Map<Id, String> SERVICEQUEUEDEVELOPERNAMESBYID;
    public static final Map<String, Id> SERVICEQUEUEIDSBYDEVELOPERNAME;

    static {
        SERVICEQUEUEDEVELOPERNAMESBYID = getServiceQueueDeveloperNamesById();
        SERVICEQUEUEIDSBYDEVELOPERNAME = getServiceQueueIdsByDeveloperNames();
    }

    /**
    * @description Get queue developer names by ID in the Service package.
    * @return A map of queue developer names by ID in the Service package.
    */
    private static Map<Id, String> getServiceQueueDeveloperNamesById() {
        Map<Id, String> serviceQueueDeveloperNamesById = new Map<Id, String> ();
        for (Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName LIKE 'Service_%']) {
            serviceQueueDeveloperNamesById.put(queue.Id, queue.DeveloperName);
        }
        return serviceQueueDeveloperNamesById;
    }

    /**
    * @description Get queue IDs by developer name in the Service package.
    * @return A map of queue IDs by developer name in the Service package.
    */
    private static Map<String, Id> getServiceQueueIdsByDeveloperNames() {
        Map<String, Id> serviceQueueIdsByDeveloperNames = new Map<String, Id> ();
        for (Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName LIKE 'Service_%']) {
            serviceQueueIdsByDeveloperNames.put(queue.DeveloperName, queue.Id);
        }
        return serviceQueueIdsByDeveloperNames;
    }

}