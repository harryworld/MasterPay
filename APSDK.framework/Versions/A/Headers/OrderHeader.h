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
 @var billingAddressCity
 @abstract Generated model property: billing_address_city.
 */
@property (nonatomic, strong) NSString * billingAddressCity;
/*!
 @var billingAddressCountry
 @abstract Generated model property: billing_address_country.
 */
@property (nonatomic, strong) NSString * billingAddressCountry;
/*!
 @var billingAddressLineOne
 @abstract Generated model property: billing_address_line_one.
 */
@property (nonatomic, strong) NSString * billingAddressLineOne;
/*!
 @var billingAddressLineThree
 @abstract Generated model property: billing_address_line_three.
 */
@property (nonatomic, strong) NSString * billingAddressLineThree;
/*!
 @var billingAddressLineTwo
 @abstract Generated model property: billing_address_line_two.
 */
@property (nonatomic, strong) NSString * billingAddressLineTwo;
/*!
 @var billingAddressPostalCode
 @abstract Generated model property: billing_address_postal_code.
 */
@property (nonatomic, strong) NSString * billingAddressPostalCode;
/*!
 @var cardAccountNumber
 @abstract Generated model property: card_account_number.
 */
@property (nonatomic, strong) NSString * cardAccountNumber;
/*!
 @var cardBrandId
 @abstract Generated model property: card_brand_id.
 */
@property (nonatomic, strong) NSString * cardBrandId;
/*!
 @var cardBrandName
 @abstract Generated model property: card_brand_name.
 */
@property (nonatomic, strong) NSString * cardBrandName;
/*!
 @var cardExpiryMonth
 @abstract Generated model property: card_expiry_month.
 */
@property (nonatomic, strong) NSString * cardExpiryMonth;
/*!
 @var cardExpiryYear
 @abstract Generated model property: card_expiry_year.
 */
@property (nonatomic, strong) NSString * cardExpiryYear;
/*!
 @var cardHolderName
 @abstract Generated model property: card_holder_name.
 */
@property (nonatomic, strong) NSString * cardHolderName;
/*!
 @var cardLastFour
 @abstract Generated model property: card_last_four.
 */
@property (nonatomic, strong) NSString * cardLastFour;
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
 @var shipping
 @abstract Generated model property: shipping.
 */
@property (nonatomic, strong) NSNumber * shipping;
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
 @var tax
 @abstract Generated model property: tax.
 */
@property (nonatomic, strong) NSNumber * tax;
/*!
 @var total
 @abstract Generated model property: total.
 */
@property (nonatomic, strong) NSNumber * total;
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