//
//  AuthManager+Protected.h
//  Outages
//

/*!
 @header AuthManager+Protected
 @abstract Protected category for AuthManager class
 */

#import "AuthManager.h"

@class AuthManager;

/*!
 @category AuthManager (Protected)
 @abstract Provides configuration options for @link //apple_ref/occ/clm/AuthManager @/link.
 */
@interface AuthManager (Protected)

/*!
 @var signInURL
 @abstract Sets sign-in endpoint for @link //apple_ref/occ/clm/AuthManager @/link.
 @discussion This is an absolute URL, base URL set with @link //apple_ref/occ/cat/NSObject(Remote)/setBaseURL: @/link is not used.
 */
@property (strong, nonatomic) NSURL * signInURL;
/*!
 @var signOutURL
 @abstract Sets sign-out endpoint for @link //apple_ref/occ/clm/AuthManager @/link.
 @discussion This is an absolute URL, base URL set with @link //apple_ref/occ/cat/NSObject(Remote)/setBaseURL: @/link is not used.
 */
@property (strong, nonatomic) NSURL * signOutURL;
/*!
 @var currentCredentials
 @abstract Sets currently authorized credentials.
 */
@property (strong, nonatomic, readwrite) APObject<Authorizable> * currentCredentials;

/*!
 @method setDefaultManager:
 @param manager New manager instance.
 @abstract Sets default instance of  @link //apple_ref/occ/clm/AuthManager @/link.
 */
+ (void)setDefaultManager:(AuthManager *)manager;

@end
