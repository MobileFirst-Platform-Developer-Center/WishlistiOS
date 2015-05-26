/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */


#import <Foundation/Foundation.h>
#import "WLResponse.h"


 
typedef NS_ENUM(NSInteger, WLAuthorizationPerisistencePolicy) {
    WLAuthorizationPerisistencePolicyAlways = 0,
    WLAuthorizationPerisistencePolicyNever = 1
};

extern NSString * const ERROR_OAUTH_PREVENT_REDIRECT;
extern NSString * const ERROR_OAUTH_CANCELED;

/**
 * @ingroup main
 * This class manage all OAuth flow, from client registration to token generation.
 */
@interface WLAuthorizationManager : NSObject 
/**
 *  Get the cached authorization header from keychain.
 */
@property (nonatomic, readonly) NSString *cachedAuthorizationHeader;

/**
 *  User identity dictionary
 *  Keys: id, authBy, displayName
 */
@property (nonatomic, readonly) NSDictionary *userIdentity;

/**
 *  Device identity dictionary
 *  Keys: id, model, osVersion, platform
 */
@property (nonatomic, readonly) NSDictionary *deviceIdentity;

/**
 *  App identity dictionary
 *  Keys: id, version, environment
 */
@property (nonatomic, readonly) NSDictionary *appIdentity;

/**
 *  Get the WLAuthorizationManager shared instance
 *
 *  @return WLAuthorizationManager shared instance
 */
+ (WLAuthorizationManager *) sharedInstance;
 
/**
 *  Explicit call to obtains the access token.
 *
 *  @param completionHandler The completion handler with response contains the authorization header value.
 *
 *  @param scope The OAuth scope the resource require.
 */
- (void) obtainAuthorizationHeaderForScope:(NSString*)scope completionHandler:(void(^) (WLResponse* response, NSError* error))completionHandler;

/**
 *  Add the authorization header value to any NSURLRequest request
 *
 *  @param request The request to add the authorization header
 */
- (void) addCachedAuthorizationHeaderToRequest:(NSMutableURLRequest*)request;

/**
 *  Set the authorization policy that defines way the application handles storing of authorization access token.
 *
 *  @param policy The persistence policy
 *  The policy can be one of the following:
 *	<ul>
 *  <li>__WLAuthorizationPerisistencePolicyAlways__:
 *  Always store access token on the device (least secure option).
 *	The access tokens are persisted, regardless of whether Touch ID is present, supported, or enabled. Touch ID and device passcode authentication are never required.</li>
 *  <li>__WLAuthorizationPerisistencePolicyNever__
 *  Never store access token on the device (most secure option).
 *	The access tokens are never persisted, meaning that an access token is valid for a single app session only.</li>
 *  </ul>
 *  The default policy is __WLAuthorizationPerisistencePolicyAlways__.
 *
 *  Examples of use:
 *
 *  Set __WLAuthorizationPerisistencePolicyAlways__ policy:<br />
 *          <pre><code>WLAuthorizationManager* manager = [WLAuthorizationManager sharedInstance];
 *          [manager setAuthorizationPersistencePolicy: WLAuthorizationPerisistencePolicyAlways];</code></pre>
 *
 *  Set __WLAuthorizationPerisistencePolicyNever__ policy:<br />
 *          <pre><code>WLAuthorizationManager* manager = [WLAuthorizationManager sharedInstance];
 *          [manager setAuthorizationPersistencePolicy: WLAuthorizationPerisistencePolicyNever];</code></pre>
 */
- (void) setAuthorizationPersistencePolicy: (WLAuthorizationPerisistencePolicy) policy;

/**
 *  Checks whether the response is an WL OAuth error.
 *
 *  @param NSURLResponse response
 *
 *  @return true if the response is an WL OAuth error, or false otherwise.
 */
- (BOOL) isAuthorizationRequiredForResponse:(NSURLResponse *)response;

/**
 * Checks whether the response is an MFP OAuth error.
 *
 * @param status The HTTP status
 *
 * @param headers NSDictionary of response headers
 
 * @return true if the response is an WL OAuth error, or false otherwise.
 */

- (BOOL) isAuthorizationRequiredForResponseWithStatus:(NSInteger)status authorizationHeader:(NSString *) authorizationHeader;

/**
 *  Get the scope for response from protected resource
 *
 *  @param response returned from the protected resource
 *
 *  @return the scope which return on the WWW-Authenticate header
 */
- (NSString *) authorizationScopeForResponse : (NSURLResponse *) response;


/**
 *  Get the scope for response from protected resource
 *
 *  @param NSDictionary response headers
 *
 *  @return the scope which return on the WWW-Authenticate header
 */
- (NSString*) authorizationScopeForResponseWithAuthorizationHeader:(NSString *) authorizationHeader;
@end
