/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Trigger handlers setting a technical field stating whether to automatically send a form to precise the case qualification or not according to the email address the customer reached.
*/
public with sharing class Service_FormResponseSendingHandler implements Callable {

    private static Map<String, Boolean> sendFormByEmailAddress;

    /**
    * @description Set the SendForm__c technical field stating whether to automatically send a form to precise the case qualification or not according to the email address the customer reached.
    * @param cases A list of cases.
    * @return A message stating the method execution.
    */
    private static String setSendForm(List<Case> cases) {
        for (Case cs : cases) {
            if (cs.OwnerId != null && cs.OwnerId.getSobjectType() == Group.SObjectType
                && (cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS
                    || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS
                    || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS
                    || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_SERVICES)) {
                String caseQueueDeveloperName = Service_CaseUtilities.QUEUEDEVELOPERNAMESBYID.get(cs.OwnerId);
                cs.SendForm__c = Service_FormResponseSendingUtilities.SENDFORMSBYQUEUE.get(caseQueueDeveloperName);
            }
        }
        return 'Method executed: Service_FormResponseSendingHandler.setSendForm';
    }
    
    /**
    * @description Provides functionality that other classes or packages can utilize and build upon.
    * @param action The behavior for the method to exhibit.
    * @param arguments Arguments to be used by the specified action.
    * @return The result of the method invocation.
    */
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'setSendForm' {
                return setSendForm((List<Case>)arguments.get('parameter1'));
            }
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    /**
    * @description Throws new exceptions.
    */
    public class ExtensionMalformedCallException extends Exception {}

}