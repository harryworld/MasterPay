//
//  OrderDetail.h
//  AnyPresence SDK
//

/*!
 @header OrderDetail
 @abstract OrderDetail class
 */

#import "APObject.h"
#import "Typedefs.h"

@class Product;
@class OrderHeader;

/*!
 @class OrderDetail
 @abstract Generated model object: OrderDetail.
 @discussion Use @link //apple_ref/occ/cat/OrderDetail(Remote) @/link to add CRUD capabilities.
 The @link //apple_ref/occ/instp/OrderDetail/id @/link field is set as primary key (see @link //apple_ref/occ/cat/APObject(RemoteConfig) @/link) in [self init].
 */
@interface OrderDetail : APObject {
}

/*!
 @var id
 @abstract Generated model property: id.
 @discussion Primary key. Generated on the server.
 */
@property (nonatomic, strong) NSString * id;
/*!
 @var orderHeaderId
 @abstract Generated model property: order_header_id.
 */
@property (nonatomic, strong) NSString * orderHeaderId;
/*!
 @var productId
 @abstract Generated model property: product_id.
 */
@property (nonatomic, strong) NSString * productId;

/*!
 @var product
 @abstract Generated property for belongs-to relationship to product.
 */
@property (nonatomic, strong) Product * product;
/*!
 @var orderHeader
 @abstract Generated property for belongs-to relationship to orderHeader.
 */
@property (nonatomic, strong) OrderHeader * orderHeader;

@end