public with sharing class NTTOfficeTriviaClient {
        public static Map<String,String> getAccessToken() {
            ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='office_trivia' LIMIT 1];
            String keyContents = base64Content.VersionData.tostring();
            keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
            keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
            keyContents = keyContents.replace('\n', '');
    
            NTTJWT jwt = new NTTJWT('RS256');
            jwt.pkcs8 = keyContents; 

            jwt.iss = '3MVG9SOw8KERNN0_iQxQJ9MKisFCV8OeCqaMWmuiYsbPPfHm7C17O7ytqMUjQQbOFoTEicAjSn.kmw2Zzskja';
            jwt.sub = 'contestant@emea.nttdata.com.nttmunichtech'; // Change this with your email which is used for einstein api setup
            jwt.aud = 'https://login.salesforce.com';
            jwt.exp = '3600';
            String testcode ='eyJpc3MiOiAiMzNNVkc5U093OEtFUk5OMF9pUXhRSjlNS2lzRkNWOE9lQ3FhTVdtdWlZc2JQUGZIbTdDMTdPN3l0cU1ValFRYk9Gb1RFaWNBalNuLmttdzJaenNramEiLCANCiJzdWIiOiAiY2F0YWxpbi50YW5hc2llLmJwQGVtZWEubnR0ZGF0YS5jb20ubnR0bXVuaWNodGVjaCIsIA0KImF1ZCI6ICJodHRwczovL2xvZ2luLnNhbGVzZm9yY2UuY29tIiwgDQoiZXhwIjogIjM2MDAifQ';
            Map<String,String> tokenMap = NTTJWTBearerFlow.getAccessToken('https://login.salesforce.com/services/oauth2/token', jwt);
            return tokenMap;    
        }
    
}