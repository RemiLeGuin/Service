/**
 * @author Rémi Le Guin
 * @date Creation 22/11/2019
 * @description Test class for the Auto-Response Form's Controller.
 */
@IsTest
private class Service_AutoResponseFormController_Test {

    @TestSetup
    private static void setup() {
        Id formProfileId = [SELECT Id FROM Profile WHERE Name = 'Form Profile' LIMIT 1][0].Id;

        User guestUser = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Guest',
            'LastName' => 'User',
            'Alias' => 'guest',
            'Email' => 'guestuser@form.fr',
            'Username' => 'guestuser@form.fr',
            'CommunityNickname' => 'guestuser',
            'ProfileId' => formProfileId
        });
        Id autoResponseFormPermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Service_AutoResponseForm' LIMIT 1][0].Id;
        insert new PermissionSetAssignment (PermissionSetId = autoResponseFormPermissionId, AssigneeId = guestUser.Id);
        Id coreUserPermissionId = [SELECT Id FROM PermissionSet WHERE Name = 'Core_User' LIMIT 1][0].Id;
        insert new PermissionSetAssignment (PermissionSetId = coreUserPermissionId, AssigneeId = guestUser.Id);

        User unauthorizedUser = (User)TDF.createSObject('User', new Map<String,Object> {
            'FirstName' => 'Unauthorized',
            'LastName' => 'User',
            'Alias' => 'unauth',
            'Email' => 'unauthorizeduser@form.fr',
            'Username' => 'unauthorizeduser@form.fr',
            'CommunityNickname' => 'unauthorizeduser',
            'ProfileId' => formProfileId
        });
    }

	/**
	 * @description Test the getAutoResponseFormDisplayByFloor method when user has access to the AutoResponseFormDisplay__mdt custom metadata.
	 */
	@IsTest
	private static void getAutoResponseFormDisplayByFloor_TestSuccess() {
        User guestUser = [SELECT Id FROM User WHERE Username = 'guestuser@form.fr' LIMIT 1];

		AutoResponseFormDisplay__mdt display;
		Test.startTest();
		System.runAs(guestUser) {
			display = Service_AutoResponseFormController.getAutoResponseFormDisplayByFloor('TestFloor');
		}
		Test.stopTest();

		System.assertEquals('TestVisibleField', display.VisibleFields__c, 'Wrong or no metadata retrieved');
		System.assertEquals('TestRequiredField', display.RequiredFields__c, 'Wrong or no metadata retrieved');
	}

	/**
	 * @description Test the getAutoResponseFormDisplayByFloor method when user has not access to the AutoResponseFormDisplay__mdt custom metadata.
	 */
    // The test method is deactivated for now because scratch orgs automatically created do not enforce CRUD on custom metadata.
    // On February 2020, direct access to a custom metadata will have to be granted.
    /*
	@IsTest
	private static void getAutoResponseFormDisplayByFloor_TestError() {
        User guestUser = [SELECT Id FROM User WHERE Username = 'unauthorizeduser@form.fr' LIMIT 1];

		AutoResponseFormDisplay__mdt display;
		Test.startTest();
		System.runAs(guestUser) {
			display = Service_AutoResponseFormController.getAutoResponseFormDisplayByFloor('TestFloor');
		}
		Test.stopTest();

		System.assertEquals(null, display, 'Metadata retrieved while it should not');
	}
    */
	/**
	 * @description Test the updateCase method when success.
	 */
    /*
	@IsTest
	private static void updateCase_TestSuccess() {
		Account entitlementHandler = new Account(Name = 'Entitlement Handler');
		insert entitlementHandler;
		insert new Entitlement(Name = 'F2ML - Public Deals Priority', AccountId = entitlementHandler.Id);
		Id publicDealsQueueId = EM016_GroupOrQueue.getQueuesIdByDevNamePrefix('F2ML_MarchesPublics').values() [0];
		Case cs = new Case(RecordTypeId = EM006_Case.RECORDTYPE_F2MLPublicDeals,
		                   Origin = 'Email',
		                   Priority = 'Low',
		                   OwnerId = publicDealsQueueId,
		                   SuppliedEmail = 'test@email.com');
		insert cs;
		Map<String, Object> fields = new Map<String, Object> ();
		fields.put('SenderType__c', 'Customer');
		fields.put('F2MLRequestType__c', 'Duplicata');
		fields.put('AgreementNumber__c', '123');

		String returnMessage;
		Test.startTest();
		returnMessage = LWCC001_AutoResponseForm.updateCase(cs.Id, fields);
		Test.stopTest();

		System.assertEquals('Success', returnMessage, 'The update failed.');
		cs = [SELECT SenderType__c, F2MLRequestType__c, AgreementNumber__c FROM Case LIMIT 1];
		System.assertEquals('Customer', cs.SenderType__c, 'Wrong value set for Case\'s sender type.');
		System.assertEquals('Duplicata', cs.F2MLRequestType__c, 'Wrong value set for Case\'s request type.');
		System.assertEquals('123', cs.AgreementNumber__c, 'Wrong value set for Case\'s agreement number.');
	}
    */
	/**
	 * @description Test the updateCase method when error.
	 */
    /*
	@IsTest
	private static void updateCase_TestError() {
		Account entitlementHandler = new Account(Name = 'Entitlement Handler');
		insert entitlementHandler;
		insert new Entitlement(Name = 'F2ML - Public Deals Priority', AccountId = entitlementHandler.Id);
		Id publicDealsQueueId = EM016_GroupOrQueue.getQueuesIdByDevNamePrefix('F2ML_MarchesPublics').values() [0];
		Case cs = new Case(RecordTypeId = EM006_Case.RECORDTYPE_F2MLPublicDeals,
		                   Origin = 'Email',
		                   Priority = 'Low',
		                   OwnerId = publicDealsQueueId,
		                   SuppliedEmail = 'test@email.com');
		insert cs;
		Map<String, Object> fields = new Map<String, Object> ();
		fields.put('SenderType__c', 'Customer');
		fields.put('F2MLRequestType__c', 'Duplicata');
		fields.put('RRDICode__c', 'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');

		String returnMessage;
		Test.startTest();
		returnMessage = LWCC001_AutoResponseForm.updateCase(cs.Id, fields);
		Test.stopTest();

		System.assert(returnMessage != 'Success' , 'Too long input validated.');
	}
    */
}