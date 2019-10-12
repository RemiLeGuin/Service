/**
* @author Rémi Le Guin
* @date 10/10/2019
* @description Test class for the utility class for the Case standard object whithin the Service package.
*/
@IsTest
private class Service_CaseUtilities_Test {

    /**
    * @description Test the constants fetching Service record type IDs.
    */
    @IsTest
    private static void getRecordTypesId_Test() {
        Id recordTypeId_MajorAccounts = Service_CaseUtilities.RECORDTYPEID_MAJORACCOUNTS;
        Id recordTypeId_PublicDeals = Service_CaseUtilities.RECORDTYPEID_PUBLICDEALS;
        Id recordTypeId_Restitutions = Service_CaseUtilities.RECORDTYPEID_RESTITUTIONS;
        Id recordTypeId_Services = Service_CaseUtilities.RECORDTYPEID_SERVICES;

        System.assertEquals(18, String.valueOf(recordTypeId_MajorAccounts).length(), 'The string is not a 18 character ID');
        System.assertEquals('012', String.valueOf(recordTypeId_MajorAccounts).left(3), 'The ID does not belong to a Record Type');
        System.assertEquals(18, String.valueOf(recordTypeId_PublicDeals).length(), 'The string is not a 18 character ID');
        System.assertEquals('012', String.valueOf(recordTypeId_PublicDeals).left(3), 'The ID does not belong to a Record Type');
        System.assertEquals(18, String.valueOf(recordTypeId_Restitutions).length(), 'The string is not a 18 character ID');
        System.assertEquals('012', String.valueOf(recordTypeId_Restitutions).left(3), 'The ID does not belong to a Record Type');
        System.assertEquals(18, String.valueOf(recordTypeId_Services).length(), 'The string is not a 18 character ID');
        System.assertEquals('012', String.valueOf(recordTypeId_Services).left(3), 'The ID does not belong to a Record Type');
    }

}