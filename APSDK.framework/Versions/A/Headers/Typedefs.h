//
//  Typedefs.h
//  AnyPresence SDK
//
//  Created by Ruslan Sokolov on 3/12/13.
//  Copyright (c) 2013 AnyPresence, Inc. All rights reserved.
//

/*!
 @header Typedefs
 @abstract Typedefs
 */

#ifndef AnyPresence_SDK_Typedefs_h
#define AnyPresence_SDK_Typedefs_h

/*!
 @typedef APCallback
 @abstract Simple callback.
 @param error Error that has occured while executing the request, if any.
 */
typedef void(^APCallback)(NSError * error);
/*!
 @typedef APObjectCallback
 @abstract Callback that returns one object.
 @param object Object.
 @param error Error that has occured while executing the request, if any.
 */
typedef void(^APObjectCallback)(id object, NSError * error);
/*!
 @typedef APObjectsCallback
 @abstract Callback that returns an array of objects.
 @param objects Array of objects.
 @param error Error that has occured while executing the request, if any.
 */
typedef void(^APObjectsCallback)(NSArray * objects, NSError * error);


#endif
