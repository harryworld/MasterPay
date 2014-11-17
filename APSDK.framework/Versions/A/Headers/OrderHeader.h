//
//  OrderHeader.h
//  AnyPresence SDK
//

/*!
 @header OrderHeader
 @abstract OrderHeader class
 */

#import "APObject.h"
#import "Typedefs.h"


/*!
 @class OrderHeader
 @abstract Generated model object: OrderHeader.
 @discussion Use @link //apple_ref/occ/cat/OrderHeader(Remote) @/link to add CRUD capabilities.
 The @link //apple_ref/occ/instp/OrderHeader/id @/link field is set as primary key (see @link //apple_ref/occ/cat/APObject(RemoteConfig) @/link) in [self init].
 */
@interface OrderHeader : APObject {
}

/*!
 @var id
 @abstract Generated model property: id.
 @discussion Primary key. Generated on the server.
 */
@property (nonatomic, strong) NSString * id;
/*!
 @var checkoutToken
 @abstract Generated model property: checkout_token.
 */
@property (nonatomic, strong) NSString * checkoutToken;
/*!
 @var createdAt
 @abstract Generated model property: created_at.
 */
@property (nonatomic, strong) NSDate * createdAt;
/*!
 @var status
 @abstract Generated model property: status.
 */
@property (nonatomic, strong) NSString * status;
/*!
 @var subtotal
 @abstract Generated model property: subtotal.
 */
@property (nonatomic, strong) NSNumber * subtotal;
/*!
 @var userId
 @abstract Generated model property: user_id.
 */
@property (nonatomic, strong) NSString * userId;

/*!
 @var orderDetails
 @abstract Generated property for has-many relationship to orderDetails.
 */
@property (nonatomic, strong) NSOrderedSet * orderDetails;

@end