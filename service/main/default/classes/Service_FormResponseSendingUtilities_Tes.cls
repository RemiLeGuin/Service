/**
* @author Rémi Le Guin
* @date 16/10/2019
* @description Test class for the utility class for the Form Response Sending custom metadata whithin the Service package.
*/
@IsTest
private class Service_FormResponseSendingUtilities_Tes {

    /**
    * @description Test the constant fetching form sending decision according to queue.
    */
    @IsTest
    private static void getSendFormsByQueue_Test() {
        Map<String, Boolean> sendFormsByQueue = Service_FormResponseSendingUtilities.SENDFORMSBYQUEUE;
        Map<String, String> queuesByDeveloperName = new Map<String, String> ();
        for (Group queue : [SELECT DeveloperName, Type FROM Group WHERE Type = 'Queue' AND DeveloperName LIKE 'Service_%']) {
            queuesByDeveloperName.put(queue.DeveloperName, queue.Type);
        }
        if (sendFormsByQueue != null && !sendFormsByQueue.isEmpty()) {
            for (String queueDeveloperName : sendFormsByQueue.keySet()) {
                System.assertEquals('Queue', queuesByDeveloperName.get(queueDeveloperName), 'The Map ID does not belong to a Queue');
            }
        }
    }

}