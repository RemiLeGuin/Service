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

    public static final Map<Id, String> QUEUEDEVELOPERNAMESBYID;
    public static final Map<String, Id> QUEUEIDSBYDEVELOPERNAME;

    static {
        QUEUEDEVELOPERNAMESBYID = getQueueDeveloperNamesById();
        QUEUEIDSBYDEVELOPERNAME = getQueueIdsByDeveloperNames();
    }

    /**
    * @description Get queue developer names by ID.
    * @return A map of queue developer names by ID.
    */
    private static Map<Id, String> getQueueDeveloperNamesById() {
        Map<Id, String> queueDeveloperNamesById = new Map<Id, String> ();
        for (Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']) {
            queueDeveloperNamesById.put(queue.Id, queue.DeveloperName);
        }
        return queueDeveloperNamesById;
    }

    /**
    * @description Get queue IDs by developer name.
    * @return A map of queue IDs by developer name.
    */
    private static Map<String, Id> getQueueIdsByDeveloperNames() {
        Map<String, Id> queueIdsByDeveloperNames = new Map<String, Id> ();
        for (Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']) {
            queueIdsByDeveloperNames.put(queue.DeveloperName, queue.Id);
        }
        return queueIdsByDeveloperNames;
    }

}