//
//  APObject+RemoteConfig.h
//  AnyPresence SDK
//

/*!
 @header APObject+RemoteConfig
 @abstract RemoteConfig category for APObject class
 */

#import <Foundation/Foundation.h>

@class APObjectRemoteConfig;

/*!
 @category APObject (RemoteConfig)
 @abstract Adds configuration support for APObject+Remote methods.
 @discussion NSObject+RemoteConfig allows to set meta attributes for model objects.
 See @link //apple_ref/occ/clm/NSObjectRemoteConfig @/link for available configuration options.
 */
@interface APObject (RemoteConfig)

/*!
 @method remoteConfig
 @abstract Returns APObjectRemoteConfig instance for current class.
 */
+ (APObjectRemoteConfig *)remoteConfig;

@end
