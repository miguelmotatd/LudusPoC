/**
 * Created by miguel.mota on 9/20/18.
 */

public with sharing class MetadataAPIService {

    public static HttpRequest createHttpRequest(String endpoint, String method)
    {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod(method);
        return req;
    }
    public static String fetchResponse(HttpRequest req)
    {
        Http objHttp = new Http();
        HttpResponse res = objHttp.send(req);
        return res.getBody();
    }
}