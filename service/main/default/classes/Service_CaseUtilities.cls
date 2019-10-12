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

}