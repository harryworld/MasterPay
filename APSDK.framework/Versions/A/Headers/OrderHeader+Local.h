//
//  OrderHeader+Local.h
//  AnyPresence SDK
//

/*!
 @header OrderHeader+Local
 @abstract Local category for OrderHeader class
 */

#import "OrderHeader.h"

/*!
 @category OrderHeader (Local)
 @abstract Adds local query capabilities to OrderHeader.
 @discussion Serves as a strongly-typed wrapper around @link //apple_ref/occ/cat/APObject(Local) @/link methods.
 */ 
@interface OrderHeader (Local)

/*!
 @method allLocalWithOffset:limit:
 @abstract Fetches objects matching query scope "all" from local cache, with pagination.
 
 @param offset Number of objects to skip.
 @param limit Maximum number of objects to fetch.
 @result Array of objects.
 */
+ (NSArray *)allLocalWithOffset:(NSUInteger)offset limit:(NSUInteger)limit;
/*!
 @method exactMatchLocalWithParams:offset:limit:
 @abstract Fetches objects matching query scope "exact_match" from local cache, with pagination.
 
 @param params Scope parameter - params.
 @param offset Number of objects to skip.
 @param limit Maximum number of objects to fetch.
 @result Array of objects.
 */
+ (NSArray *)exactMatchLocalWithParams:(NSDictionary *)params offset:(NSUInteger)offset limit:(NSUInteger)limit;
/*!
 @method myOpenOrdersLocalWithId:status:offset:limit:
 @abstract Fetches objects matching query scope "my_open_orders" from local cache, with pagination.
 
 @param id Scope parameter - id.
 @param status Scope parameter - status.
 @param offset Number of objects to skip.
 @param limit Maximum number of objects to fetch.
 @result Array of objects.
 */
+ (NSArray *)myOpenOrdersLocalWithId:(NSString *)id status:(NSString *)status offset:(NSUInteger)offset limit:(NSUInteger)limit;

@end