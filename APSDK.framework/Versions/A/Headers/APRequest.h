//
//  APRequest.h
//  Created by AnyPresence, Inc. on 9/13/12.
//

/*!
 @header APRequest
 @abstract APRequest class
 */

#import <Foundation/Foundation.h>

/*!
 @enum APRequestVerb
 @abstract Request operation.
 @constant kAPRequestVerbCreate Create.
 @constant kAPRequestVerbRead Read.
 @constant kAPRequestVerbUpdate Update.
 @constant kAPRequestVerbDelete Delete.
 */
typedef enum {
    kAPRequestVerbCreate,
    kAPRequestVerbRead,
    kAPRequestVerbUpdate,
    kAPRequestVerbDelete
} APRequestVerb;

/*!
 @typedef APRequestCallback
 @abstract Callback with response data.
 @param response Response data.
 @param error Error that has occured while executing the request, if any.
 */
typedef void(^APRequestCallback)(NSData * response, NSError * error);

/*!
 @const kAPRequestBaseURLException
 @abstract Exception thrown when no base URL has been set.
 */
extern NSString * const kAPRequestBaseURLException;
/*!
 @const kAPRequestConcurrentRequestException
 @abstract Exception thrown when request is instructed to load while already loading.
 */
extern NSString * const kAPRequestConcurrentRequestException;
/*!
 @const kAPRequestErrorDomain
 @abstract Default error domain for request errors.
 */
extern NSString * const kAPRequestErrorDomain;
/*!
 @const kAPRequestErrorServerError
 @abstract Indicates there was a server error. See userInfo for more details.
 */
extern const NSUInteger kAPRequestErrorServerError;
/*!
 @const kAPRequestErrorURLResponseKey
 @abstract Key for underlying NSHTTPURLResponse object in userInfo.
 */
extern NSString * const kAPRequestErrorURLResponseKey;
/*!
 @const kAPRequestErrorStatusCodeKey
 @abstract Key for HTTP status code in userInfo
 */
extern NSString * const kAPRequestErrorStatusCodeKey;
/*!
 @const kAPRequestErrorNotification
 @abstract Notification that is posted when a @link //apple_ref/occ/clm/APRequest @/link object encounters an error.
 */
extern NSString * const kAPRequestErrorNotification;
/*!
 @const kAPRequestErrorNotificationErrorKey
 @abstract Key for error that caused the @link //apple_ref/occ/clconst/APRequest/kAPRequestErrorNotification @/link.
 */
extern NSString * const kAPRequestErrorNotificationErrorKey;

/*!
 @class APRequest
 @abstract Utility class encapsulating an HTTP request.
 @discussion One request can be re-used in a serial manner. To reset a request, call @link //apple_ref/occ/instp/APRequest/abort @/link.
 */
@interface APRequest : NSObject

/*!
 @method initWithVerb:URL:
 @abstract Creates a request to load specified URL.
 @param verb Operation.
 @param URL URL to load.
 @result New request instance.
 */
- (id)initWithVerb:(APRequestVerb)verb URL:(NSURL *)URL;
/*!
 @method initWithVerb:resource:query:
 @abstract Creates a request to specified REST resource.
 @param verb Operation.
 @param name Name of REST resource.
 @param params Request parameters.
 @result New request instance.
 */
- (id)initWithVerb:(APRequestVerb)verb resource:(NSString *)name query:(NSDictionary *)params;
/*!
 @method setBody:as:
 @abstract Adds body to request.
 @param data Body contents.
 @param contentType MIME content type for body data.
 */
- (void)setBody:(NSData *)data as:(NSString *)contentType;
/*!
 @method load:
 @abstract Loads current request synchronously.
 @param error Error that occured while loading, if any.
 @result Data that has been loaded.
 */
- (NSData *)load:(NSError **)error;
/*!
 @method loadAsync:
 @abstract Loads current request in background.
 @param callback Callback to be execute after loading completes.
 */
- (void)loadAsync:(APRequestCallback)callback;
/*!
 @method abort
 @abstract Aborts current request. No callbacks will be fired.
 */
- (void)abort;
/*!
 @method setBaseURL:
 @abstract Sets base URL for subsequent requests to REST resources.
 @param URL New base URL.
 */
+ (void)setBaseURL:(NSURL *)URL;

@end
