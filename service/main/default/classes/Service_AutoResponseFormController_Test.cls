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
            'ProfileId' => formProfileId,
			'BypassedObjectRestrictions__c' => 'Case (Edit)'
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

		System.runAs(guestUser) {
			Case cs = (Case)TDF.createSObject('Case', new Map<String,Object> {
				'RecordTypeId' => Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS,
				'Origin' => 'Email',
				'Priority' => 'Low',
				'OwnerId' => Service_CaseUtilities.SERVICEQUEUEIDSBYDEVELOPERNAME.get('Service_PublicDeals'),
				'SuppliedEmail' => 'test@email.com'
			});
		}
    }

	/**
	 * @description Test the getAutoResponseFormDisplayByFloor method when user has access to the AutoResponseFormDisplay__mdt custom metadata.
	 */
	@IsTest
	private static void getRecordTypeNameById_TestNoRT() {
        User guestUser = [SELECT Id FROM User WHERE Username = 'guestuser@form.fr' LIMIT 1];

		Id recordTypeDeveloperName;
		Test.startTest();
		System.runAs(guestUser) {
			recordTypeDeveloperName = Service_AutoResponseFormController.getRecordTypeNameById('000000000000000000');
		}
		Test.stopTest();

		System.assertEquals(null, recordTypeDeveloperName);
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
	@IsTest
	private static void updateCase_TestSuccess() {
		User guestUser = [SELECT Id FROM User WHERE Username = 'guestuser@form.fr' LIMIT 1];
		Case cs = [SELECT Id FROM Case LIMIT 1];
		Map<String, Object> fields = new Map<String, Object> ();
		fields.put('RequestType__c', 'Duplicata');
		fields.put('RequestSubtype__c', 'Factures/Avoirs');
		fields.put('VehicleRegistrationNumber__c', '123-AB-00');

		String returnMessage;
		Test.startTest();
		System.runAs(guestUser) {
			returnMessage = Service_AutoResponseFormController.updateCase(cs.Id, fields);
		}
		Test.stopTest();

		System.assertEquals('Success', returnMessage, 'The update failed.');
		cs = [SELECT RequestType__c, RequestSubtype__c, VehicleRegistrationNumber__c FROM Case LIMIT 1];
		System.assertEquals('Duplicata', cs.RequestType__c, 'Wrong value set for Case\'s request type.');
		System.assertEquals('Factures/Avoirs', cs.RequestSubtype__c, 'Wrong value set for Case\'s sub request type.');
		System.assertEquals('123-AB-00', cs.VehicleRegistrationNumber__c, 'Wrong value set for Case\'s vehicle registration number.');
	}
    
}