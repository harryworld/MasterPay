//
//  APObject+Local.h
//  AnyPresence SDK
//
//  Created by Jeffrey Bozek on 7/14/13.
//  Copyright (c) 2013 AnyPresence, Inc. All rights reserved.
//

/*!
 @header APObject+Local
 @abstract Local category for APObject class
 */

#import <Foundation/Foundation.h>
#import "APObject.h"
#import "Typedefs.h"

@interface APObject (Local)

/*!
 @method queryLocal:params:
 @abstract Fetches objects that match a query from local cache.
 @param scope Named scope to request.
 @param params Named scope parameters.
 @result Array of objects.
 */
+ (NSArray *)queryLocal:(NSString *)scope params:(NSDictionary *)params;
/*!
 @method queryLocal:params:offset:limit:
 @abstract Fetches objects local cache.
 @param scope Named scope to request.
 @param params Named scope parameters.
 @param offset Number of objects to skip.
 @param limit Maximum number of objects to fetch.
 @result Array of objects.
 */
+ (NSArray *)queryLocal:(NSString *)scope params:(NSDictionary *)params offset:(NSUInteger)offset limit:(NSUInteger)limit;
/*!
 @method deleteAllLocal
 @abstract Deletes all instances of this entity type in local cache.
 */
+ (void)deleteAllLocal;
/*!
 @method fetchLocalWithPredicate:
 @abstract Fetches objects from local cache using a predicate.
 @param predicate Predicate to use when fetching.
 @result Array of objects.
 */
+ (NSArray *)fetchLocalWithPredicate:(NSPredicate *)predicate;
/*!
 @method saveLocal
 @abstract Save changes to current object to local cache.
 */
- (void)saveLocal;
/*!
 @method deleteLocal
 @abstract Deletes current object from local cache.
 */
- (void)deleteLocal;

@end
