//
//  Product.h
//  AnyPresence SDK
//

/*!
 @header Product
 @abstract Product class
 */

#import "APObject.h"
#import "Typedefs.h"


/*!
 @class Product
 @abstract Generated model object: Product.
 @discussion Use @link //apple_ref/occ/cat/Product(Remote) @/link to add CRUD capabilities.
 The @link //apple_ref/occ/instp/Product/id @/link field is set as primary key (see @link //apple_ref/occ/cat/APObject(RemoteConfig) @/link) in [self init].
 */
@interface Product : APObject {
}

/*!
 @var id
 @abstract Generated model property: id.
 @discussion Primary key. Generated on the server.
 */
@property (nonatomic, strong) NSString * id;
/*!
 @var desc
 @abstract Generated model property: desc.
 */
@property (nonatomic, strong) NSString * desc;
/*!
 @var imageUrl
 @abstract Generated model property: image_url.
 */
@property (nonatomic, strong) NSString * imageUrl;
/*!
 @var name
 @abstract Generated model property: name.
 */
@property (nonatomic, strong) NSString * name;
/*!
 @var price
 @abstract Generated model property: price.
 */
@property (nonatomic, strong) NSNumber * price;

/*!
 @var orderDetails
 @abstract Generated property for has-many relationship to orderDetails.
 */
@property (nonatomic, strong) NSOrderedSet * orderDetails;

@end