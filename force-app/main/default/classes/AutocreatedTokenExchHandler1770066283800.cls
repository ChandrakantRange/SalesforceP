/*
* Auto Generated Token Exchange Handler
* TO DO: Customize how this handler validates tokens and maps users
*/
global class AutocreatedTokenExchHandler1770066283800 extends Auth.Oauth2TokenExchangeHandler {

    // TO DO: Update these constants with the actual values for your use case
    private static final String CUSTOMER_USER_PROFILE = 'Customer Profile';
    private static final String CUSTOMER_ACCOUNT = 'My Account';
    private static final String USER_PROFILE = 'Standard User';
    private static final String EXTERNAL_IDP_INTROSPECT_URL = 'https://my.company.site/services/oauth2/introspect';
    private static final String EXTERNAL_IDP_USER_INFO_URL = 'https://my.company.site/services/oauth2/userinfo';
    private static final String EXTERNAL_IDP_JWKS_URL = 'https://mycompany.site/id/keys';
    private static final String USERNAME_SUFFIX = '@myorg.com';

    /*
    * Initialize the API client by setting up the client credentials
    * Avoid hardcoding sensitive information such as the the client secret
    * Instead, create a custom metadata type to securely store the client credentials
    */
    private String externalIdpClientId;
    private String externalIdpClientSecret;

    // TO DO: Retrieve the client credentials from the custom metadata type
    private void setupClientCredentials() {
        // ClientCredentials__mdt clientCredentials = ClientCredentials__mdt.getInstance('recordId');
        // this.externalIdpClientId = clientCredentials.Client_Id__c;
        // this.externalIdpClientSecret = clientCredentials.Client_Secret__c;
    }

    /*
    * Validate opaque access tokens by calling out to the introspection endpoint on the identity provider
    *
    * @param incomingToken — The access token to be validated
    * @return username — If the token is valid, return the user's username for the identity provider. Otherwise, return null.
    */
    private String introspectAccessToken(String incomingToken) {
        String body = 'client_id=' + this.externalIdpClientId + '&client_secret=' + this.externalIdpClientSecret + '&token=' + incomingToken;
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(EXTERNAL_IDP_INTROSPECT_URL);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(body);
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            return null;
        }

        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Boolean isActive = (Boolean) resultMap.get('active');
        if (!isActive) {
            return null;
        }

        String username = (String) resultMap.get('username');

        return username;
    }

    /*
    * Retrieve more information about the user so that you can map them to a Salesforce user
    * Call out to the user info endpoint on the identity provider
    * Use this callout for opaque access tokens
    * Or use it for JSON Web Tokens (JWTs) if you can't get enough user information from the JWT itself
    *
    * @param incomingToken - The access token to use in the user info request
    * @return userData - If the request succeeds, return an Auth.UserData object with the user information. Otherwise, return null.
    */
    private Auth.UserData getUserInfoForToken(String incomingToken) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(EXTERNAL_IDP_USER_INFO_URL);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + incomingToken);

        Http http = new Http();
        HTTPResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            return null;
        }

        Map<String, Object> userInfo = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String firstName = (String) userInfo.get('given_name');
        String lastName = (String) userInfo.get('family_name');
        String fullName = (String) userInfo.get('name');
        String email = (String) userInfo.get('email');
        String username = (String) userInfo.get('preferred_username');
        String locale = (String) userInfo.get('locale');

        Auth.UserData userData = new Auth.UserData(null, firstName, lastName, fullName, email, null, username, locale, null, null, null);

        return userData;
    }

    /*
    * Another way to retrieve user information
    * Extract the user data from the Auth.JWT object representing the incoming JWT
    * Use this option for JWTs. If the JWT contains all necessary user information, you can avoid a callout to the identity provider
    *
    * @param jwt - Auth.JWT object representing the JWT
    * @return Auth.UserData — Auth.UserData object populated with user information from the JWT
    */
    private Auth.UserData getUserDataFromJWT(Auth.JWT jwt) {
        String firstName = (String) jwt.getAdditionalClaims().get('firstName');
        String lastName = (String) jwt.getAdditionalClaims().get('lastName');
        String fullName = (String) jwt.getAdditionalClaims().get('fullName');
        String email = (String) jwt.getAdditionalClaims().get('email');
        String username = (String) jwt.getAdditionalClaims().get('username');

        Auth.UserData userData = new Auth.UserData(null, firstName, lastName, fullName, email, null, username, null, null, null, null);

        return userData;
    }

    /*
    * Find a Salesforce User record (with an email address) associated with the retrieved user information
    *
    * @param data — Auth.UserData object containing the user information
    * @return User — If there's a user associated with the UserData, return the User object. Otherwise, return null.
    */
    private User findExistingUser(Auth.UserData data) {
        String email = data.email;

        List<User> existingUser = [SELECT Id, Username, Email, FirstName, LastName, Alias, ProfileId FROM User WHERE Email=:email LIMIT 1];
        // We recommend that you validate whether the user's email address is verified

        if (existingUser.isEmpty()) {
            return null;
        }

        return existingUser[0];
    }

    /*
    * Find a Salesforce Contact record (with an email address) associated with the retrieved user information
    *
    * @param data — Auth.UserData object containing the user information
    * @return Contact — If there's a contact associated with the UserData, return the Contact object. Otherwise, return null.
    */
    private Contact findExistingContact(Auth.UserData data, String accountId) {
        String email = data.email;

        List<Contact> existingContact = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE Email = :email AND AccountId = :accountId LIMIT 1];

        if (existingContact.isEmpty()) {
            return null;
        }

        return existingContact[0];
    }

    /*
    * Initialize a User record with common fields from the Auth.UserData object
    * 
    * @param data — Auth.UserData object containing the user information
    * @return User — Initialized User object with common fields set
    */
    private User initializeUser(Auth.UserData data) {
        User u = new User();
        u.username = data.username + USERNAME_SUFFIX;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.username;
        // Alias must be 8 characters or less
        if (alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = UserInfo.getLocale();
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = UserInfo.getLocale();

        return u;
    }

    /*
    * Creates an internal (employee) User based on the provided Auth.UserData object
    *
    * @param data — Auth.UserData object containing the new user's information
    * @return User — The newly created User object associated with an employee profile
    */
    private User createEmployeeUser(Auth.UserData data) {
        User u = initializeUser(data);

        Profile p = [SELECT Id FROM profile WHERE name=:USER_PROFILE];
        u.ProfileId = p.Id;

        return u;
    }

    /*
    * Retrieve an existing account to store the internal User, or create a new account if necessary
    *
    * @param accountName — The name of the Account object to find or create
    * @return Account — The found or newly created Account object
    */
    private Account findOrCreateAccount(String accountName) {
        List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name=:accountName LIMIT 1];

        if (existingAccounts.isEmpty()) {
            Account newAccount = new Account(Name = accountName);
            insert(newAccount);
            return newAccount;
        }

        return existingAccounts[0];
    }

    /*
    * Create a contact for the internal user and associate it with an account
    *
    * @param account — Account object to associate with the contact
    * @param user — User object containing the first and last name for the contact
    * @return Contact — The newly created Contact record
    */
    private Contact createContact(Account account, User user) {
        Contact c = new Contact();
        c.accountId = account.Id;
        c.firstName = user.firstName;
        c.lastName = user.lastName;

        insert(c);

        return c;
    }

    /*
    * Create a User record for an external user (customer or partner) based on the provided Auth.UserData object
    * Associate the external user with an account and contact
    *
    * @param data — Auth.UserData object containing the new user's information
    * @return User — The newly created User object
    */
    private User createCustomerUser(Auth.UserData data) {
        User u = initializeUser(data);

        Profile p = [SELECT Id FROM profile WHERE name=:CUSTOMER_USER_PROFILE];
        u.ProfileId = p.Id;

        Account a = findOrCreateAccount(CUSTOMER_ACCOUNT);

        Contact c = createContact(a, u);
        u.contactId = c.Id;

        return u;
    }

    // TODO: Customize this implementation for your use case
    private Boolean shouldCreateCustomerUser(Auth.UserData data) {
        return false;
    }

    global override Auth.TokenValidationResult validateIncomingToken(String appDeveloperName, Auth.IntegratingAppType appType, String incomingToken, Auth.OAuth2TokenExchangeType tokenType) {
        if (tokenType == Auth.OAuth2TokenExchangeType.ACCESS_TOKEN) {
            setupClientCredentials();

            // Validate opaque access tokens using the introspect endpoint on the identity provider
            String username = introspectAccessToken(incomingToken);
            if (username == null) {
                return new Auth.TokenValidationResult(false);
            }

            Auth.UserData userData = getUserInfoForToken(incomingToken);
            if (userData == null) {
                return new Auth.TokenValidationResult(false);
            }

            return new Auth.TokenValidationResult(true, null, userData, incomingToken, tokenType, null);
        } else if (tokenType == Auth.OAuth2TokenExchangeType.JWT) {
            // Validate JWTs using a remote keys endpoint on the identity provider
            Auth.JWT jwt = Auth.JWTUtil.validateJWTWithKeysEndpoint(incomingToken, EXTERNAL_IDP_JWKS_URL, true);

            Datetime expClaim = (Datetime) jwt.getAdditionalClaims().get('exp');
            if (expClaim < Datetime.now()) {
                return new Auth.TokenValidationResult(false);
            }
            // TO DO: Validate other JWT claims as necessary for your use case

            // If the JWT already contains all necessary user information, parse the data from the JWT
            // Auth.UserData userData = getUserDataFromJWT(jwt);

            // Otherwise, extract information from the user info endpoint on the identity provider
            Auth.UserData userData = getUserInfoForToken(incomingToken);
            if (userData == null) {
                return new Auth.TokenValidationResult(false);
            }

            return new Auth.TokenValidationResult(true, null, userData, incomingToken, tokenType, null);
        }
        return new Auth.TokenValidationResult(false);
    }

    /*
     * Controls the user resolution path by identifying the subject's type.
     * If true, the system proceeds with User-specific operations via getUserForTokenSubject().
     * If false, the process switches to Contact-specific operations using getContactForTokenSubject().
    */
    global override Boolean mapToUser(Id networkId, Auth.TokenValidationResult result, Boolean canCreateUser, Boolean canCreateContact, String appDeveloperName, Auth.IntegratingAppType appType) {
        return true;
    }

    global override User getUserForTokenSubject(Id networkId, Auth.TokenValidationResult result, Boolean canCreateUser, String appDeveloperName, Auth.IntegratingAppType appType) {
        Auth.UserData data = result.getUserData();

        User foundUser = findExistingUser(data);
        if (foundUser != null || !canCreateUser) {
            return foundUser;
        }

        User u;

        // Based on the found user record, create an internal (employee) or external (customer or partner) user
        // TO DO: Uncomment based on your use case
        // if (networkId != null) {
        //     if (shouldCreateCustomerUser(data)) {
        //         u = createCustomerUser(data);
        //     } else {
        //         u = createEmployeeUser(data);
        //     }
        // } else {
        //     u = createEmployeeUser(data);
        // }

        return u;
    }

    /*
    * Retrieves an existing Contact or creates a new one based on the validated token subject.
    * This method is invoked when mapToUser() returns false.
    *
    * @param networkId — The ID of the Experience Cloud site if the context is an Experience Cloud login.
    * @param result — The Auth.TokenValidationResult object containing validated user data.
    * @param canCreateContact — Boolean indicating if a new Contact record can be created.
    * @param appDeveloperName — The developer name of the connected app or external client app.
    * @param appType — The type of the integrating app.
    * @return Contact — An existing or newly created Contact object. Returns null if a contact cannot be found or created.
    */
    global override Contact getContactForTokenSubject(Id networkId, Auth.TokenValidationResult result, Boolean canCreateContact, String appDeveloperName, Auth.IntegratingAppType appType) {
        Auth.UserData data = result.getUserData();
        
        if (data == null || String.isBlank(data.email)) {
            System.debug('Auth.UserData or email is missing for Contact creation.');
            return null; // Cannot proceed without user data or email
        }

        // Associate the Contact with an Account
        // Reuse the findOrCreateAccount method, assuming "My Account" is the default for Contacts
        Account relatedAccount = findOrCreateAccount(CUSTOMER_ACCOUNT);
        if (relatedAccount == null) {
            System.debug('Could not find or create a related account for the new contact.');
            return null; // Cannot create contact without an account
        }

        Contact foundContact = findExistingContact(data, relatedAccount.Id);
        if (foundContact != null || !canCreateContact) {
            return foundContact; // Return existing contact
        }


        // Create new contact
        Contact newContact = new Contact();
        newContact.firstName = data.firstName;
        newContact.lastName = data.lastName;
        newContact.email = data.email;
        newContact.accountId = relatedAccount.Id;
        return newContact;
    }
}