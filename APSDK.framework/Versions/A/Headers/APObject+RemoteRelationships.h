//
//  APObject+RemoteRelationships.h
//  AnyPresence SDK
//
//  Created by Ruslan Sokolov on 3/12/13.
//  Copyright (c) 2013 AnyPresence, Inc. All rights reserved.
//

/*!
 @header APObject+RemoteRelationships
 @abstract RemoteRelationships category for APObject class
 */

#import <Foundation/Foundation.h>
#import "APObject.h"
#import "Typedefs.h"

/*!
 @const kAPRemoteRelationshipsErrorDomain
 @abstract Default error domain for remote relationships.
 */
extern NSString * const kAPRemoteRelationshipsErrorDomain;
/*!
 @const kAPRemoteRelationshipsErrorCodeInvalidKeyPath
 @abstract Indicates the supplied key path was not valid.
 */
extern NSInteger const kAPRemoteRelationshipsErrorCodeInvalidKeyPath;

/*!
 @category APObject (RemoteRelationships)
 @abstract Adds support for loading relationship properties.
 @discussion Relationship properties point to other @link //apple_ref/occ/cl/APObject @/link instances (has many, has one, belongs to).
 */
@interface APObject (RemoteRelationships)

/*!
 @method isRelationship:
 @abstract Checks if given property is a relationship.
 @param key Name of property to check.
 @result YES if property is a relationship.
 */
- (BOOL)isRelationship:(NSString *)key;
/*!
 @method isRelationshipLoaded:
 @abstract Checks if given relationship property has been loaded (fetched from remote server).
 @param key Name of property to check.
 @result YES if property is a relationship and has been loaded.
 */
- (BOOL)isRelationshipLoaded:(NSString *)key;
/*!
 @method areAllRelationshipsLoaded
 @abstract Checks all relationship properties have been loaded (fetched from remote server).
 @result YES if property has been loaded.
 */
- (BOOL)areAllRelationshipsLoaded;
/*!
 @method loadRelationship:error:
 @abstract Fetches related object(s) from remote server.
 @param key Name of relationship to load.
 @param error Error that has occured while executing the request, if any.
 */
- (void)loadRelationship:(NSString *)key error:(NSError **)error;
/*!
 @method loadRelationship:async:
 @abstract Fetches related object(s) from remote server in background.
 @param key Name of relationship to load.
 @param callback Callback to be executed when operation completes.
 */
- (void)loadRelationship:(NSString *)key async:(APCallback)callback;
/*!
 @method loadRelationshipsAsync:
 @abstract Fetches all relationship properties from remote server in background.
 @param callback Callback to be executed when operation completes.
 */
- (void)loadAllRelationshipsAsync:(APCallback)callback;
/*!
 @method valueForKeyPath:error:async:
 @abstract Gets value for given key path which may include relationships. If a relationship needs to be loaded, final value is returned asynchronously.
 @param keyPath Key path to load.
 @param error Error that has occured while executing the synchronous portion of request, if any.
 @param callback Callback to be executed when operation completes, with final value and/or error.
 @result Currently available value at given key path.
 */
- (id)valueForKeyPath:(NSString *)keyPath error:(NSError **)error async:(APObjectCallback)callback;
/*!
 @method isRelationship:forward:
 @abstract Checks if given property is a relationship and indicates relationship direction.
 @param key Name of property to check.
 @param forward YES if property is a forward relationship, NO otherwise. Undefined if property is not a relationship.
 @result YES if property is a relationship.
 */
+ (BOOL)isRelationship:(NSString *)key forward:(BOOL *)forward;
/*!
 @method isForeignKeyPropertyForRelationship:
 @abstract Checks whether property contains foreign key for given relationship.
 @param key Name of property to check.
 @param relationshipKey Name of relationship, if one is found.
 @result YES if property is the foreign key.
 */
+ (BOOL)isForeignKeyProperty:(NSString *)key forRelationship:(NSString **)relationshipKey;

@end
