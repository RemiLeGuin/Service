/**
 * @author Rémi Le Guin
 * @date 20/12/2019
 * @description Trigger handlers setting a technical field storing the Form Community's URL for the current instance.
 */
public with sharing class Service_FormCommunityHandler implements Callable {

    /**
     * @description Set a technical field storing the Form Community's URL for the current instance.
     * @param cases A list of cases.
     * @return A message stating the method execution.
     */
    private static String setFormCommunityUrl(List<Case> cases) {
        if (Schema.SObjectType.Case.Fields.FormCommunityUrl__c.isUpdateable()) {
            for (Case cs : cases) {
                if (cs.Origin == 'Email'
                    && (cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS
                        || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS
                        || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS
                        || cs.RecordTypeId == Service_CaseUtilities.RECORDTYPEID_SERVICES)) {
                    Id formNetworkId = [SELECT Id FROM Network WHERE Name = 'Form' LIMIT 1][0].Id;
                    cs.FormCommunityUrl__c = Network.getLoginUrl(formNetworkId).removeEndIgnoreCase('login');
                }
            }
        }
        return 'Method executed: Service_FormCommunityHandler.setFormCommunityUrl';
    }

    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @param action The behavior for the method to exhibit.
     * @param arguments Arguments to be used by the specified action.
     * @return The result of the method invocation.
     */
    public Object call(String action, Map<String, Object> arguments) {
        switch on action {
            when 'setFormCommunityUrl' {
                return setFormCommunityUrl((List<Case>)arguments.get('parameter1'));
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