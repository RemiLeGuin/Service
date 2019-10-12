/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Utility class for the Form Response Sending custom metadata whithin the Service package.
*/
public with sharing class Service_FormResponseSendingUtilities {

    public static final Map<String, Boolean> SENDFORMSBYEMAILADDRESS;

    static {
        SENDFORMSBYEMAILADDRESS = getSendFormsByEmailAddress();
    }

    /**
    * @description Get form sending decision according to email addresses.
    * @return A map of Booleans stating for sending by email address.
    */
    public static Map<String, Boolean> getSendFormsByEmailAddress() {
        Map<String,Boolean> sendFormsByEmailAddress = new Map<String, Boolean> ();
        for (FormResponseSending__mdt formResponseSending : [SELECT EmailAddress__c, SendForm__c
                                                             FROM FormResponseSending__mdt]) {
            SENDFORMSBYEMAILADDRESS.put(formResponseSending.EmailAddress__c, formResponseSending.SendForm__c);
        }
        return sendFormsByEmailAddress;
    }

}