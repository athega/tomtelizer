//
//  MultipartRequestBuilder.h
//  sketch1
//
//  Created by Petter Petersson on 11/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const MPR_BOUNDARY = @"0xAthEgAb0unDaRy";
static NSString * const MPR_FORM_FLE_INPUT = @"uploaded";


@interface MultipartRequestBuilder : NSObject

- (NSURLRequest *)createMultiPartRequestForUrl: (NSURL *)url withFiles: (NSArray *)files andParameters: (NSArray *) params;

@end
