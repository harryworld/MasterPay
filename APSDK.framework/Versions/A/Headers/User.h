//
//  User.h
//  AnyPresence SDK
//

/*!
 @header User
 @abstract User class
 */

#import "APObject.h"
#import "Authorizable-Protocol.h"
#import "Typedefs.h"


/*!
 @class User
 @abstract Generated model object: User.
 @discussion Use @link //apple_ref/occ/cat/User(Remote) @/link to add CRUD capabilities.
 The @link //apple_ref/occ/instp/User/id @/link field is set as primary key (see @link //apple_ref/occ/cat/APObject(RemoteConfig) @/link) in [self init].
 */
@interface User : APObject <Authorizable> {
}

/*!
 @var id
 @abstract Generated model property: id.
 @discussion Primary key. Generated on the server.
 */
@property (nonatomic, strong) NSString * id;
/*!
 @var email
 @abstract Generated model property: email.
 */
@property (nonatomic, strong) NSString * email;
/*!
 @var isPaired
 @abstract Generated model property: is_paired.
 */
@property (nonatomic, strong) NSNumber * isPaired;
/*!
 @var longAccessToken
 @abstract Generated model property: long_access_token.
 */
@property (nonatomic, strong) NSString * longAccessToken;
/*!
 @var password
 @abstract Generated model property: password.
 */
@property (nonatomic, strong) NSString * password;
/*!
 @var passwordConfirmation
 @abstract Generated model property: password_confirmation.
 */
@property (nonatomic, strong) NSString * passwordConfirmation;
/*!
 @var passwordDigest
 @abstract Generated model property: password_digest.
 */
@property (nonatomic, strong) NSString * passwordDigest;
/*!
 @var role
 @abstract Generated model property: role.
 */
@property (nonatomic, strong) NSString * role;
/*!
 @var xSessionId
 @abstract Generated model property: x_session_id.
 */
@property (nonatomic, strong) NSString * xSessionId;


@end