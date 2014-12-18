//
//  AuthManager.h
//

/*!
 @header AuthManager
 @abstract AuthManager class
 */

#import <Foundation/Foundation.h>
#import "APObject.h"
#import "Authorizable-Protocol.h"

/*!
 @typedef APAuthorizableCallback
 @abstract Callback used by @link //apple_ref/occ/clm/AuthManager/signInAs:async: @/link, @link //apple_ref/occ/clm/AuthManager/signOutAsync: @/link.
 @param object Authorized object returned by the remote server, if available.
 @param error Error that has occured while executing the request, if any.
 */
typedef void(^APAuthorizableCallback)(APObject<Authorizable> * object, NSError * error);

/*!
 @class AuthManager
 @abstract Lets you start and end authenticated sessions.
 @discussion AuthManager is intended to be used with @link //apple_ref/occ/cat/NSObject(RemoteConfig) @/link and data model objects.
 The session is persisted behind the scenes but may timeout or be terminated by the server.
 Make sure to set the default instance with @link //apple_ref/occ/intfm/AuthManager/setDefaultManager: @/link, as well the necessary endpoints (@link //apple_ref/occ/intfm/AuthManager/signInURL @/link, @link //apple_ref/occ/intfm/AuthManager/signOutURL @/link) prior to use.
 */
@interface AuthManager : NSObject {
}

/*!
 @var currentCredentials
 @abstract Returns currently authorized credentials. Use @link //apple_ref/occ/instm/AuthManager/signInAs:async: @/link to set, @link //apple_ref/occ/instm/AuthManager/signOutAsync: @/link to clear.
 */
@property (nonatomic, strong, readonly) APObject<Authorizable> * currentCredentials;
/*!
 @var persistsCurrentCredentials
 @abstract Set to YES to persist value of @link //apple_ref/occ/instp/AuthManager/currentCredentials @/link across app sessions. Default is NO.
 */
@property (nonatomic, assign) BOOL persistsCurrentCredentials;

/*!
 @method signInAs:async:
 @abstract Starts authenticated user session.
 @param credentials Object to authenticate with.
 @param callback Callback to be executed when operation completes.
 @discussion Credentials should conform to @link //apple_ref/occ/intf/Authorizable @/link.
 */
- (void)signInAs:(APObject<Authorizable> *)credentials async:(APAuthorizableCallback)callback;
/*!
 @method signOutAsync:
 @abstract Ends authenticated user session.
 @param callback Callback to be executed when operation completes.
 */
- (void)signOutAsync:(APAuthorizableCallback)callback;
/*!
 @method defaultManager
 @abstract Gets default @link //apple_ref/occ/clm/AuthManager @/link instance.
 @result Current AuthManager instance.
 */
+ (AuthManager *)defaultManager;

@end
