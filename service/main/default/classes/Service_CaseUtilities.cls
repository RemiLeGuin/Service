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

    public static final Map<Id, String> SERVICEQUEUESDEVNAMEBYID;

    static {
        SERVICEQUEUESDEVNAMEBYID = getServiceQueuesDevNameById();
    }

    private static Map<Id, String> getServiceQueuesDevNameById() {
        Map<Id, String> serviceQueuesDevNameById = new Map<Id, String> ();
        for (Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName LIKE 'Service_%']) {
            serviceQueuesDevNameById.put(queue.Id, queue.DeveloperName);
        }
        return serviceQueuesDevNameById;
    }

}