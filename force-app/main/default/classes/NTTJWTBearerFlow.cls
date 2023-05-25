public class NTTJWTBearerFlow {
    public static Map<String,String> getAccessToken(String tokenEndpoint, NTTJWT jwt) {
        String access_token = null;
        String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
        HttpRequest req = new HttpRequest();                            
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
       // req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        Http http = new Http();               
        HTTPResponse res = http.send(req);
        system.debug(res.getBody());
        Map<String,String> tokenMap = new Map<String,String>();
        
        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    tokenMap.put('access_token', parser.getText());
                    
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'instance_url')) {
                    parser.nextToken();
                    tokenMap.put('instance_url', parser.getText());
                    
                }
            }
        }
        return tokenMap;
    }
}