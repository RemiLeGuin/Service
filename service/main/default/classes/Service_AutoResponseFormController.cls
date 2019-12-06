/**
 * @author Rémi Le Guin
 * @date Creation 08/11/2019
 * @description Service_AutoResponseFormController - Controller for the form sent by email to the customer to qualify a case.
 */
public without sharing class Service_AutoResponseFormController {

	/**
	 * @description Get the Record Type's developer name by its Salesforce ID.
	 * @param recordTypeId Salesforce Record Type ID.
	 * @return Record Type's developer name.
	 */
	@AuraEnabled(cacheable = true)
	public static String getRecordTypeNameById(Id recordTypeId) {
		RecordTypeInfo rtInfo = Schema.SObjectType.Case.getRecordTypeInfosById().get(recordTypeId);
		if (rtInfo == null) {
			return null;
		}
		else {
			return rtInfo.getDeveloperName();
		}
	}

	/**
	 * @description Get the custom metadata which displays the form's layout according to the floor.
	 * @param floor Floor's record type's developer name.
	 * @return A list of custom metadata telling the form's layout.
	 */
	@AuraEnabled(cacheable = true)
	public static AutoResponseFormDisplay__mdt getAutoResponseFormDisplayByFloor(String floor) {
		if (Schema.SObjectType.AutoResponseFormDisplay__mdt.isAccessible()
			&& AutoResponseFormDisplay__mdt.Floor__c.getDescribe().isAccessible()
			&& AutoResponseFormDisplay__mdt.VisibleFields__c.getDescribe().isAccessible()
			&& AutoResponseFormDisplay__mdt.RequiredFields__c.getDescribe().isAccessible()) {
			return [SELECT VisibleFields__c, RequiredFields__c FROM AutoResponseFormDisplay__mdt WHERE Floor__c = :floor LIMIT 1];
		}
		else {
			return null;
		}
	}

	/**
	 * @description Update the case related to the form.
	 * @param caseId Salesforce Case ID.
	 * @param fields Map of fields' developer name and their corresponding value.
	 * @return A success or error message.
	 */
	@AuraEnabled
	public static String updateCase(String caseId, Map<String, Object> fields) {
		Case cs;
		if (Schema.SObjectType.Case.isAccessible() && Case.FormCompleted__c.getDescribe().isAccessible()) {
			cs = [SELECT Id, FormCompleted__c FROM Case WHERE Id = :caseId LIMIT 1];
		}
		else {
			return Label.Service_ErrorContactCustomerServiceByPhone;
		}
		for (String stringField : fields.keySet()) {
			cs.put(stringField, fields.get(stringField));
		}
		String returnMessage;
		// If the form has already been fulfilled by the customer, a message informs the customer.
		if (cs.FormCompleted__c) {
			returnMessage = Label.Service_FormAlreadySent;
		}
		else {
			cs.FormCompleted__c = true;
			try {
				update cs;
				returnMessage = 'Success';
			}
			catch(DmlException e) {
				Integer numberOfRows = e.getNumDml();
				returnMessage = '';
				for (Integer i = 0; i<numberOfRows; i++) {
					returnMessage += e.getDmlMessage(i) + '\n';
				}
				returnMessage = returnMessage.removeEndIgnoreCase('\n');
			}
		}
		return returnMessage;
	}

}