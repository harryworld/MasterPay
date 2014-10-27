//
//  Authorizable-Protocol.h
//  Outages
//

/*!
 @header Authorizable-Protocol
 @abstract Authorizable protocol
 */

#import <Foundation/Foundation.h>

/*!
 @protocol Authorizable
 @abstract Designates object to authenticate with.
 @discussion Authorizable is intended to be used with data model objects and @link //apple_ref/occ/clm/AuthManager @/link.
 */
@protocol Authorizable <NSObject>

/*!
 @method email
 @abstract Gets email to authenticate with.
 @result Email.
 */
- (NSString *)email;
/*!
 @method password
 @abstract Gets password to authenticate with.
 @result Password.
 */
- (NSString *)password;
/*!
 @method role
 @abstract Gets current role.
 @result Current role.
 */
- (NSString *)role;

@end
