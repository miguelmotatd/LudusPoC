public class ApexTrigger_REST
{
    /* NOTE: Make sure you add  https://YOUR_INSTANCE.salesforce.com or https://DOMAIN_NAME in remote setting.*/
    private static String endPoint = URL.getSalesforceBaseUrl().toExternalForm()  + '/services/data/v41.0/sobjects';
    /* This method creates apex trigger via callout to ApexTrigger REST Resource */
    public static String createApexTrigger(TriggerInfoWrapper objTriggerInfo)
    {
        // create a Http request with post method
        HttpRequest req = createHttpRequest(endPoint+'/ApexTrigger','POST');
        // set body with serialized trigger info
        req.setBody(JSON.serialize(objTriggerInfo));
        // send request and receive response
        String response = fetchResponse(req);
        return response;
    }
    /* This method returns only triggerable object infos via callout to sobjects REST Resource */
    public static Map<String, String> fetchTriggerableObjInfo()
    {
        // hold returned response objects info
        Map<String, String> mapObjectMapping = new Map<String, String>();
        // create a Http request with post method
        HttpRequest req = createHttpRequest(endPoint, 'GET');
        // send request and receive response
        String response = fetchResponse(req);
        // extract triggerable info
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> objs = (List<Object>) body.get('sobjects');
        for (Object obj : objs)
        {
            Map<String, Object> objDesc = (Map<String, Object>)(obj);
            String name = (String) objDesc.get('name');
            Boolean isTriggerable = (Boolean) objDesc.get('triggerable');
            if(isTriggerable)
            {
                // construct mapping
                mapObjectMapping.put(name, (String) objDesc.get('label'));
            }
            System.debug(System.LoggingLevel.ERROR, name + ': ' + isTriggerable);
        }
        return mapObjectMapping;
    }
    /* This method returns response of an http request */
    private static String fetchResponse(HttpRequest req)
    {
        Http objHttp = new Http();
        HttpResponse res = objHttp.send(req);
        return res.getBody();
    }
    /* This method creates a http request with required endpoint and request method */
    private static HttpRequest createHttpRequest(String endpoint, String method)
    {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod(method);
        return req;
    }
    /* Wraper class to hold trigger information which needs to be set as body while creating trigger */
    public class TriggerInfoWrapper
    {
        // Trigger Name
        public String Name;
        // Object Name on which trigger has to be created
        public String TableEnumOrId;
        // Trigger body
        public String Body;
        public TriggerInfoWrapper(String objName, String triggerName, String triggerBody)
        {
            this.Name = triggerName;
            this.TableEnumOrId = objName;
            this.Body = triggerBody;
        }
    }
}