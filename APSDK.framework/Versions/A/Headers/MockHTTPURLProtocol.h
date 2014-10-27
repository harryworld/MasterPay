//
//  MockHTTPURLProtocol.h
//  Tests
//
//  Created by AnyPresence, Inc. on 10/22/12.
//  Copyright (c) 2012 AnyPresence, Inc.. All rights reserved.
//

/*!
 @header MockHTTPURLProtocol
 @abstract MockHTTPURLProtocol class
 */

#import <Foundation/Foundation.h>

/*!
 @enum MockHTTPURLProtocolPathOptions
 @abstract Parameters for mock path.
 @constant MockHTTPURLProtocolPathOptionIncludePath Include resource path.
 @constant MockHTTPURLProtocolPathOptionIncludeQuery Include query parameters.
 */
enum {
    MockHTTPURLProtocolPathOptionIncludePath = 0x01,
    MockHTTPURLProtocolPathOptionIncludeQuery = 0x02
};
typedef NSUInteger MockHTTPURLProtocolPathOptions;

/*!
 @typedef InspectRequest
 @abstract Callback that allows for inspection of HTTP request.
 @param request HTTP request that will be sent.
 */
typedef void(^InspectRequest)(NSURLRequest * request);
/*!
 @typedef InspectResponse
 @abstract Callback that allows for inspection of HTTP response.
 @param response HTTP response that was received.
 @param data HTTP response body.
 */
typedef void(^InspectResponse)(NSURLResponse * response, NSData * data);

/*!
 @class MockHTTPURLProtocol
 @abstract Loads HTTP responses from "mock" folder in main bundle.
 @discussion Intended to be used for testing network operations.
 */
@interface MockHTTPURLProtocol : NSURLProtocol

/*!
 @method responsePath:options:
 @abstract Determines mock response path for given request.
 @param request HTTP request.
 @param options Parameters for mock path.
 @result Path for mock response.
 */
+ (NSString *)responsePath:(NSURLRequest *)request
                   options:(MockHTTPURLProtocolPathOptions)options;
/*!
 @method responsePath:
 @abstract Determines mock response path for given request, with default parameters.
 @param request HTTP request.
 @result Path for mock response.
 */
+ (NSString *)responsePath:(NSURLRequest *)request;
/*!
 @method setRequestCallback:
 @abstract Sets callback to inspect HTTP request before it is sent out.
 @param inspectRequest Callback that will receive HTTP request.
 */
+ (void)setRequestCallback:(InspectRequest)inspectRequest;
/*!
 @method setRequestCallback:
 @abstract Sets callback to inspect HTTP response after it is received.
 @param inspectResponse Callback that will receive HTTP response.
 */
+ (void)setResponseCallback:(InspectResponse)inspectResponse;

@end
