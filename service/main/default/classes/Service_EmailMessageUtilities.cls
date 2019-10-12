/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Utility class for the Email Message standard object whithin the Service package.
*/
public with sharing class Service_EmailMessageUtilities {

    public static final Map<Id, EmailMessage> EMAILMESSAGESBYCASEID;

    static {
        // If the context of execution is a case trigger,
        // get all case related Email Messages by Case ID in a Map as a constant variable.
        if (Trigger.isExecuting && Trigger.isDelete && Trigger.old != null
            && Trigger.old.getSObjectType() == Schema.Case.getSObjectType()) {
            EMAILMESSAGESBYCASEID = getEmailMessagesByCaseId(Trigger.old);
        }
        else if (Trigger.isExecuting && Trigger.new != null
            && Trigger.new.getSObjectType() == Schema.Case.getSObjectType()) {
            EMAILMESSAGESBYCASEID = getEmailMessagesByCaseId(Trigger.new);
        }
    }

    /**
    * @description Get all case related Email Messages by Case ID.
    * @param cases A list of cases.
    * @return A map of Email Messages by Case ID.
    */
    public static Map<Id, EmailMessage> getEmailMessagesByCaseId(List<Case> cases) {
        Map<Id, EmailMessage> emailMessagesByCaseIdTemp = new Map<Id, EmailMessage> ();
        for (EmailMessage em : [SELECT ParentId, ToAddress FROM EmailMessage WHERE ParentId IN :cases]) {
            emailMessagesByCaseIdTemp.put(em.ParentId, em);
        }
        return emailMessagesByCaseIdTemp;
    }

}