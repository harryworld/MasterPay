//
//  NSData+JSON.h
//  Created by AnyPresence, Inc. on 11/8/12.
//

/*!
 @header NSData+JSON
 @abstract JSON category for NSData class
 */

#import <Foundation/Foundation.h>

/*!
 @category NSData (JSON)
 @abstract Adds ability serialize objects to JSON.
 */
@interface NSData (JSON)

/*!
 @method objectFromJSON
 @abstract Restores object from JSON.
 @result Restored object.
 */
- (id)objectFromJSON;
/*!
 @method objectFromJSON:
 @abstract Restores object from JSON.
 @param error Error that occured during conversion, if any.
 @result Restored object.
 */
- (id)objectFromJSONError:(NSError **)error;
/*!
 @method dataFromObject
 @abstract Converts object to JSON.
 @param object Object to be serialized.
 @result Binary JSON data.
 */
+ (NSData *)dataFromObject:(id)object;
/*!
 @method dataFromObject:error:
 @abstract Converts object to JSON.
 @param object Object to be serialized.
 @param error Error that occured during conversion, if any.
 @result Binary JSON data.
 */
+ (NSData *)dataFromObject:(id)object error:(NSError **)error;

@end
