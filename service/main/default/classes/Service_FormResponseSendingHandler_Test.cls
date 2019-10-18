/**
* @author Rémi Le Guin
* @date 16/10/2019
* @description Test class for the handler class for the form response sending on case creation whithin the Service package.
*/
@IsTest
private class Service_FormResponseSendingHandler_Test {

    /**
    * @description Data setup for the Service_FormResponseSendingHandler_Test class.
    */
    @TestSetup
    static void setup() {}

    /**
    * @description Test the setSendForm method when creating Cases.
    */
    @IsTest
    private static void setSendForm_InsertTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> casesMajorAccounts = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_MajorAccounts'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS
        }, 5, true);
        List<Case> casesPublicDeals = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_PublicDeals'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS
        }, 5, true);
        List<Case> casesRestitutions = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_Restitutions'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS
        }, 5, true);
        List<Case> casesServices = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_Services'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_SERVICES
        }, 5, true);
        Test.stopTest();
    }

}