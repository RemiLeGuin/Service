/**
 * @author Rémi Le Guin
 * @date 16/10/2019
 * @description Test class for the handler class for the form response sending on case creation whithin the Service package.
 */
@IsTest
private class Service_FormResponseSendingHandler_Test {

    /**
     * @description Test the setSendForm method when creating Major Accounts Cases.
     */
    @IsTest
    private static void setSendForm_InsertMajorAccountsCasesTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_MajorAccounts'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(false, cs.SendForm__c, 'The SendForm__c field is set for a Major Accounts case');
        }
    }

    /**
     * @description Test the setSendForm method when creating Public Deals Cases.
     */
    @IsTest
    private static void setSendForm_InsertPublicDealsCasesTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_PublicDeals'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(false, cs.SendForm__c, 'The SendForm__c field is set for a Major Accounts case');
        }
    }

    /**
     * @description Test the setSendForm method when creating Restitutions Cases.
     */
    @IsTest
    private static void setSendForm_InsertRestitutionsCasesTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_Restitutions'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(true, cs.SendForm__c, 'The SendForm__c field is not set for a Service case');
        }
    }

    /**
     * @description Test the setSendForm method when creating Services Cases.
     */
    @IsTest
    private static void setSendForm_InsertServicesCasesTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_Services'),
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_SERVICES
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(true, cs.SendForm__c, 'The SendForm__c field is not set for a Service case');
        }
    }

    /**
     * @description Test the setSendForm method when creating Service Cases with a user owner.
     */
    @IsTest
    private static void setSendForm_InsertCasesNotInQueueTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'Priority' => 'Low',
            'Origin' => 'Email',
            'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_SERVICES
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(false, cs.SendForm__c, 'The SendForm__c field is set for a non-Service case');
        }
    }

    /**
     * @description Test the setSendForm method when creating non-Service Cases.
     */
    @IsTest
    private static void setSendForm_InsertOtherCasesTest() {
        Test.startTest();
        Caller.bypassAllExcept(new List<String> { 'SetSendFormInsert' }, 'Case');
        List<Case> cases = TDF.createSObjectList('Case', new Map<String, Object> {
            'Priority' => 'Low',
            'Origin' => 'Email'
        }, 210, true);
        Test.stopTest();

        cases = [SELECT SendForm__c FROM Case];
        for (Case cs : cases) {
            System.assertEquals(false, cs.SendForm__c, 'The SendForm__c field is set for a non-Service case');
        }
    }

    /**
     * @description Test the call of a non-existing method.
     */
    @IsTest
    private static void testNonImplementedMethod() {
        String exceptionThrown;
        
        Test.startTest();
        try {
            Callable callableClass = (Callable)Type.forName('Service_FormResponseSendingHandler').newInstance();
            callableClass.call('nonImplementedMethod', new Map<String, Object>());
        }
        catch (Exception e) {
            exceptionThrown = e.getMessage();
        }
        Test.stopTest();
        
        System.assertEquals('Method not implemented', exceptionThrown, 'No exception thrown for method not implemented');
    }

}