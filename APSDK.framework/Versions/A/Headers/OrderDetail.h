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
 @var productDesc
 @abstract Generated model property: product_desc.
 */
@property (nonatomic, strong) NSString * productDesc;
/*!
 @var productId
 @abstract Generated model property: product_id.
 */
@property (nonatomic, strong) NSString * productId;
/*!
 @var productImageUrl
 @abstract Generated model property: product_image_url.
 */
@property (nonatomic, strong) NSString * productImageUrl;
/*!
 @var productName
 @abstract Generated model property: product_name.
 */
@property (nonatomic, strong) NSString * productName;
/*!
 @var productPrice
 @abstract Generated model property: product_price.
 */
@property (nonatomic, strong) NSNumber * productPrice;
/*!
 @var quantity
 @abstract Generated model property: quantity.
 */
@property (nonatomic, strong) NSNumber * quantity;

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